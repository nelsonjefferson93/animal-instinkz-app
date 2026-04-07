import { createClient } from '@/lib/supabase/server'
import type { User, UserProgressLog, AdaptationEvent } from '@/types/database'

// ============================================================
// Confidence scoring weights
// Minimum score of 70 required before any adaptation fires.
// ============================================================
function computeConfidenceScore(params: {
  checkinCount: number
  hasWorkoutLogs: boolean
  habitLogDays: number
  hasPriorWeek: boolean
}): number {
  let score = 0
  if (params.checkinCount >= 2) score += 30
  else if (params.checkinCount === 1) score += 15
  if (params.hasWorkoutLogs) score += 30
  if (params.habitLogDays >= 4) score += 25
  else if (params.habitLogDays >= 2) score += 10
  if (params.hasPriorWeek) score += 15
  return Math.min(score, 100)
}

// ============================================================
// computeWeeklyProgress
// Aggregates the past 7 days of data into a UserProgressLog row.
// Writes/upserts the result to user_progress_logs.
// ============================================================
export async function computeWeeklyProgress(
  userId: string,
  weekStart: string  // ISO date string: YYYY-MM-DD (Monday)
): Promise<UserProgressLog | null> {
  const supabase = await createClient()

  const weekEnd = new Date(weekStart)
  weekEnd.setDate(weekEnd.getDate() + 6)
  const weekEndStr = weekEnd.toISOString().split('T')[0]

  // Gather all signals in parallel
  const [workoutsRes, habitLogsRes, checkinsRes, priorWeekRes] = await Promise.all([
    supabase.from('workout_logs')
      .select('id', { count: 'exact', head: false })
      .eq('user_id', userId)
      .gte('completed_at', `${weekStart}T00:00:00`)
      .lte('completed_at', `${weekEndStr}T23:59:59`),

    supabase.from('user_habit_logs')
      .select('log_date, completed')
      .eq('user_id', userId)
      .gte('log_date', weekStart)
      .lte('log_date', weekEndStr),

    supabase.from('user_checkins')
      .select('energy_level, sleep_quality, stress_level, weight_lbs, checkin_date')
      .eq('user_id', userId)
      .gte('checkin_date', weekStart)
      .lte('checkin_date', weekEndStr),

    supabase.from('user_progress_logs')
      .select('id')
      .eq('user_id', userId)
      .lt('week_start', weekStart)
      .order('week_start', { ascending: false })
      .limit(1),
  ])

  const workoutsCompleted = workoutsRes.count ?? 0
  const habitLogs = habitLogsRes.data ?? []
  const checkins = checkinsRes.data ?? []
  const hasPriorWeek = (priorWeekRes.data?.length ?? 0) > 0

  // Habit completion rate
  const totalHabitLogs = habitLogs.length
  const completedHabitLogs = habitLogs.filter(l => l.completed).length
  const habitsCompletedRate = totalHabitLogs > 0
    ? Math.round((completedHabitLogs / totalHabitLogs) * 100) / 100
    : null

  // Checkin averages
  const avgEnergy = checkins.length > 0
    ? Math.round((checkins.reduce((s, c) => s + (c.energy_level ?? 0), 0) / checkins.length) * 10) / 10
    : null
  const avgSleep = checkins.length > 0
    ? Math.round((checkins.reduce((s, c) => s + (c.sleep_quality ?? 0), 0) / checkins.length) * 10) / 10
    : null
  const avgStress = checkins.length > 0
    ? Math.round((checkins.reduce((s, c) => s + (c.stress_level ?? 0), 0) / checkins.length) * 10) / 10
    : null

  // Unique habit log days
  const habitLogDays = new Set(habitLogs.map(l => l.log_date)).size

  const confidenceScore = computeConfidenceScore({
    checkinCount: checkins.length,
    hasWorkoutLogs: workoutsCompleted > 0,
    habitLogDays,
    hasPriorWeek,
  })

  const row = {
    user_id: userId,
    week_start: weekStart,
    workouts_completed: workoutsCompleted,
    workouts_scheduled: 0,  // set externally if workout_days_per_week is known
    habits_completed_rate: habitsCompletedRate,
    avg_energy: avgEnergy,
    avg_sleep_quality: avgSleep,
    avg_stress: avgStress,
    weight_change_lbs: null,  // requires comparing to prior week checkin
    confidence_score: confidenceScore,
  }

  const { data, error } = await supabase
    .from('user_progress_logs')
    .upsert(row, { onConflict: 'user_id,week_start' })
    .select()
    .single()

  if (error || !data) return null
  return data as UserProgressLog
}

// ============================================================
// runAdaptation
// Evaluates adaptation rules in priority order.
// Returns the single highest-priority event, or null if:
//   - confidence < 70
//   - debounce: same event type fired last week
//   - no rules match
// ============================================================
export async function runAdaptation(
  userId: string,
  progressLog: UserProgressLog,
  profile: Partial<User>
): Promise<AdaptationEvent | null> {
  const supabase = await createClient()

  // Gate: insufficient data
  if (progressLog.confidence_score < 70) return null

  // Get last week's events for debounce check
  const oneWeekAgo = new Date(progressLog.week_start)
  oneWeekAgo.setDate(oneWeekAgo.getDate() - 7)
  const { data: recentEvents } = await supabase
    .from('adaptation_events')
    .select('event_type')
    .eq('user_id', userId)
    .gte('event_date', oneWeekAgo.toISOString().split('T')[0])
    .neq('status', 'dismissed')

  const recentEventTypes = new Set((recentEvents ?? []).map(e => e.event_type))

  // Fetch prior week for trend comparisons
  const priorWeekStart = new Date(progressLog.week_start)
  priorWeekStart.setDate(priorWeekStart.getDate() - 7)
  const { data: priorWeek } = await supabase
    .from('user_progress_logs')
    .select('habits_completed_rate, avg_energy, avg_sleep_quality, avg_stress, weight_change_lbs')
    .eq('user_id', userId)
    .eq('week_start', priorWeekStart.toISOString().split('T')[0])
    .single()

  const scheduledDays = profile.workout_days_per_week ?? 4
  const workoutAdherence = progressLog.workouts_completed / scheduledDays
  const habitAdherence = progressLog.habits_completed_rate ?? 1
  const priorHabitAdherence = priorWeek?.habits_completed_rate ?? null
  const avgEnergy = progressLog.avg_energy ?? 3
  const avgSleep = progressLog.avg_sleep_quality ?? 3
  const avgStress = progressLog.avg_stress ?? 3
  const priorEnergy = priorWeek?.avg_energy ?? null
  const priorSleep = priorWeek?.avg_sleep_quality ?? null
  const sessionLength = profile.session_length_minutes ?? 60

  type EventPayload = Omit<AdaptationEvent, 'id' | 'user_id' | 'created_at' | 'dismissed_at' | 'approved_at'>

  let candidate: EventPayload | null = null

  // ─── PRIORITY 1: HABITS ───────────────────────────────────
  if (!recentEventTypes.has('habits_simplified')) {
    const habitsTwoWeeksLow =
      habitAdherence < 0.4 &&
      priorHabitAdherence !== null &&
      priorHabitAdherence < 0.4

    if (habitsTwoWeeksLow) {
      candidate = {
        event_date: new Date().toISOString().split('T')[0],
        event_type: 'habits_simplified',
        priority_tier: 1,
        old_value: null,
        new_value: '3',  // narrow to top 3 habits
        reason: `Your habit completion rate has been below 40% for two weeks. We've narrowed your list to your top 3 highest-impact habits so you can build momentum.`,
        reinforcement: `Small wins build big habits. Lock these three in first — then expand.`,
        confidence_score: progressLog.confidence_score,
        week_start: progressLog.week_start,
        status: profile.adaptation_mode === 'guided' ? 'pending_approval' : 'active',
      }
    }
  }

  // ─── PRIORITY 2: TRAINING ─────────────────────────────────
  if (!candidate && !recentEventTypes.has('session_shortened')) {
    if (workoutAdherence < 0.5) {
      const adjustedLength = Math.max(20, sessionLength - 15)
      candidate = {
        event_date: new Date().toISOString().split('T')[0],
        event_type: 'session_shortened',
        priority_tier: 2,
        old_value: String(sessionLength),
        new_value: String(adjustedLength),
        reason: `You completed ${progressLog.workouts_completed} of ${scheduledDays} sessions this week. Session length adjusted to ${adjustedLength} minutes to lower the barrier to showing up.`,
        reinforcement: `Showing up consistently beats perfect sessions every time. Short sessions still count.`,
        confidence_score: progressLog.confidence_score,
        week_start: progressLog.week_start,
        status: profile.adaptation_mode === 'guided' ? 'pending_approval' : 'active',
      }
    }
  }

  if (!candidate && !recentEventTypes.has('volume_reduced')) {
    const recoveryLow = avgEnergy < 2.5 || avgSleep < 2.5
    const priorRecoveryLow = (priorEnergy !== null && priorEnergy < 2.5) || (priorSleep !== null && priorSleep < 2.5)
    if (recoveryLow && priorRecoveryLow) {
      candidate = {
        event_date: new Date().toISOString().split('T')[0],
        event_type: 'volume_reduced',
        priority_tier: 2,
        old_value: null,
        new_value: 'reduced',
        reason: `Your recovery signals — sleep and energy — have been low for two consecutive weeks. Weekly training volume has been reduced to protect your progress.`,
        reinforcement: `Recovery is training. Protecting your body now is how you win long-term.`,
        confidence_score: progressLog.confidence_score,
        week_start: progressLog.week_start,
        status: profile.adaptation_mode === 'guided' ? 'pending_approval' : 'active',
      }
    }
  }

  if (!candidate && !recentEventTypes.has('deload_recommended')) {
    const stressAndSleepCrisis = avgStress >= 4 && avgSleep < 2.5
    const priorStressAndSleepCrisis = (priorWeek?.avg_stress ?? 0) >= 4 && (priorWeek?.avg_sleep_quality ?? 5) < 2.5
    if (stressAndSleepCrisis && priorStressAndSleepCrisis) {
      candidate = {
        event_date: new Date().toISOString().split('T')[0],
        event_type: 'deload_recommended',
        priority_tier: 2,
        old_value: null,
        new_value: 'deload',
        reason: `Stress and sleep quality have both been consistently poor. A deload week is recommended — reduce weight to 60%, focus on movement quality and recovery.`,
        reinforcement: `Rest isn't quitting. It's how you come back stronger. This is part of the plan.`,
        confidence_score: progressLog.confidence_score,
        week_start: progressLog.week_start,
        status: profile.adaptation_mode === 'guided' ? 'pending_approval' : 'active',
      }
    }
  }

  // ─── PRIORITY 3: NUTRITION ────────────────────────────────
  if (!candidate && !recentEventTypes.has('calories_adjusted')) {
    const goal = profile.training_mode
    const goodAdherence = habitAdherence >= 0.75 && workoutAdherence >= 0.75
    const weightStalled = progressLog.weight_change_lbs !== null &&
      Math.abs(progressLog.weight_change_lbs) < 0.5 &&
      priorWeek !== null && priorWeek?.weight_change_lbs !== null &&
      Math.abs(priorWeek.weight_change_lbs ?? 0) < 0.5

    if (goal === 'fat_loss' && weightStalled && goodAdherence) {
      candidate = {
        event_date: new Date().toISOString().split('T')[0],
        event_type: 'calories_adjusted',
        priority_tier: 3,
        old_value: null,
        new_value: '-150',
        reason: `Fat loss has stalled for two weeks and your adherence is strong. Calories reduced by 150 to reignite progress.`,
        reinforcement: `You've earned this adjustment. Your consistency is exactly what made it safe to make.`,
        confidence_score: progressLog.confidence_score,
        week_start: progressLog.week_start,
        status: profile.adaptation_mode === 'guided' ? 'pending_approval' : 'active',
      }
    }

    if (goal === 'muscle_gain' && weightStalled && goodAdherence) {
      candidate = {
        event_date: new Date().toISOString().split('T')[0],
        event_type: 'calories_adjusted',
        priority_tier: 3,
        old_value: null,
        new_value: '+150',
        reason: `Growth has plateaued for two weeks. Increasing calories by 150 to fuel your next phase.`,
        reinforcement: `Muscle needs fuel. You've proven you're consistent enough to grow — now feed it.`,
        confidence_score: progressLog.confidence_score,
        week_start: progressLog.week_start,
        status: profile.adaptation_mode === 'guided' ? 'pending_approval' : 'active',
      }
    }
  }

  if (!candidate) return null

  // Write the event
  const { data, error } = await supabase
    .from('adaptation_events')
    .insert({ ...candidate, user_id: userId })
    .select()
    .single()

  if (error || !data) return null

  // If 'auto' mode and habits_simplified: deactivate lower-priority habits
  if (data.status === 'active' && data.event_type === 'habits_simplified') {
    await simplifyHabits(userId)
  }

  // If 'auto' mode and session_shortened: update profile
  if (data.status === 'active' && data.event_type === 'session_shortened' && data.new_value) {
    await supabase
      .from('users')
      .update({ session_length_minutes: parseInt(data.new_value) })
      .eq('id', userId)
  }

  return data as AdaptationEvent
}

// ============================================================
// simplifyHabits
// Keeps only the top 3 active habits (by sort_order of their template).
// Deactivates the rest. Called when habits_simplified event fires.
// ============================================================
async function simplifyHabits(userId: string): Promise<void> {
  const supabase = await createClient()

  const { data: habits } = await supabase
    .from('user_habits')
    .select('id, habit_template_id, habit_templates(sort_order)')
    .eq('user_id', userId)
    .eq('is_active', true)
    .order('habit_templates(sort_order)')

  if (!habits || habits.length <= 3) return

  const toDeactivate = habits.slice(3).map(h => h.id)
  await supabase
    .from('user_habits')
    .update({ is_active: false })
    .in('id', toDeactivate)
}

// ============================================================
// approveAdaptation
// For guided mode: user approves a pending event.
// Applies the adaptation (session length update, etc).
// ============================================================
export async function approveAdaptation(
  eventId: string,
  userId: string
): Promise<void> {
  const supabase = await createClient()

  const { data: event } = await supabase
    .from('adaptation_events')
    .update({ status: 'approved', approved_at: new Date().toISOString() })
    .eq('id', eventId)
    .eq('user_id', userId)
    .select()
    .single()

  if (!event) return

  // Apply side effects
  if (event.event_type === 'habits_simplified') {
    await simplifyHabits(userId)
  }
  if (event.event_type === 'session_shortened' && event.new_value) {
    await supabase
      .from('users')
      .update({ session_length_minutes: parseInt(event.new_value) })
      .eq('id', userId)
  }
}

// ============================================================
// dismissAdaptation
// User dismisses a pending or active event — won't apply.
// ============================================================
export async function dismissAdaptation(
  eventId: string,
  userId: string
): Promise<void> {
  const supabase = await createClient()
  await supabase
    .from('adaptation_events')
    .update({ status: 'dismissed', dismissed_at: new Date().toISOString() })
    .eq('id', eventId)
    .eq('user_id', userId)
}

// ============================================================
// getActiveAdaptations
// Returns adaptation events from the last 30 days that are
// visible to the user (not dismissed).
// ============================================================
export async function getActiveAdaptations(userId: string): Promise<AdaptationEvent[]> {
  const supabase = await createClient()
  const thirtyDaysAgo = new Date()
  thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30)

  const { data } = await supabase
    .from('adaptation_events')
    .select('*')
    .eq('user_id', userId)
    .neq('status', 'dismissed')
    .gte('event_date', thirtyDaysAgo.toISOString().split('T')[0])
    .order('event_date', { ascending: false })

  return (data ?? []) as AdaptationEvent[]
}

// ============================================================
// getWeekStart
// Returns the Monday of the current week as YYYY-MM-DD.
// ============================================================
export function getWeekStart(date: Date = new Date()): string {
  const d = new Date(date)
  const day = d.getDay()
  const diff = d.getDate() - day + (day === 0 ? -6 : 1)
  d.setDate(diff)
  return d.toISOString().split('T')[0]
}
