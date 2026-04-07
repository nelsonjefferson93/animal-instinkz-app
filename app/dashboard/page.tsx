import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import { ARCHETYPES } from '@/lib/archetype/profiles'
import { calculateNutrition } from '@/lib/nutrition/engine'
import { getEnvironmentLabel } from '@/lib/training/engine'
import { getActiveAdaptations } from '@/lib/adaptation/engine'
import { getStreakMilestoneMessage } from '@/lib/habits/assign'
import type { UserArchetype, User, UserHabit, HabitTemplate, UserHabitLog, AdaptationEvent, UserProgressLog } from '@/types/database'
import BottomNav from '@/components/layout/BottomNav'
import AdaptationPanel from '@/components/dashboard/AdaptationPanel'

export default async function DashboardPage() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect('/login')

  const today = new Date().toISOString().split('T')[0]

  // Fetch all dashboard data in parallel
  const [profileRes, archetypeRes, hundredRes, streakRes, todaysHabitsRes, progressRes, adaptationEvents] = await Promise.all([
    supabase.from('users').select('*').eq('id', user.id).single(),
    supabase.from('user_archetypes').select('*').eq('user_id', user.id).eq('is_active', true).single(),
    supabase.from('user_hundred_series_progress').select('*').eq('user_id', user.id).single(),
    supabase.from('streaks').select('*').eq('user_id', user.id).single(),
    // New habits system
    supabase
      .from('user_habits')
      .select('*, habit_template:habit_templates(*), user_habit_logs!inner(log_date, completed, value_logged)')
      .eq('user_id', user.id)
      .eq('is_active', true)
      .eq('user_habit_logs.log_date', today),
    // Weekly progress for adherence section
    supabase
      .from('user_progress_logs')
      .select('*')
      .eq('user_id', user.id)
      .order('week_start', { ascending: false })
      .limit(1),
    getActiveAdaptations(user.id),
  ])

  const profile = profileRes.data as User | null
  const userArchetype = archetypeRes.data as UserArchetype | null
  const hundredProgress = hundredRes.data
  const streak = streakRes.data
  const progressLog = (progressRes.data?.[0] ?? null) as UserProgressLog | null

  // Fetch active habits without the log join (simpler query for habits that don't have a log yet)
  const { data: activeHabitsRaw } = await supabase
    .from('user_habits')
    .select('*, habit_template:habit_templates(*)')
    .eq('user_id', user.id)
    .eq('is_active', true)
    .order('habit_templates(sort_order)')

  // Fetch today's logs separately and merge
  const { data: todayLogs } = await supabase
    .from('user_habit_logs')
    .select('*')
    .eq('user_id', user.id)
    .eq('log_date', today)

  const todayLogMap = new Map((todayLogs ?? []).map((l: UserHabitLog) => [l.user_habit_id, l]))
  const todaysHabits = (activeHabitsRaw ?? []).map((uh: UserHabit & { habit_template: HabitTemplate }) => ({
    ...uh,
    todays_log: todayLogMap.get(uh.id) ?? null,
  }))

  const archetype = userArchetype?.primary_archetype
    ? ARCHETYPES[userArchetype.primary_archetype]
    : null

  const HUNDRED_LEVELS = [20, 40, 60, 80, 100]
  const currentLevel = hundredProgress?.current_level ?? 20
  const currentLevelIndex = HUNDRED_LEVELS.indexOf(currentLevel)

  // Calculate nutrition targets if profile is complete
  const nutritionTargets = profile?.profile_complete
    ? calculateNutrition(profile, progressLog?.habits_completed_rate ?? undefined)
    : null

  // Environment badge
  const envLabel = profile?.profile_complete ? getEnvironmentLabel(profile) : null

  // Check for any habit streak milestones today
  const habitMilestoneMessage = todaysHabits.reduce<string | null>((msg, uh) => {
    if (msg) return msg
    if (uh.todays_log?.completed) {
      return getStreakMilestoneMessage(uh.current_streak) ?? null
    }
    return null
  }, null)

  const events = adaptationEvents as AdaptationEvent[]
  const pendingEvents = events.filter(e => e.status === 'pending_approval')
  const activeEvents = events.filter(e => e.status === 'active' || e.status === 'approved')

  return (
    <div className="flex flex-col min-h-dvh bg-brand-black pb-24">
      {/* Header */}
      <div className="page-padding pt-10 pb-4 flex items-start justify-between">
        <div>
          <p className="text-brand-gray-muted text-xs uppercase tracking-widest">Today</p>
          <h1 className="font-display text-4xl text-brand-offwhite mt-1">DASHBOARD</h1>
        </div>
        {archetype && (
          <div
            className="px-3 py-1 rounded-full border text-xs font-heading font-bold"
            style={{ borderColor: archetype.color_accent, color: archetype.color_accent }}
          >
            THE {archetype.display_name.toUpperCase()}
          </div>
        )}
      </div>

      {/* Complete profile CTA */}
      {profile && !profile.profile_complete && (
        <div className="page-padding mb-4">
          <a href="/profile-setup">
            <div className="bg-brand-gray border border-brand-green rounded-2xl p-4 flex items-center justify-between">
              <div>
                <p className="font-heading font-bold text-brand-green text-sm">Complete Your Profile</p>
                <p className="text-brand-gray-muted text-xs mt-0.5">Unlock personalized nutrition, habits &amp; adaptive coaching</p>
              </div>
              <span className="text-brand-green text-xl ml-3">→</span>
            </div>
          </a>
        </div>
      )}

      {/* Streak milestone message */}
      {habitMilestoneMessage && (
        <div className="page-padding mb-2">
          <div className="bg-brand-green/10 border border-brand-green rounded-xl px-4 py-3">
            <p className="text-brand-green text-sm font-heading font-bold">{habitMilestoneMessage}</p>
          </div>
        </div>
      )}

      <div className="page-padding flex flex-col gap-4">
        {/* Today's Workout */}
        <div className="bg-brand-gray rounded-2xl p-5">
          <div className="flex items-center justify-between mb-3">
            <p className="text-brand-gray-muted text-xs uppercase tracking-widest">Today&apos;s Workout</p>
            {envLabel && (
              <span className="text-xs font-heading font-bold text-brand-green border border-brand-green px-2 py-0.5 rounded-full">
                {envLabel.mode}
              </span>
            )}
          </div>
          <p className="font-heading font-bold text-brand-offwhite text-lg mb-1">
            {archetype ? `${archetype.display_name} — ${profile?.training_mode?.replace('_', ' ').toUpperCase() ?? 'GENERAL'} BLOCK` : 'No workout loaded'}
          </p>
          {envLabel && (
            <p className="text-brand-gray-muted text-xs mb-3">{envLabel.subtitle}</p>
          )}
          {!envLabel && <p className="text-brand-gray-muted text-sm mb-4">Ready when you are.</p>}
          <a href="/train">
            <button className="w-full bg-brand-green text-white font-heading font-bold py-3 rounded-lg text-sm uppercase tracking-wide active:bg-brand-green-light transition-colors">
              Start Workout
            </button>
          </a>
        </div>

        {/* Today's Nutrition Targets */}
        {nutritionTargets ? (
          <div className="bg-brand-gray rounded-2xl p-5">
            <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-3">Today&apos;s Nutrition</p>
            {nutritionTargets.guidance_mode === 'macro' ? (
              <>
                <div className="grid grid-cols-3 gap-2 text-center mb-3">
                  <div>
                    <p className="font-heading font-bold text-brand-green text-xl">{nutritionTargets.calories}</p>
                    <p className="text-brand-gray-muted text-xs mt-0.5">kcal</p>
                  </div>
                  <div>
                    <p className="font-heading font-bold text-brand-offwhite text-xl">{nutritionTargets.protein_g}g</p>
                    <p className="text-brand-gray-muted text-xs mt-0.5">protein</p>
                  </div>
                  <div>
                    <p className="font-heading font-bold text-brand-offwhite text-xl">{nutritionTargets.hydration_liters}L</p>
                    <p className="text-brand-gray-muted text-xs mt-0.5">water</p>
                  </div>
                </div>
                <div className="grid grid-cols-2 gap-2 text-center pt-3 border-t border-brand-gray-light">
                  <div>
                    <p className="font-heading font-bold text-brand-offwhite text-base">{nutritionTargets.carbs_g}g</p>
                    <p className="text-brand-gray-muted text-xs">carbs</p>
                  </div>
                  <div>
                    <p className="font-heading font-bold text-brand-offwhite text-base">{nutritionTargets.fats_g}g</p>
                    <p className="text-brand-gray-muted text-xs">fats</p>
                  </div>
                </div>
                {nutritionTargets.deficit_surplus !== 0 && (
                  <p className="text-brand-gray-muted text-xs text-center mt-2">
                    {nutritionTargets.deficit_surplus < 0
                      ? `${Math.abs(nutritionTargets.deficit_surplus)} kcal deficit`
                      : `${nutritionTargets.deficit_surplus} kcal surplus`}
                  </p>
                )}
              </>
            ) : (
              <div>
                <p className="text-brand-gray-muted text-xs mb-3">{nutritionTargets.behavioral_reason}</p>
                <div className="flex flex-col gap-2">
                  {(nutritionTargets.behavioral_tips ?? []).map((tip, i) => (
                    <div key={i} className="flex items-start gap-2">
                      <span className="text-brand-green text-xs mt-0.5 flex-shrink-0">→</span>
                      <p className="text-brand-offwhite text-sm">{tip}</p>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>
        ) : profile && !profile.profile_complete ? null : null}

        {/* Today's Habits */}
        {todaysHabits.length > 0 ? (
          <div className="bg-brand-gray rounded-2xl p-5">
            <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-3">Today&apos;s Habits</p>
            <div className="flex flex-col gap-3">
              {todaysHabits.map((uh) => {
                const t = uh.habit_template as HabitTemplate
                const log = uh.todays_log as UserHabitLog | null
                const isComplete = log?.completed ?? false
                const streakCount = (uh as UserHabit).current_streak

                return (
                  <div key={uh.id} className="flex items-center justify-between">
                    <div className="flex-1 min-w-0">
                      <p className={`font-heading font-bold text-sm ${isComplete ? 'text-brand-green' : 'text-brand-offwhite'}`}>
                        {t.habit_name}
                      </p>
                      {streakCount > 0 && (
                        <p className="text-brand-gray-muted text-xs">
                          🔥 {streakCount} day streak
                        </p>
                      )}
                    </div>
                    <div className={`w-6 h-6 rounded-full border-2 flex items-center justify-center flex-shrink-0 ml-3 ${
                      isComplete ? 'bg-brand-green border-brand-green' : 'border-brand-gray-light'
                    }`}>
                      {isComplete && <span className="text-white text-xs">✓</span>}
                    </div>
                  </div>
                )
              })}
            </div>
          </div>
        ) : (
          <div className="bg-brand-gray rounded-2xl p-5">
            <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-3">Today&apos;s Habits</p>
            <p className="text-brand-gray-muted text-sm">
              {profile?.profile_complete
                ? 'No habits assigned yet. Complete a check-in to activate your habit plan.'
                : 'Complete your profile to get your personalized habit list.'}
            </p>
          </div>
        )}

        {/* 100 Series Progress */}
        <div className="bg-brand-gray rounded-2xl p-5">
          <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-3">100 Series</p>
          <p className="font-heading font-bold text-brand-offwhite text-base mb-3">
            Level {currentLevelIndex + 1} — {currentLevel} Reps
          </p>
          <div className="flex gap-2 mb-4">
            {HUNDRED_LEVELS.map((level, i) => (
              <div key={level} className="flex-1 flex flex-col items-center gap-1">
                <div className={`w-full h-2 rounded-full ${i <= currentLevelIndex ? 'bg-brand-green' : 'bg-brand-gray-light'}`} />
                <span className="text-xs text-brand-gray-muted">{level}</span>
              </div>
            ))}
          </div>
          <a href="/hundred">
            <button className="w-full border border-brand-green text-brand-green font-heading font-bold py-3 rounded-lg text-sm uppercase tracking-wide active:bg-brand-green active:text-white transition-colors">
              Attempt Today
            </button>
          </a>
        </div>

        {/* Streak */}
        <div className="bg-brand-gray rounded-2xl p-5 flex items-center justify-between">
          <div>
            <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-1">Current Streak</p>
            <p className="font-display text-4xl text-brand-offwhite">{streak?.current_streak ?? 0} DAYS</p>
          </div>
          <span className="text-5xl">🔥</span>
        </div>

        {/* Weekly Adherence */}
        {progressLog && (
          <div className="bg-brand-gray rounded-2xl p-5">
            <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-3">This Week</p>
            <div className="grid grid-cols-3 gap-3 text-center">
              <div>
                <p className="font-heading font-bold text-brand-offwhite text-lg">
                  {progressLog.workouts_completed}
                </p>
                <p className="text-brand-gray-muted text-xs">workouts</p>
              </div>
              <div>
                <p className="font-heading font-bold text-brand-offwhite text-lg">
                  {progressLog.habits_completed_rate !== null
                    ? `${Math.round(progressLog.habits_completed_rate * 100)}%`
                    : '—'}
                </p>
                <p className="text-brand-gray-muted text-xs">habits</p>
              </div>
              <div>
                <p className="font-heading font-bold text-brand-offwhite text-lg">
                  {progressLog.avg_energy !== null ? progressLog.avg_energy.toFixed(1) : '—'}
                </p>
                <p className="text-brand-gray-muted text-xs">avg energy</p>
              </div>
            </div>
            <a href="/checkin">
              <button type="button" className="w-full mt-3 border border-brand-gray-light text-brand-gray-muted font-heading font-bold py-2.5 rounded-lg text-xs uppercase tracking-widest active:bg-brand-gray-light transition-colors">
                Submit Weekly Check-In
              </button>
            </a>
          </div>
        )}

        {/* Check-in CTA (when no progress log yet) */}
        {!progressLog && profile?.profile_complete && (
          <a href="/checkin">
            <div className="bg-brand-gray rounded-2xl p-5 flex items-center justify-between">
              <div>
                <p className="font-heading font-bold text-brand-offwhite text-sm">Weekly Check-In</p>
                <p className="text-brand-gray-muted text-xs mt-0.5">Log your signals so your plan can adapt</p>
              </div>
              <span className="text-brand-green text-xl">→</span>
            </div>
          </a>
        )}

        {/* Plan Adjustments */}
        {(pendingEvents.length > 0 || activeEvents.length > 0) && (
          <AdaptationPanel
            pendingEvents={pendingEvents}
            activeEvents={activeEvents}
            isGuided={profile?.adaptation_mode === 'guided'}
          />
        )}
      </div>

      <BottomNav active="home" />
    </div>
  )
}
