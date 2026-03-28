import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import { ARCHETYPES } from '@/lib/archetype/profiles'
import BottomNav from '@/components/layout/BottomNav'

export default async function ProfilePage() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect('/login')

  const [profileRes, archetypeRes, hundredRes, streakRes, workoutCountRes] = await Promise.all([
    supabase.from('users').select('*').eq('id', user.id).single(),
    supabase.from('user_archetypes').select('*').eq('user_id', user.id).eq('is_active', true).single(),
    supabase.from('user_hundred_series_progress').select('*').eq('user_id', user.id).single(),
    supabase.from('streaks').select('*').eq('user_id', user.id).single(),
    supabase.from('workout_logs').select('id', { count: 'exact' }).eq('user_id', user.id),
  ])

  const profile = profileRes.data
  const userArchetype = archetypeRes.data
  const hundredProgress = hundredRes.data
  const streak = streakRes.data

  const archetype = userArchetype?.primary_archetype
    ? ARCHETYPES[userArchetype.primary_archetype as keyof typeof ARCHETYPES]
    : null
  const secondary = userArchetype?.secondary_archetype
    ? ARCHETYPES[userArchetype.secondary_archetype as keyof typeof ARCHETYPES]
    : null

  const LEVELS = [20, 40, 60, 80, 100]
  const currentLevel = hundredProgress?.current_level ?? 20
  const levelIndex = LEVELS.indexOf(currentLevel)

  async function signOut() {
    'use server'
    const supabase = await createClient()
    await supabase.auth.signOut()
    redirect('/login')
  }

  return (
    <div className="flex flex-col min-h-dvh bg-brand-black pb-24">
      <div className="page-padding pt-10 pb-4">
        <h1 className="font-display text-5xl text-brand-offwhite">PROFILE</h1>
      </div>

      <div className="page-padding flex flex-col gap-4">
        {/* Archetype card */}
        {archetype ? (
          <div className="bg-brand-gray rounded-2xl p-5 text-center">
            <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-3">Your Animal</p>
            <h2
              className="font-display text-5xl leading-none mb-1"
              style={{ color: archetype.color_accent }}
            >
              THE {archetype.display_name.toUpperCase()}
            </h2>
            <p className="font-heading text-brand-offwhite text-sm mb-2">{archetype.headline}</p>
            {secondary && (
              <p className="text-brand-gray-muted text-xs">
                Secondary: The {secondary.display_name}
              </p>
            )}
            <div className="flex flex-wrap gap-2 justify-center mt-3">
              {archetype.traits.map(trait => (
                <span
                  key={trait}
                  className="text-xs px-2 py-0.5 rounded-full border"
                  style={{ borderColor: archetype.color_accent, color: archetype.color_accent }}
                >
                  {trait}
                </span>
              ))}
            </div>
          </div>
        ) : (
          <div className="bg-brand-gray rounded-2xl p-5">
            <p className="text-brand-gray-muted text-sm">No archetype assigned yet.</p>
          </div>
        )}

        {/* Stats */}
        <div className="bg-brand-gray rounded-2xl p-5">
          <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-4">Stats</p>
          <div className="grid grid-cols-3 gap-4 text-center">
            <div>
              <p className="font-display text-3xl text-brand-offwhite">{streak?.current_streak ?? 0}</p>
              <p className="text-brand-gray-muted text-xs">Day Streak</p>
            </div>
            <div>
              <p className="font-display text-3xl text-brand-offwhite">{workoutCountRes.count ?? 0}</p>
              <p className="text-brand-gray-muted text-xs">Workouts</p>
            </div>
            <div>
              <p className="font-display text-3xl text-brand-offwhite">{hundredProgress?.best_reps ?? 0}</p>
              <p className="text-brand-gray-muted text-xs">Best Reps</p>
            </div>
          </div>
        </div>

        {/* 100 Series progress */}
        <div className="bg-brand-gray rounded-2xl p-5">
          <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-3">100 Series</p>
          <div className="flex items-center gap-2">
            {LEVELS.map((level, i) => (
              <div key={level} className="flex-1 flex flex-col items-center gap-1">
                <div
                  className={`w-full h-2 rounded-full ${i <= levelIndex ? 'bg-brand-green' : 'bg-brand-gray-light'}`}
                />
                <span className="text-xs text-brand-gray-muted">{level}</span>
              </div>
            ))}
          </div>
        </div>

        {/* Training mode */}
        <div className="bg-brand-gray rounded-2xl p-5 flex items-center justify-between">
          <div>
            <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-1">Training Mode</p>
            <p className="font-heading font-bold text-brand-offwhite">
              {profile?.training_mode?.replace('_', ' ').toUpperCase() ?? 'General'}
            </p>
          </div>
          <a href="/mode-select" className="text-brand-green text-sm">Change</a>
        </div>

        {/* Retake assessment */}
        <a href="/assessment">
          <button className="w-full border border-brand-gray-light text-brand-gray-muted font-heading font-bold py-4 rounded-lg text-sm uppercase tracking-wide">
            Retake Assessment
          </button>
        </a>

        {/* Sign out */}
        <form action={signOut}>
          <button
            type="submit"
            className="w-full text-brand-gray-muted text-sm py-3 underline"
          >
            Sign Out
          </button>
        </form>
      </div>

      <BottomNav active="profile" />
    </div>
  )
}
