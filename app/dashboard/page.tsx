import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import { ARCHETYPES } from '@/lib/archetype/profiles'
import type { UserArchetype } from '@/types/database'
import BottomNav from '@/components/layout/BottomNav'

export default async function DashboardPage() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect('/login')

  // Fetch user profile + archetype + hundred series progress in parallel
  const [profileRes, archetypeRes, hundredRes, habitsRes, streakRes] = await Promise.all([
    supabase.from('users').select('*').eq('id', user.id).single(),
    supabase.from('user_archetypes').select('*').eq('user_id', user.id).eq('is_active', true).single(),
    supabase.from('user_hundred_series_progress').select('*').eq('user_id', user.id).single(),
    supabase.from('habit_logs').select('*, habit:habits(*)').eq('user_id', user.id).eq('logged_date', new Date().toISOString().split('T')[0]),
    supabase.from('streaks').select('*').eq('user_id', user.id).single(),
  ])

  const profile = profileRes.data
  const userArchetype = archetypeRes.data as UserArchetype | null
  const hundredProgress = hundredRes.data
  const streak = streakRes.data

  const archetype = userArchetype?.primary_archetype
    ? ARCHETYPES[userArchetype.primary_archetype]
    : null

  const HUNDRED_LEVELS = [20, 40, 60, 80, 100]
  const currentLevel = hundredProgress?.current_level ?? 20
  const currentLevelIndex = HUNDRED_LEVELS.indexOf(currentLevel)

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

      <div className="page-padding flex flex-col gap-4">
        {/* Today's Workout */}
        <div className="bg-brand-gray rounded-2xl p-5">
          <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-3">Today&apos;s Workout</p>
          <p className="font-heading font-bold text-brand-offwhite text-lg mb-1">
            {archetype ? `${archetype.display_name} — ${profile?.training_mode?.replace('_', ' ').toUpperCase() ?? 'GENERAL'} BLOCK` : 'No workout loaded'}
          </p>
          <p className="text-brand-gray-muted text-sm mb-4">Ready when you are.</p>
          <a href="/train">
            <button
              className="w-full bg-brand-green text-white font-heading font-bold py-3 rounded-lg text-sm uppercase tracking-wide active:bg-brand-green-light transition-colors"
            >
              Start Workout
            </button>
          </a>
        </div>

        {/* 100 Series Progress */}
        <div className="bg-brand-gray rounded-2xl p-5">
          <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-3">100 Series</p>
          <p className="font-heading font-bold text-brand-offwhite text-base mb-3">
            Level {currentLevelIndex + 1} — {currentLevel} Reps
          </p>
          <div className="flex gap-2 mb-4">
            {HUNDRED_LEVELS.map((level, i) => (
              <div key={level} className="flex-1 flex flex-col items-center gap-1">
                <div
                  className={`w-full h-2 rounded-full ${i <= currentLevelIndex ? 'bg-brand-green' : 'bg-brand-gray-light'}`}
                />
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

        {/* Habits — placeholder (requires habit data to be seeded) */}
        <div className="bg-brand-gray rounded-2xl p-5">
          <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-3">Today&apos;s Habits</p>
          <p className="text-brand-gray-muted text-sm">
            Habits load once archetypes are seeded in Supabase.
          </p>
        </div>
      </div>

      <BottomNav active="home" />
    </div>
  )
}
