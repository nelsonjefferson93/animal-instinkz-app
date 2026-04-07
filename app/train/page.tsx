import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import { ARCHETYPES } from '@/lib/archetype/profiles'
import { getEnvironmentLabel } from '@/lib/training/engine'
import BottomNav from '@/components/layout/BottomNav'

export default async function TrainPage() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect('/login')

  const [archetypeRes, profileRes] = await Promise.all([
    supabase.from('user_archetypes').select('primary_archetype').eq('user_id', user.id).eq('is_active', true).single(),
    supabase.from('users').select('training_mode, workout_environment, equipment_level, profile_complete, session_length_minutes').eq('id', user.id).single(),
  ])

  const archetypeId = archetypeRes.data?.primary_archetype?.toLowerCase() ?? 'lion'
  const goal = profileRes.data?.training_mode ?? 'fat_loss'
  const weekNumber = 1
  const archetype = ARCHETYPES[archetypeId as keyof typeof ARCHETYPES] ?? null
  const profile = profileRes.data
  const profileComplete = profile?.profile_complete ?? false

  // Home users get their archetype's home plan; gym users get their archetype's gym plan
  const environment = (profile?.profile_complete && profile?.workout_environment === 'home')
    ? 'home'
    : 'gym'

  const { data: plan } = await supabase
    .from('training_plans')
    .select('id')
    .eq('archetype', archetypeId)
    .eq('goal', goal)
    .eq('week_number', weekNumber)
    .eq('environment', environment)
    .single()

  const { data: days } = plan
    ? await supabase
        .from('training_days')
        .select('*')
        .eq('training_plan_id', plan.id)
        .order('day_number')
    : { data: null }

  const envLabel = profileComplete && profile ? getEnvironmentLabel(profile) : null

  return (
    <div className="flex flex-col min-h-dvh bg-brand-black pb-24">
      <div className="page-padding pt-10 pb-4">
        <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-1">
          {archetype ? `${archetype.display_name} Plan` : 'Your Plan'}
        </p>
        <h1 className="font-display text-5xl text-brand-offwhite">TRAINING</h1>
        <p className="text-brand-gray-muted text-sm mt-1">
          Week {weekNumber} — {goal.replace('_', ' ').toUpperCase()}
        </p>
        {envLabel && (
          <p className="text-brand-green text-xs font-heading font-bold mt-1">
            {envLabel.mode} · {envLabel.subtitle}
          </p>
        )}
      </div>

      <div className="page-padding flex flex-col gap-3">
        {days && days.length > 0 ? (
          days.map((day: { id: string; day_number: number; day_name: string; focus: string; notes: string | null }) => (
            <a key={day.id} href={`/train/${day.id}`}>
              <div className="bg-brand-gray rounded-2xl p-5 flex items-center justify-between active:bg-brand-gray-light transition-colors">
                <div>
                  <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-1">
                    {day.day_name}
                  </p>
                  <p className="font-heading font-bold text-brand-offwhite text-base">
                    {day.focus}
                  </p>
                  {day.notes && (
                    <p className="text-brand-gray-muted text-xs mt-1">{day.notes}</p>
                  )}
                </div>
                <span className="text-brand-green text-xl">→</span>
              </div>
            </a>
          ))
        ) : (
          <div className="bg-brand-gray rounded-2xl p-6 text-center">
            <p className="font-heading font-bold text-brand-offwhite text-base mb-2">
              Workouts Loading Soon
            </p>
            <p className="text-brand-gray-muted text-sm">
              Workout templates for your archetype will appear here once seeded in Supabase.
            </p>
          </div>
        )}
      </div>

      <BottomNav active="train" />
    </div>
  )
}
