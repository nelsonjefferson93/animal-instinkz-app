import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import { ARCHETYPES } from '@/lib/archetype/profiles'
import BottomNav from '@/components/layout/BottomNav'

export default async function TrainPage() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect('/login')

  const [archetypeRes, profileRes] = await Promise.all([
    supabase.from('user_archetypes').select('primary_archetype').eq('user_id', user.id).eq('is_active', true).single(),
    supabase.from('users').select('training_mode').eq('id', user.id).single(),
  ])

  const archetypeId = archetypeRes.data?.primary_archetype
  const trainingMode = profileRes.data?.training_mode ?? 'general'
  const archetype = archetypeId ? ARCHETYPES[archetypeId as keyof typeof ARCHETYPES] : null

  // Fetch workout templates for current archetype + mode
  const { data: templates } = await supabase
    .from('workout_templates')
    .select('*')
    .eq('archetype_id', archetypeId ?? '')
    .eq('training_mode', trainingMode)
    .eq('week_number', 1)
    .order('day_number')

  return (
    <div className="flex flex-col min-h-dvh bg-brand-black pb-24">
      <div className="page-padding pt-10 pb-4">
        <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-1">
          {archetype ? `${archetype.display_name} Plan` : 'Your Plan'}
        </p>
        <h1 className="font-display text-5xl text-brand-offwhite">TRAINING</h1>
        <p className="text-brand-gray-muted text-sm mt-1">
          Week 1 — {trainingMode.replace('_', ' ').toUpperCase()}
        </p>
      </div>

      <div className="page-padding flex flex-col gap-3">
        {templates && templates.length > 0 ? (
          templates.map((template) => (
            <a key={template.id} href={`/train/${template.id}`}>
              <div className="bg-brand-gray rounded-2xl p-5 flex items-center justify-between active:bg-brand-gray-light transition-colors">
                <div>
                  <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-1">
                    Day {template.day_number}
                  </p>
                  <p className="font-heading font-bold text-brand-offwhite text-base">
                    {template.day_label}
                  </p>
                  {template.estimated_duration_min && (
                    <p className="text-brand-gray-muted text-xs mt-1">
                      ~{template.estimated_duration_min} min
                    </p>
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
