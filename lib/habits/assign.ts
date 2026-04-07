import { createClient } from '@/lib/supabase/server'
import type { ArchetypeId, User, UserHabit, UserHabitLog } from '@/types/database'

// Max habits assigned per user at any time (MVP cap)
const MAX_HABITS = 6

// ============================================================
// Reinforcement messages keyed to streak milestones
// ============================================================
export const STREAK_MILESTONES: Record<number, string> = {
  1:  "Day 1. The hardest step is starting.",
  3:  "3 days straight. You're building something real.",
  7:  "One week. This is becoming who you are.",
  14: "Two weeks. Habits this strong don't break easy.",
  21: "Three weeks. This is locked in.",
  30: "30 days. This isn't a habit anymore — it's identity.",
}

export function getStreakMilestoneMessage(streak: number): string | null {
  return STREAK_MILESTONES[streak] ?? null
}

// ============================================================
// assignHabits
// Queries habit_templates matching the user's profile signals,
// then upserts into user_habits (skipping already-assigned ones).
// Called after profile_complete is set to true.
// ============================================================
export async function assignHabits(
  userId: string,
  profile: Partial<User>,
  archetypeId: ArchetypeId
): Promise<void> {
  const supabase = await createClient()

  // Fetch matching templates — NULL in a signal column = matches all
  // Priority order: most specific match (archetype + goal + fat_dist + env) first
  const { data: templates, error } = await supabase
    .from('habit_templates')
    .select('id, sort_order')
    .or(`archetype.eq.${archetypeId},archetype.is.null`)
    .or(`goal.eq.${profile.training_mode},goal.is.null`)
    .or(`fat_distribution.eq.${profile.fat_distribution ?? 'balanced'},fat_distribution.is.null`)
    .or(`workout_environment.eq.${profile.workout_environment ?? 'gym'},workout_environment.is.null`)
    .eq('is_active', true)
    .order('sort_order')
    .limit(MAX_HABITS * 3)  // fetch extra, de-dup below

  if (error || !templates) return

  // De-duplicate by id, take top MAX_HABITS
  const seen = new Set<string>()
  const topTemplates = templates
    .filter(t => { if (seen.has(t.id)) return false; seen.add(t.id); return true })
    .slice(0, MAX_HABITS)

  if (topTemplates.length === 0) return

  // Upsert — UNIQUE(user_id, habit_template_id) prevents duplicates
  const rows = topTemplates.map(t => ({
    user_id: userId,
    habit_template_id: t.id,
    is_active: true,
  }))

  await supabase
    .from('user_habits')
    .upsert(rows, { onConflict: 'user_id,habit_template_id', ignoreDuplicates: true })
}

// ============================================================
// refreshHabits
// Re-runs assignment after profile changes.
// Deactivates habits that no longer match updated profile.
// ============================================================
export async function refreshHabits(
  userId: string,
  profile: Partial<User>,
  archetypeId: ArchetypeId
): Promise<void> {
  const supabase = await createClient()

  // Get currently active user_habits with their templates
  const { data: current } = await supabase
    .from('user_habits')
    .select('id, habit_template_id, habit_templates(archetype, goal, fat_distribution, workout_environment, is_active)')
    .eq('user_id', userId)
    .eq('is_active', true)

  if (current) {
    // Deactivate habits that no longer match profile
    const toDeactivate = current.filter(uh => {
      const t = (uh as Record<string, unknown>).habit_templates as {
        archetype: string | null
        goal: string | null
        fat_distribution: string | null
        workout_environment: string | null
        is_active: boolean
      } | null
      if (!t || !t.is_active) return true
      if (t.archetype && t.archetype !== archetypeId) return true
      if (t.goal && t.goal !== profile.training_mode) return true
      if (t.fat_distribution && t.fat_distribution !== profile.fat_distribution) return true
      if (t.workout_environment && t.workout_environment !== profile.workout_environment) return true
      return false
    })

    if (toDeactivate.length > 0) {
      await supabase
        .from('user_habits')
        .update({ is_active: false })
        .in('id', toDeactivate.map(h => h.id))
    }
  }

  // Assign new habits for updated profile
  await assignHabits(userId, profile, archetypeId)
}

// ============================================================
// updateHabitStreak
// Called after a user_habit_log is inserted with completed=TRUE.
// Updates current_streak, longest_streak, last_completed_date.
// ============================================================
export async function updateHabitStreak(
  userHabitId: string,
  logDate: string
): Promise<{ newStreak: number; milestoneMessage: string | null }> {
  const supabase = await createClient()

  const { data: habit } = await supabase
    .from('user_habits')
    .select('current_streak, longest_streak, last_completed_date')
    .eq('id', userHabitId)
    .single()

  if (!habit) return { newStreak: 0, milestoneMessage: null }

  const today = new Date(logDate)
  const lastDate = habit.last_completed_date ? new Date(habit.last_completed_date) : null

  let newStreak = 1
  if (lastDate) {
    const diffMs = today.getTime() - lastDate.getTime()
    const diffDays = Math.round(diffMs / (1000 * 60 * 60 * 24))
    if (diffDays === 1) {
      newStreak = (habit.current_streak ?? 0) + 1
    } else if (diffDays === 0) {
      // Same day — don't update streak
      return { newStreak: habit.current_streak ?? 1, milestoneMessage: null }
    }
    // diffDays > 1: streak broken, reset to 1
  }

  const newLongest = Math.max(habit.longest_streak ?? 0, newStreak)

  await supabase
    .from('user_habits')
    .update({
      current_streak: newStreak,
      longest_streak: newLongest,
      last_completed_date: logDate,
    })
    .eq('id', userHabitId)

  const milestoneMessage = getStreakMilestoneMessage(newStreak)
  return { newStreak, milestoneMessage }
}

// ============================================================
// logHabit
// Upserts a daily log entry. If completed=TRUE, updates streak.
// Returns the streak info for display.
// ============================================================
export async function logHabit(
  userId: string,
  userHabitId: string,
  logDate: string,
  completed: boolean,
  valueLogged?: number
): Promise<{ newStreak: number; milestoneMessage: string | null } | null> {
  const supabase = await createClient()

  const { error } = await supabase
    .from('user_habit_logs')
    .upsert(
      { user_id: userId, user_habit_id: userHabitId, log_date: logDate, completed, value_logged: valueLogged ?? null },
      { onConflict: 'user_habit_id,log_date' }
    )

  if (error) return null

  if (completed) {
    return updateHabitStreak(userHabitId, logDate)
  }

  return { newStreak: 0, milestoneMessage: null }
}

// ============================================================
// getTodaysHabits
// Returns user's active habits with today's log status attached.
// ============================================================
export async function getTodaysHabits(
  userId: string
): Promise<Array<UserHabit & { habit_template: Record<string, unknown>; todays_log: UserHabitLog | null }>> {
  const supabase = await createClient()
  const today = new Date().toISOString().split('T')[0]

  const { data } = await supabase
    .from('user_habits')
    .select(`
      *,
      habit_template:habit_templates(*),
      todays_log:user_habit_logs(*)
    `)
    .eq('user_id', userId)
    .eq('is_active', true)
    .eq('user_habit_logs.log_date', today)
    .order('habit_templates(sort_order)')

  return (data ?? []) as Array<UserHabit & { habit_template: Record<string, unknown>; todays_log: UserHabitLog | null }>
}
