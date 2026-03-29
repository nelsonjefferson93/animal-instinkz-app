import { redirect, notFound } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import { ARCHETYPES } from '@/lib/archetype/profiles'
import BottomNav from '@/components/layout/BottomNav'
import WorkoutSession from './WorkoutSession'

export interface TrainingExercise {
  id: string
  sort_order: number
  exercise_name: string
  sets: string | null
  reps: string | null
  rest_seconds: number | null
  intensity: string | null
  notes: string | null
}

export default async function WorkoutDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect('/login')

  const [dayRes, exercisesRes, archetypeRes, profileRes] = await Promise.all([
    supabase.from('training_days').select('*').eq('id', id).single(),
    supabase.from('training_exercises').select('*').eq('training_day_id', id).order('sort_order'),
    supabase.from('user_archetypes').select('primary_archetype').eq('user_id', user.id).eq('is_active', true).single(),
    supabase.from('users').select('training_mode').eq('id', user.id).single(),
  ])

  if (!dayRes.data) notFound()

  const day = dayRes.data
  const exercises = (exercisesRes.data ?? []) as TrainingExercise[]
  const archetypeId = archetypeRes.data?.primary_archetype as string | undefined
  const archetype = archetypeId ? ARCHETYPES[archetypeId as keyof typeof ARCHETYPES] : null

  return (
    <div className="flex flex-col min-h-dvh bg-brand-black pb-28">
      {/* Header */}
      <div className="page-padding pt-10 pb-4">
        <a href="/train" className="text-brand-gray-muted text-xs uppercase tracking-widest mb-4 block">
          ← Back to Training
        </a>
        {archetype && (
          <p className="text-xs uppercase tracking-widest mb-1" style={{ color: archetype.color_accent }}>
            {archetype.display_name} Plan — {day.day_name}
          </p>
        )}
        <h1 className="font-display text-5xl text-brand-offwhite leading-none">
          {(day.focus as string).toUpperCase()}
        </h1>
        <div className="flex gap-4 mt-3">
          <span className="text-brand-gray-muted text-sm">{exercises.length} exercises</span>
        </div>
        {day.notes && (
          <p className="text-brand-green text-sm mt-3 italic">"{day.notes}"</p>
        )}
      </div>

      {/* Exercise List */}
      <div className="page-padding flex flex-col gap-3 pb-4">
        {exercises.map((ex) => (
          <div key={ex.id} className="bg-brand-gray rounded-2xl p-4">
            <div className="flex items-start justify-between mb-2">
              <div className="flex-1 pr-3">
                <p className="font-heading font-bold text-brand-offwhite text-base">
                  {ex.exercise_name}
                </p>
                {ex.intensity && (
                  <p className="text-brand-gray-muted text-xs capitalize mt-0.5">{ex.intensity}</p>
                )}
              </div>
              <div className="text-right flex-shrink-0">
                <p className="font-heading font-bold text-brand-green text-base">
                  {ex.sets && ex.reps
                    ? `${ex.sets}×${ex.reps}`
                    : ex.reps ?? ex.sets ?? '—'}
                </p>
                {ex.rest_seconds != null && ex.rest_seconds > 0 && (
                  <p className="text-brand-gray-muted text-xs">{ex.rest_seconds}s rest</p>
                )}
              </div>
            </div>
            {ex.notes && (
              <p className="text-brand-gray-muted text-xs border-t border-brand-gray-light pt-2 mt-1">
                {ex.notes}
              </p>
            )}
          </div>
        ))}
      </div>

      {/* Session Tracker */}
      <WorkoutSession
        dayId={id}
        userId={user.id}
        archetypeId={archetypeId ?? null}
        goal={profileRes.data?.training_mode ?? 'fat_loss'}
        exercises={exercises}
      />

      <BottomNav active="train" />
    </div>
  )
}
