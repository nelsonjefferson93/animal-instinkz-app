'use client'

import { useState } from 'react'
import { createClient } from '@/lib/supabase/client'
import { useRouter } from 'next/navigation'

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

interface SetLog {
  exerciseId: string
  setNumber: number
  repsCompleted: string
  weightLbs: string
  done: boolean
}

interface Props {
  templateId: string
  userId: string
  archetypeId: string | null
  trainingMode: string
  exercises: WorkoutExercise[]
}

export default function WorkoutSession({ templateId, userId, archetypeId, trainingMode, exercises }: Props) {
  const router = useRouter()
  const supabase = createClient()

  const [phase, setPhase] = useState<'idle' | 'active' | 'saving' | 'done'>('idle')
  const [startTime, setStartTime] = useState<Date | null>(null)
  const [workoutLogId, setWorkoutLogId] = useState<string | null>(null)
  const [difficulty, setDifficulty] = useState<number>(3)
  const [sets, setSets] = useState<SetLog[]>(() =>
    exercises.flatMap(ex =>
      Array.from({ length: ex.sets }, (_, i) => ({
        exerciseId: ex.exercise?.id ?? '',
        setNumber: i + 1,
        repsCompleted: ex.reps_max ? String(ex.reps_max) : '',
        weightLbs: '',
        done: false,
      }))
    )
  )

  const completedSets = sets.filter(s => s.done).length
  const totalSets = sets.length
  const progress = totalSets > 0 ? completedSets / totalSets : 0

  async function handleStart() {
    setPhase('active')
    setStartTime(new Date())

    const { data } = await supabase
      .from('workout_logs')
      .insert({
        user_id: userId,
        template_id: templateId,
        archetype_id: archetypeId,
        training_mode: trainingMode,
      })
      .select('id')
      .single()

    if (data) setWorkoutLogId(data.id)
  }

  function updateSet(exerciseId: string, setNumber: number, field: 'repsCompleted' | 'weightLbs', value: string) {
    setSets(prev =>
      prev.map(s =>
        s.exerciseId === exerciseId && s.setNumber === setNumber
          ? { ...s, [field]: value }
          : s
      )
    )
  }

  function toggleSetDone(exerciseId: string, setNumber: number) {
    setSets(prev =>
      prev.map(s =>
        s.exerciseId === exerciseId && s.setNumber === setNumber
          ? { ...s, done: !s.done }
          : s
      )
    )
  }

  async function handleFinish() {
    setPhase('saving')
    const durationMin = startTime
      ? Math.round((Date.now() - startTime.getTime()) / 60000)
      : null

    if (workoutLogId) {
      // Update the workout log with duration + difficulty
      await supabase
        .from('workout_logs')
        .update({ duration_actual_min: durationMin, perceived_difficulty: difficulty })
        .eq('id', workoutLogId)

      // Insert completed sets
      const doneSets = sets.filter(s => s.done)
      if (doneSets.length > 0) {
        await supabase.from('workout_log_sets').insert(
          doneSets.map(s => ({
            workout_log_id: workoutLogId,
            exercise_id: s.exerciseId,
            set_number: s.setNumber,
            reps_completed: s.repsCompleted ? parseInt(s.repsCompleted) : null,
            weight_lbs: s.weightLbs ? parseFloat(s.weightLbs) : null,
          }))
        )
      }

      // Update streak
      await updateStreak()
    }

    setPhase('done')
  }

  async function updateStreak() {
    const today = new Date().toISOString().split('T')[0]
    const { data: existing } = await supabase
      .from('streaks')
      .select('*')
      .eq('user_id', userId)
      .single()

    if (!existing) {
      await supabase.from('streaks').insert({
        user_id: userId,
        current_streak: 1,
        longest_streak: 1,
        last_activity_date: today,
      })
      return
    }

    const last = existing.last_activity_date
    const yesterday = new Date()
    yesterday.setDate(yesterday.getDate() - 1)
    const yesterdayStr = yesterday.toISOString().split('T')[0]

    let newStreak = existing.current_streak
    if (last === today) {
      // Already logged today — no change
      return
    } else if (last === yesterdayStr) {
      newStreak = existing.current_streak + 1
    } else {
      newStreak = 1
    }

    await supabase.from('streaks').update({
      current_streak: newStreak,
      longest_streak: Math.max(newStreak, existing.longest_streak),
      last_activity_date: today,
      updated_at: new Date().toISOString(),
    }).eq('user_id', userId)
  }

  // ── IDLE STATE ──
  if (phase === 'idle') {
    return (
      <div className="fixed bottom-20 left-0 right-0 px-4 pb-2">
        <button
          onClick={handleStart}
          className="w-full bg-brand-green text-white font-heading font-bold py-4 rounded-2xl text-base uppercase tracking-wide active:bg-brand-green-light transition-colors shadow-lg"
        >
          Start Session
        </button>
      </div>
    )
  }

  // ── DONE STATE ──
  if (phase === 'done') {
    return (
      <div className="fixed inset-0 bg-brand-black flex flex-col items-center justify-center px-6 z-50">
        <p className="font-display text-6xl text-brand-green mb-4">DONE</p>
        <p className="font-heading font-bold text-brand-offwhite text-xl mb-2">
          {completedSets} of {totalSets} sets completed
        </p>
        <p className="text-brand-gray-muted text-sm mb-8">
          {startTime ? `${Math.round((Date.now() - startTime.getTime()) / 60000)} min session` : ''}
        </p>
        <button
          onClick={() => router.push('/dashboard')}
          className="w-full bg-brand-green text-white font-heading font-bold py-4 rounded-2xl text-base uppercase tracking-wide mb-3"
        >
          Back to Dashboard
        </button>
        <button
          onClick={() => router.push('/train')}
          className="w-full border border-brand-gray-light text-brand-gray-muted font-heading font-bold py-4 rounded-2xl text-base uppercase tracking-wide"
        >
          View Training
        </button>
      </div>
    )
  }

  // ── ACTIVE SESSION ──
  return (
    <div className="fixed inset-0 bg-brand-black z-40 flex flex-col overflow-hidden">
      {/* Progress bar */}
      <div className="h-1 bg-brand-gray">
        <div
          className="h-1 bg-brand-green transition-all duration-300"
          style={{ width: `${progress * 100}%` }}
        />
      </div>

      {/* Header */}
      <div className="page-padding pt-6 pb-3 flex items-center justify-between flex-shrink-0">
        <div>
          <p className="font-display text-3xl text-brand-offwhite">SESSION LIVE</p>
          <p className="text-brand-gray-muted text-xs mt-1">{completedSets} / {totalSets} sets done</p>
        </div>
        <div className="text-right">
          <p className="font-heading font-bold text-brand-green text-sm">
            {Math.round(progress * 100)}%
          </p>
        </div>
      </div>

      {/* Set list — scrollable */}
      <div className="flex-1 overflow-y-auto page-padding pb-2">
        {exercises.map((ex) => {
          const exSets = sets.filter(s => s.exerciseId === ex.exercise?.id)
          const allDone = exSets.every(s => s.done)

          return (
            <div key={ex.id} className={`mb-4 rounded-2xl p-4 transition-colors ${allDone ? 'bg-brand-gray opacity-60' : 'bg-brand-gray'}`}>
              <div className="flex items-center justify-between mb-3">
                <p className={`font-heading font-bold text-base ${allDone ? 'text-brand-gray-muted line-through' : 'text-brand-offwhite'}`}>
                  {ex.exercise?.name ?? 'Exercise'}
                </p>
                {allDone && <span className="text-brand-green text-lg">✓</span>}
              </div>

              {exSets.map((s) => (
                <div key={`${s.exerciseId}-${s.setNumber}`} className="flex items-center gap-2 mb-2">
                  <button
                    onClick={() => toggleSetDone(s.exerciseId, s.setNumber)}
                    className={`w-8 h-8 rounded-full border-2 flex-shrink-0 flex items-center justify-center transition-colors ${
                      s.done
                        ? 'bg-brand-green border-brand-green'
                        : 'border-brand-gray-light'
                    }`}
                  >
                    {s.done && <span className="text-white text-xs">✓</span>}
                  </button>

                  <span className="text-brand-gray-muted text-xs w-8 flex-shrink-0">S{s.setNumber}</span>

                  <input
                    type="number"
                    placeholder={ex.reps_max ? String(ex.reps_max) : 'reps'}
                    value={s.repsCompleted}
                    onChange={e => updateSet(s.exerciseId, s.setNumber, 'repsCompleted', e.target.value)}
                    className="flex-1 bg-brand-black border border-brand-gray-light rounded-lg px-2 py-1.5 text-brand-offwhite text-sm text-center"
                    inputMode="numeric"
                  />

                  <input
                    type="number"
                    placeholder="lbs"
                    value={s.weightLbs}
                    onChange={e => updateSet(s.exerciseId, s.setNumber, 'weightLbs', e.target.value)}
                    className="flex-1 bg-brand-black border border-brand-gray-light rounded-lg px-2 py-1.5 text-brand-offwhite text-sm text-center"
                    inputMode="decimal"
                  />
                </div>
              ))}
            </div>
          )
        })}

        {/* Difficulty Rating */}
        <div className="bg-brand-gray rounded-2xl p-4 mb-4">
          <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-3">Session Difficulty</p>
          <div className="flex gap-2">
            {[1, 2, 3, 4, 5].map(d => (
              <button
                key={d}
                onClick={() => setDifficulty(d)}
                className={`flex-1 py-2 rounded-lg font-heading font-bold text-sm transition-colors ${
                  difficulty === d
                    ? 'bg-brand-green text-white'
                    : 'bg-brand-gray-light text-brand-gray-muted'
                }`}
              >
                {d}
              </button>
            ))}
          </div>
          <div className="flex justify-between mt-1">
            <span className="text-brand-gray-muted text-xs">Easy</span>
            <span className="text-brand-gray-muted text-xs">Max Effort</span>
          </div>
        </div>
      </div>

      {/* Finish button */}
      <div className="page-padding pt-3 pb-6 flex-shrink-0">
        <button
          onClick={handleFinish}
          disabled={phase === 'saving'}
          className="w-full bg-brand-green text-white font-heading font-bold py-4 rounded-2xl text-base uppercase tracking-wide active:bg-brand-green-light transition-colors disabled:opacity-50"
        >
          {phase === 'saving' ? 'Saving...' : `Finish Session (${completedSets}/${totalSets} sets)`}
        </button>
      </div>
    </div>
  )
}
