'use client'

import { useState, useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'
import BottomNav from '@/components/layout/BottomNav'
import type { AdaptationEvent } from '@/types/database'

interface CheckinForm {
  weight_lbs: string
  energy_level: number
  sleep_quality: number
  stress_level: number
  soreness_level: number
  hunger_level: number
  notes: string
}

const INITIAL_FORM: CheckinForm = {
  weight_lbs: '',
  energy_level: 3,
  sleep_quality: 3,
  stress_level: 3,
  soreness_level: 3,
  hunger_level: 3,
  notes: '',
}

function ScaleInput({
  label,
  sublabel,
  value,
  onChange,
  lowLabel,
  highLabel,
}: {
  label: string
  sublabel?: string
  value: number
  onChange: (v: number) => void
  lowLabel?: string
  highLabel?: string
}) {
  return (
    <div>
      <div className="flex items-baseline justify-between mb-2">
        <div>
          <p className="text-brand-gray-muted text-xs uppercase tracking-widest">{label}</p>
          {sublabel && <p className="text-brand-gray-muted text-xs mt-0.5">{sublabel}</p>}
        </div>
        <span className="text-brand-green font-heading font-bold text-lg">{value}/5</span>
      </div>
      <div className="flex gap-2">
        {[1, 2, 3, 4, 5].map(n => (
          <button
            key={n}
            type="button"
            onClick={() => onChange(n)}
            className={`flex-1 py-3 rounded-lg border font-heading font-bold text-sm transition-all ${
              value === n
                ? 'bg-brand-green border-brand-green text-white'
                : 'bg-brand-gray border-brand-gray-light text-brand-gray-muted'
            }`}
          >
            {n}
          </button>
        ))}
      </div>
      {(lowLabel || highLabel) && (
        <div className="flex justify-between mt-1">
          <span className="text-brand-gray-muted text-xs">{lowLabel}</span>
          <span className="text-brand-gray-muted text-xs">{highLabel}</span>
        </div>
      )}
    </div>
  )
}

export default function CheckinPage() {
  const router = useRouter()
  const [form, setForm] = useState<CheckinForm>(INITIAL_FORM)
  const [loading, setLoading] = useState(false)
  const [submitted, setSubmitted] = useState(false)
  const [adaptationEvent, setAdaptationEvent] = useState<AdaptationEvent | null>(null)
  const [alreadyCheckedIn, setAlreadyCheckedIn] = useState(false)

  const today = new Date().toISOString().split('T')[0]

  useEffect(() => {
    async function checkExisting() {
      const supabase = createClient()
      const { data: { user } } = await supabase.auth.getUser()
      if (!user) return
      const { data } = await supabase
        .from('user_checkins')
        .select('id')
        .eq('user_id', user.id)
        .eq('checkin_date', today)
        .single()
      if (data) setAlreadyCheckedIn(true)
    }
    checkExisting()
  }, [today])

  function set<K extends keyof CheckinForm>(key: K, value: CheckinForm[K]) {
    setForm(prev => ({ ...prev, [key]: value }))
  }

  async function handleSubmit() {
    setLoading(true)
    const supabase = createClient()
    const { data: { user } } = await supabase.auth.getUser()
    if (!user) { router.push('/login'); return }

    const checkinData = {
      user_id: user.id,
      checkin_date: today,
      weight_lbs: form.weight_lbs ? parseFloat(form.weight_lbs) : null,
      energy_level: form.energy_level,
      sleep_quality: form.sleep_quality,
      stress_level: form.stress_level,
      soreness_level: form.soreness_level,
      hunger_level: form.hunger_level,
      notes: form.notes || null,
    }

    await supabase
      .from('user_checkins')
      .upsert(checkinData, { onConflict: 'user_id,checkin_date' })

    // Run adaptation engine via API route
    try {
      const res = await fetch('/api/adaptation/run', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ userId: user.id }),
      })
      if (res.ok) {
        const { event } = await res.json()
        if (event) setAdaptationEvent(event)
      }
    } catch {
      // Non-critical — adaptation will run on next check-in
    }

    setSubmitted(true)
    setLoading(false)
  }

  if (alreadyCheckedIn && !submitted) {
    return (
      <div className="flex flex-col min-h-dvh bg-brand-black pb-24">
        <div className="page-padding pt-10 flex-1 flex flex-col items-center justify-center text-center">
          <p className="text-4xl mb-4">✓</p>
          <h1 className="font-display text-4xl text-brand-offwhite mb-2">ALREADY CHECKED IN</h1>
          <p className="text-brand-gray-muted text-sm">You&apos;ve already submitted your check-in for today. Come back tomorrow.</p>
          <button
            onClick={() => router.push('/dashboard')}
            className="mt-8 w-full bg-brand-green text-white font-heading font-bold py-4 rounded-lg text-sm uppercase tracking-widest"
          >
            Back to Dashboard
          </button>
        </div>
        <BottomNav active="profile" />
      </div>
    )
  }

  if (submitted) {
    return (
      <div className="flex flex-col min-h-dvh bg-brand-black pb-24">
        <div className="page-padding pt-10 flex-1">
          <div className="mb-8 text-center">
            <p className="text-4xl mb-3">✓</p>
            <h1 className="font-display text-4xl text-brand-offwhite mb-2">CHECK-IN SAVED</h1>
            <p className="text-brand-gray-muted text-sm">Your signals have been logged. Your plan will adapt accordingly.</p>
          </div>

          {adaptationEvent && (
            <div className="bg-brand-gray rounded-2xl p-5 mb-4 border-l-4 border-brand-green">
              <p className="text-brand-green text-xs uppercase tracking-widest font-heading font-bold mb-2">
                Plan Update
              </p>
              <p className="text-brand-offwhite text-sm leading-relaxed mb-3">
                {adaptationEvent.reason}
              </p>
              {adaptationEvent.reinforcement && (
                <p className="text-brand-gray-muted text-xs italic">
                  {adaptationEvent.reinforcement}
                </p>
              )}
              {adaptationEvent.status === 'pending_approval' && (
                <div className="flex gap-2 mt-4">
                  <ApproveButton eventId={adaptationEvent.id} />
                  <DismissButton eventId={adaptationEvent.id} onDismiss={() => setAdaptationEvent(null)} />
                </div>
              )}
            </div>
          )}

          <button
            onClick={() => router.push('/dashboard')}
            className="w-full bg-brand-green text-white font-heading font-bold py-5 rounded-lg text-base uppercase tracking-widest"
          >
            Back to Dashboard
          </button>
        </div>
        <BottomNav active="profile" />
      </div>
    )
  }

  return (
    <div className="flex flex-col min-h-dvh bg-brand-black pb-24">
      <div className="page-padding pt-10 pb-4">
        <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-1">Weekly</p>
        <h1 className="font-display text-5xl text-brand-offwhite">CHECK-IN</h1>
        <p className="text-brand-gray-muted text-sm mt-1">
          Honest inputs. Better outputs. Your plan adjusts to your reality.
        </p>
      </div>

      <div className="page-padding flex flex-col gap-6">
        {/* Weight */}
        <div>
          <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-2">Current Weight (Optional)</p>
          <div className="flex items-center gap-3">
            <input
              type="number"
              inputMode="decimal"
              placeholder="185"
              value={form.weight_lbs}
              onChange={e => set('weight_lbs', e.target.value)}
              className="flex-1 bg-brand-gray border border-brand-gray-light rounded-lg px-4 py-3 text-brand-offwhite placeholder-brand-gray-muted text-sm"
            />
            <span className="text-brand-gray-muted text-sm">lbs</span>
          </div>
        </div>

        <ScaleInput
          label="Energy Level"
          sublabel="How did you feel physically today?"
          value={form.energy_level}
          onChange={v => set('energy_level', v)}
          lowLabel="Drained"
          highLabel="Fully charged"
        />

        <ScaleInput
          label="Sleep Quality"
          sublabel="How was your sleep last night?"
          value={form.sleep_quality}
          onChange={v => set('sleep_quality', v)}
          lowLabel="Terrible"
          highLabel="Excellent"
        />

        <ScaleInput
          label="Stress Level"
          sublabel="Overall stress (work, life, everything)"
          value={form.stress_level}
          onChange={v => set('stress_level', v)}
          lowLabel="Calm"
          highLabel="Overwhelmed"
        />

        <ScaleInput
          label="Soreness / Recovery"
          sublabel="How recovered do you feel?"
          value={form.soreness_level}
          onChange={v => set('soreness_level', v)}
          lowLabel="Fully recovered"
          highLabel="Very sore"
        />

        <ScaleInput
          label="Hunger Level"
          sublabel="Are cravings or hunger affecting you?"
          value={form.hunger_level}
          onChange={v => set('hunger_level', v)}
          lowLabel="Satisfied"
          highLabel="Constantly hungry"
        />

        {/* Notes */}
        <div>
          <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-2">Notes (Optional)</p>
          <textarea
            placeholder="Anything worth noting this week..."
            value={form.notes}
            onChange={e => set('notes', e.target.value)}
            rows={3}
            className="w-full bg-brand-gray border border-brand-gray-light rounded-lg px-4 py-3 text-brand-offwhite placeholder-brand-gray-muted text-sm resize-none"
          />
        </div>

        <button
          onClick={handleSubmit}
          disabled={loading}
          className="w-full bg-brand-green text-white font-heading font-bold py-5 rounded-lg text-base uppercase tracking-widest disabled:opacity-40 active:bg-brand-green-light transition-colors"
        >
          {loading ? 'Saving...' : 'Submit Check-In'}
        </button>
      </div>

      <BottomNav active="profile" />
    </div>
  )
}

function ApproveButton({ eventId }: { eventId: string }) {
  const [loading, setLoading] = useState(false)
  async function approve() {
    setLoading(true)
    await fetch('/api/adaptation/approve', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ eventId }),
    })
    setLoading(false)
  }
  return (
    <button
      onClick={approve}
      disabled={loading}
      className="flex-1 bg-brand-green text-white font-heading font-bold py-2 rounded-lg text-xs uppercase tracking-widest disabled:opacity-40"
    >
      {loading ? '...' : 'Apply'}
    </button>
  )
}

function DismissButton({ eventId, onDismiss }: { eventId: string; onDismiss: () => void }) {
  const [loading, setLoading] = useState(false)
  async function dismiss() {
    setLoading(true)
    await fetch('/api/adaptation/dismiss', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ eventId }),
    })
    onDismiss()
    setLoading(false)
  }
  return (
    <button
      onClick={dismiss}
      disabled={loading}
      className="flex-1 border border-brand-gray-light text-brand-gray-muted font-heading font-bold py-2 rounded-lg text-xs uppercase tracking-widest disabled:opacity-40"
    >
      {loading ? '...' : 'Dismiss'}
    </button>
  )
}
