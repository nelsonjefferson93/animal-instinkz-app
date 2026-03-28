'use client'

import { useEffect, useState, useRef } from 'react'
import { createClient } from '@/lib/supabase/client'
import { ARCHETYPES } from '@/lib/archetype/profiles'
import BottomNav from '@/components/layout/BottomNav'
import type { ArchetypeId } from '@/types/database'

const LEVELS = [20, 40, 60, 80, 100] as const
type Level = typeof LEVELS[number]

type Phase = 'overview' | 'active' | 'complete'

export default function HundredPage() {
  const [phase, setPhase] = useState<Phase>('overview')
  const [archetypeId, setArchetypeId] = useState<ArchetypeId | null>(null)
  const [currentLevel, setCurrentLevel] = useState<Level>(20)
  const [bestReps, setBestReps] = useState(0)
  const [totalAttempts, setTotalAttempts] = useState(0)
  const [reps, setReps] = useState(0)
  const [restCount, setRestCount] = useState(0)
  const [startTime, setStartTime] = useState<number>(0)
  const [lastTapTime, setLastTapTime] = useState<number>(0)
  const [saving, setSaving] = useState(false)
  const restTimer = useRef<ReturnType<typeof setTimeout> | null>(null)

  useEffect(() => {
    async function load() {
      const supabase = createClient()
      const { data: { user } } = await supabase.auth.getUser()
      if (!user) return

      const [archetypeRes, progressRes] = await Promise.all([
        supabase.from('user_archetypes').select('primary_archetype').eq('user_id', user.id).eq('is_active', true).single(),
        supabase.from('user_hundred_series_progress').select('*').eq('user_id', user.id).single(),
      ])

      if (archetypeRes.data) setArchetypeId(archetypeRes.data.primary_archetype as ArchetypeId)
      if (progressRes.data) {
        setCurrentLevel(progressRes.data.current_level as Level)
        setBestReps(progressRes.data.best_reps)
        setTotalAttempts(progressRes.data.total_attempts)
      }
    }
    load()
  }, [])

  const archetype = archetypeId ? ARCHETYPES[archetypeId] : null
  const levelIndex = LEVELS.indexOf(currentLevel)

  function startAttempt() {
    setReps(0)
    setRestCount(0)
    setStartTime(Date.now())
    setLastTapTime(Date.now())
    setPhase('active')
  }

  function addRep() {
    const now = Date.now()
    if (lastTapTime && now - lastTapTime > 10000) {
      setRestCount(prev => prev + 1)
    }
    setLastTapTime(now)
    setReps(prev => prev + 1)
  }

  async function finishAttempt() {
    setSaving(true)
    const supabase = createClient()
    const { data: { user } } = await supabase.auth.getUser()
    if (!user) return

    const duration = Math.round((Date.now() - startTime) / 1000)
    const levelCompleted = reps >= currentLevel

    await supabase.from('hundred_series_logs').insert({
      user_id: user.id,
      exercise_id: null,
      archetype_id: archetypeId,
      level_attempted: currentLevel,
      reps_completed: reps,
      duration_seconds: duration,
      rest_count: restCount,
    })

    const nextLevel = levelCompleted && levelIndex < LEVELS.length - 1
      ? LEVELS[levelIndex + 1]
      : currentLevel

    await supabase.from('user_hundred_series_progress').upsert({
      user_id: user.id,
      current_level: nextLevel,
      best_reps: Math.max(reps, bestReps),
      total_attempts: totalAttempts + 1,
      last_attempted_at: new Date().toISOString(),
    })

    setCurrentLevel(nextLevel)
    setBestReps(Math.max(reps, bestReps))
    setTotalAttempts(prev => prev + 1)
    setSaving(false)
    setPhase('complete')
  }

  // Active attempt screen
  if (phase === 'active') {
    const progress = Math.min((reps / currentLevel) * 100, 100)
    const cue = archetype?.hundred_series_cues[reps % archetype.hundred_series_cues.length] ?? ''

    return (
      <div className="flex flex-col min-h-dvh page-padding pt-10 pb-8 items-center">
        <div className="w-full flex items-center justify-between mb-8">
          <p className="font-heading font-bold text-brand-offwhite text-lg">
            LEVEL {levelIndex + 1} — {currentLevel} REPS
          </p>
          <p className="text-brand-gray-muted text-sm">Push-ups</p>
        </div>

        {/* Rep counter */}
        <div className="flex-1 flex flex-col items-center justify-center gap-6">
          <p className="font-display text-[120px] leading-none text-brand-offwhite">{reps}</p>

          <div className="w-full bg-brand-gray rounded-full h-3">
            <div
              className="bg-brand-green h-3 rounded-full transition-all duration-150"
              style={{ width: `${progress}%` }}
            />
          </div>
          <p className="text-brand-gray-muted text-xs">{reps} / {currentLevel}</p>

          {cue && (
            <p className="text-brand-green text-sm italic text-center px-4">&ldquo;{cue}&rdquo;</p>
          )}
        </div>

        <button
          onClick={addRep}
          className="w-full bg-brand-green text-white font-display text-5xl py-8 rounded-2xl active:bg-brand-green-light transition-colors mb-4 select-none"
        >
          + REP
        </button>

        <button
          onClick={finishAttempt}
          disabled={saving}
          className="text-brand-gray-muted text-sm underline"
        >
          {saving ? 'Saving...' : 'Done for today'}
        </button>
      </div>
    )
  }

  // Completion screen
  if (phase === 'complete') {
    const levelCompleted = reps >= currentLevel
    return (
      <div className="flex flex-col min-h-dvh page-padding items-center justify-center text-center gap-6">
        <p className="text-brand-gray-muted text-xs uppercase tracking-widest">
          {levelCompleted ? 'Level Complete' : 'Attempt Saved'}
        </p>
        <h1 className="font-display text-6xl text-brand-offwhite">
          {reps} REPS
        </h1>
        {levelCompleted ? (
          <>
            <p className="font-heading text-brand-green text-xl">
              LEVEL {levelIndex + 1} UNLOCKED
            </p>
            <p className="text-brand-offwhite text-sm">
              {archetype ? `THE ${archetype.display_name.toUpperCase()} EARNS EVERY LEVEL.` : 'Keep going.'}
            </p>
          </>
        ) : (
          <p className="text-brand-gray-muted text-sm">
            {currentLevel - reps} reps short. Come back stronger.
          </p>
        )}
        <button
          onClick={() => setPhase('overview')}
          className="w-full bg-brand-green text-white font-heading font-bold py-4 rounded-lg text-sm uppercase tracking-wide mt-4"
        >
          Back to 100 Series
        </button>
      </div>
    )
  }

  // Overview screen
  return (
    <div className="flex flex-col min-h-dvh bg-brand-black pb-24">
      <div className="page-padding pt-10 pb-4">
        <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-1">
          {archetype ? `THE ${archetype.display_name.toUpperCase()}` : ''}
        </p>
        <h1 className="font-display text-5xl text-brand-offwhite">100 SERIES</h1>
      </div>

      <div className="page-padding flex flex-col gap-4">
        {/* Level progress */}
        <div className="bg-brand-gray rounded-2xl p-5">
          <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-4">Your Progress</p>
          <div className="flex items-center gap-3 mb-4">
            {LEVELS.map((level, i) => (
              <div key={level} className="flex-1 flex flex-col items-center gap-1.5">
                <div
                  className={`w-8 h-8 rounded-full border-2 flex items-center justify-center text-xs font-bold ${
                    i < levelIndex
                      ? 'bg-brand-green border-brand-green text-white'
                      : i === levelIndex
                      ? 'border-brand-green text-brand-green'
                      : 'border-brand-gray-light text-brand-gray-muted'
                  }`}
                >
                  {i < levelIndex ? '✓' : level}
                </div>
              </div>
            ))}
          </div>
          <div className="flex gap-4 text-center">
            <div className="flex-1">
              <p className="font-display text-2xl text-brand-offwhite">{bestReps}</p>
              <p className="text-brand-gray-muted text-xs">Best Reps</p>
            </div>
            <div className="flex-1">
              <p className="font-display text-2xl text-brand-offwhite">{totalAttempts}</p>
              <p className="text-brand-gray-muted text-xs">Attempts</p>
            </div>
            <div className="flex-1">
              <p className="font-display text-2xl text-brand-offwhite">{currentLevel}</p>
              <p className="text-brand-gray-muted text-xs">Target</p>
            </div>
          </div>
        </div>

        {/* Doctrine quote */}
        {archetype && (
          <div className="bg-brand-gray rounded-2xl p-5">
            <p className="text-brand-green text-sm italic">
              &ldquo;{archetype.hundred_series_cues[0]}&rdquo;
            </p>
          </div>
        )}

        <button
          onClick={startAttempt}
          className="w-full bg-brand-green text-white font-heading font-bold py-5 rounded-lg text-base uppercase tracking-widest active:bg-brand-green-light transition-colors"
        >
          Attempt Now
        </button>
      </div>

      <BottomNav active="hundred" />
    </div>
  )
}
