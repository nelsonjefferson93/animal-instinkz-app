import { redirect, notFound } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import { ARCHETYPES } from '@/lib/archetype/profiles'
import BottomNav from '@/components/layout/BottomNav'
import WorkoutSession from './WorkoutSession'

interface WorkoutExercise {
  id: string
  exercise_order: number
  block: string
  sets: number
  reps_min: number | null
  reps_max: number | null
  rpe_target: number | null
  rest_seconds: number
  coaching_note: string | null
  exercise: {
    id: string
    name: string
    category: string
    muscle_primary: string[]
    coaching_cues: string[]
  }
}

const BLOCK_ORDER = ['activation', 'primary', 'accessory', 'finisher', 'cooldown']
const BLOCK_LABELS: Record<string, string> = {
  activation: 'Activation',
  primary: 'Primary Work',
  accessory: 'Accessories',
  finisher: 'Finisher',
  cooldown: 'Cool Down',
}

export default async function WorkoutDetailPage({ params }: { params: { id: string } }) {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect('/login')

  const [templateRes, exercisesRes, archetypeRes, profileRes] = await Promise.all([
    supabase.from('workout_templates').select('*').eq('id', params.id).single(),
    supabase
      .from('workout_template_exercises')
      .select('*, exercise:exercises(id, name, category, muscle_primary, coaching_cues)')
      .eq('template_id', params.id)
      .order('exercise_order'),
    supabase.from('user_archetypes').select('primary_archetype').eq('user_id', user.id).eq('is_active', true).single(),
    supabase.from('users').select('training_mode').eq('id', user.id).single(),
  ])

  if (!templateRes.data) notFound()

  const template = templateRes.data
  const exercises = (exercisesRes.data ?? []) as WorkoutExercise[]
  const archetypeId = archetypeRes.data?.primary_archetype
  const archetype = archetypeId ? ARCHETYPES[archetypeId as keyof typeof ARCHETYPES] : null

  // Group exercises by block
  const grouped = BLOCK_ORDER.reduce<Record<string, WorkoutExercise[]>>((acc, block) => {
    const inBlock = exercises.filter(e => e.block === block)
    if (inBlock.length > 0) acc[block] = inBlock
    return acc
  }, {})

  const totalSets = exercises.reduce((sum, e) => sum + e.sets, 0)

  return (
    <div className="flex flex-col min-h-dvh bg-brand-black pb-28">
      {/* Header */}
      <div className="page-padding pt-10 pb-4">
        <a href="/train" className="text-brand-gray-muted text-xs uppercase tracking-widest mb-4 block">
          ← Back to Training
        </a>
        {archetype && (
          <p className="text-xs uppercase tracking-widest mb-1" style={{ color: archetype.color_accent }}>
            {archetype.display_name} Plan — Day {template.day_number}
          </p>
        )}
        <h1 className="font-display text-5xl text-brand-offwhite leading-none">
          {template.day_label.toUpperCase()}
        </h1>
        <div className="flex gap-4 mt-3">
          {template.estimated_duration_min && (
            <span className="text-brand-gray-muted text-sm">~{template.estimated_duration_min} min</span>
          )}
          <span className="text-brand-gray-muted text-sm">{exercises.length} exercises</span>
          <span className="text-brand-gray-muted text-sm">{totalSets} sets</span>
        </div>
        {template.notes && (
          <p className="text-brand-green text-sm mt-3 italic">"{template.notes}"</p>
        )}
      </div>

      {/* Exercise List */}
      <div className="page-padding flex flex-col gap-6 pb-4">
        {Object.entries(grouped).map(([block, blockExercises]) => (
          <div key={block}>
            <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-3">
              {BLOCK_LABELS[block] ?? block}
            </p>
            <div className="flex flex-col gap-3">
              {blockExercises.map((item) => (
                <div key={item.id} className="bg-brand-gray rounded-2xl p-4">
                  <div className="flex items-start justify-between mb-2">
                    <div className="flex-1 pr-3">
                      <p className="font-heading font-bold text-brand-offwhite text-base">
                        {item.exercise?.name ?? 'Exercise'}
                      </p>
                      <p className="text-brand-gray-muted text-xs capitalize mt-0.5">
                        {item.exercise?.muscle_primary?.join(', ')}
                      </p>
                    </div>
                    <div className="text-right flex-shrink-0">
                      <p className="font-heading font-bold text-brand-green text-base">
                        {item.sets}×{item.reps_min
                          ? item.reps_max && item.reps_max !== item.reps_min
                            ? `${item.reps_min}–${item.reps_max}`
                            : item.reps_min
                          : 'time'}
                      </p>
                      <p className="text-brand-gray-muted text-xs">
                        {item.rpe_target ? `RPE ${item.rpe_target}` : ''}{item.rpe_target && item.rest_seconds ? ' · ' : ''}{item.rest_seconds ? `${item.rest_seconds}s rest` : ''}
                      </p>
                    </div>
                  </div>
                  {item.coaching_note && (
                    <p className="text-brand-gray-muted text-xs border-t border-brand-gray-light pt-2 mt-1">
                      {item.coaching_note}
                    </p>
                  )}
                </div>
              ))}
            </div>
          </div>
        ))}
      </div>

      {/* Session Tracker — client component */}
      <WorkoutSession
        templateId={params.id}
        userId={user.id}
        archetypeId={archetypeId ?? null}
        trainingMode={profileRes.data?.training_mode ?? 'general'}
        exercises={exercises}
      />

      <BottomNav active="train" />
    </div>
  )
}
