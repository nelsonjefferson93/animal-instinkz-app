'use client'

import { useState } from 'react'
import { createClient } from '@/lib/supabase/client'
import { useRouter } from 'next/navigation'
import type { TrainingExercise } from './page'

interface SetLog {
  exerciseId: string
  setNumber: number
  repsCompleted: string
  weightLbs: string
  done: boolean
}

interface Props {
  dayId: string
  userId: string
  archetypeId: string | null
  goal: string
  exercises: TrainingExercise[]
}

export default function WorkoutSession({ userId, archetypeId, goal, exercises }: Props) {
  const router = useRouter()
  const supabase = createClient()

  const [phase, setPhase] = useState<'idle' | 'active' | 'saving' | 'done'>('idle')
  const [startTime, setStartTime] = useState<Date | null>(null)
  const [workoutLogId, setWorkoutLogId] = useState<string | null>(null)
  const [difficulty, setDifficulty] = useState<number>(3)
  const [sets, setSets] = useState<SetLog[]>(() =>
    exercises.flatMap(ex => {
      const setCount = parseInt(ex.sets ?? '3', 10) || 3
      return Array.from({ length: setCount }, (_, i) => ({
        exerciseId: ex.id,
        setNumber: i + 1,
        repsCompleted: '',
        weightLbs: '',
        done: false,
      }))
    })
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
        archetype_id: archetypeId,
        training_mode: goal,
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
      await supabase
        .from('workout_logs')
        .update({ duration_actual_min: durationMin, perceived_difficulty: difficulty })
        .eq('id', workoutLogId)

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

    if (existing.last_activity_date === today) return

    const yesterday = new Date()
    yesterday.setDate(yesterday.getDate() - 1)
    const yesterdayStr = yesterday.toISOString().split('T')[0]
    const newStreak = existing.last_activity_date === yesterdayStr
      ? existing.current_streak + 1
      : 1

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
          type="button"
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
          type="button"
          onClick={() => router.push('/dashboard')}
          className="w-full bg-brand-green text-white font-heading font-bold py-4 rounded-2xl text-base uppercase tracking-wide mb-3"
        >
          Back to Dashboard
        </button>
        <button
          type="button"
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
        <p className="font-heading font-bold text-brand-green text-sm">
          {Math.round(progress * 100)}%
        </p>
      </div>

      {/* Set list — scrollable */}
      <div className="flex-1 overflow-y-auto page-padding pb-2">
        {exercises.map((ex) => {
          const exSets = sets.filter(s => s.exerciseId === ex.id)
          const allDone = exSets.every(s => s.done)

          return (
            <div
              key={ex.id}
              className={`mb-4 rounded-2xl p-4 bg-brand-gray transition-opacity ${allDone ? 'opacity-60' : ''}`}
            >
              <div className="flex items-center justify-between mb-3">
                <p className={`font-heading font-bold text-base ${allDone ? 'text-brand-gray-muted line-through' : 'text-brand-offwhite'}`}>
                  {ex.exercise_name}
                </p>
                {allDone && <span className="text-brand-green text-lg">✓</span>}
              </div>

              {exSets.map((s) => (
                <div key={`${s.exerciseId}-${s.setNumber}`} className="flex items-center gap-2 mb-2">
                  <button
                    type="button"
                    onClick={() => toggleSetDone(s.exerciseId, s.setNumber)}
                    className={`w-8 h-8 rounded-full border-2 flex-shrink-0 flex items-center justify-center transition-colors ${
                      s.done ? 'bg-brand-green border-brand-green' : 'border-brand-gray-light'
                    }`}
                  >
                    {s.done && <span className="text-white text-xs">✓</span>}
                  </button>

                  <span className="text-brand-gray-muted text-xs w-8 flex-shrink-0">S{s.setNumber}</span>

                  <input
                    type="number"
                    placeholder={ex.reps ?? 'reps'}
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
                type="button"
                onClick={() => setDifficulty(d)}
                className={`flex-1 py-2 rounded-lg font-heading font-bold text-sm transition-colors ${
                  difficulty === d ? 'bg-brand-green text-white' : 'bg-brand-gray-light text-brand-gray-muted'
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
          type="button"
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
