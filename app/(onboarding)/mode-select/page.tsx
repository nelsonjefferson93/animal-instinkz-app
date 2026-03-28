'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'
import type { TrainingMode } from '@/types/database'

const MODES: { id: TrainingMode; label: string; description: string; icon: string }[] = [
  { id: 'fat_loss', label: 'Fat Loss', description: 'Burn fat. Stay lean. Move fast.', icon: '🔥' },
  { id: 'muscle_gain', label: 'Muscle Gain', description: 'Build size. Add strength. Dominate.', icon: '💪' },
  { id: 'performance', label: 'Performance', description: 'Speed. Power. Athletic output.', icon: '⚡' },
  { id: 'general', label: 'General Fitness', description: 'Stay consistent. Stay capable.', icon: '🎯' },
]

export default function ModeSelectPage() {
  const router = useRouter()
  const [selected, setSelected] = useState<TrainingMode | null>(null)
  const [loading, setLoading] = useState(false)

  async function handleContinue() {
    if (!selected) return
    setLoading(true)

    const supabase = createClient()
    const { data: { user } } = await supabase.auth.getUser()
    if (!user) { router.push('/login'); return }

    // Update training mode and mark onboarding complete
    await supabase.from('users').upsert({
      id: user.id,
      email: user.email!,
      training_mode: selected,
      onboarding_complete: true,
    })

    // Initialize 100 Series progress
    await supabase.from('user_hundred_series_progress').upsert({
      user_id: user.id,
      current_level: 20,
      best_reps: 0,
      total_attempts: 0,
    })

    // Initialize streak
    await supabase.from('streaks').upsert({
      user_id: user.id,
      current_streak: 0,
      longest_streak: 0,
    })

    router.push('/dashboard')
  }

  return (
    <div className="flex flex-col min-h-dvh page-padding pt-10 pb-8">
      <div className="mb-8">
        <h1 className="font-display text-5xl text-brand-offwhite leading-none mb-2">
          WHAT ARE YOU<br />TRAINING FOR?
        </h1>
        <p className="text-brand-gray-muted text-sm">
          Your workouts will be built around this goal.
        </p>
      </div>

      <div className="flex flex-col gap-3 flex-1">
        {MODES.map(mode => (
          <button
            key={mode.id}
            onClick={() => setSelected(mode.id)}
            className={`w-full rounded-lg px-5 py-4 text-left border transition-all ${
              selected === mode.id
                ? 'bg-brand-green border-brand-green'
                : 'bg-brand-gray border-brand-gray-light'
            }`}
          >
            <div className="flex items-center gap-3">
              <span className="text-2xl">{mode.icon}</span>
              <div>
                <p className="font-heading font-bold text-brand-offwhite text-base">
                  {mode.label}
                </p>
                <p className="text-brand-gray-muted text-xs mt-0.5">
                  {mode.description}
                </p>
              </div>
            </div>
          </button>
        ))}
      </div>

      <button
        onClick={handleContinue}
        disabled={!selected || loading}
        className="w-full bg-brand-green text-white font-heading font-bold py-5 rounded-lg text-base uppercase tracking-widest mt-6 disabled:opacity-40 active:bg-brand-green-light transition-colors"
      >
        {loading ? 'Setting Up...' : 'Enter the Arena'}
      </button>
    </div>
  )
}
