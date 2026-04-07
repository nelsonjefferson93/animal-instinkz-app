'use client'

import { useState } from 'react'
import type { AdaptationEvent } from '@/types/database'

const EVENT_LABELS: Record<string, string> = {
  habits_simplified:   'Habits Simplified',
  session_shortened:   'Session Length Adjusted',
  volume_reduced:      'Training Volume Reduced',
  deload_recommended:  'Deload Week Recommended',
  calories_adjusted:   'Calorie Target Adjusted',
}

function EventCard({
  event,
  showActions,
  onApprove,
  onDismiss,
}: {
  event: AdaptationEvent
  showActions: boolean
  onApprove?: (id: string) => Promise<void>
  onDismiss?: (id: string) => void
}) {
  const [approving, setApproving] = useState(false)
  const [dismissing, setDismissing] = useState(false)
  const [dismissed, setDismissed] = useState(false)

  if (dismissed) return null

  async function handleApprove() {
    setApproving(true)
    await onApprove?.(event.id)
    setApproving(false)
  }

  function handleDismiss() {
    setDismissing(true)
    onDismiss?.(event.id)
    setDismissed(true)
  }

  return (
    <div className="border-l-4 border-brand-green pl-4 py-1">
      <p className="text-brand-green text-xs uppercase tracking-widest font-heading font-bold mb-1">
        {EVENT_LABELS[event.event_type] ?? event.event_type}
        {event.status === 'pending_approval' && (
          <span className="ml-2 text-yellow-400">· Pending Your Approval</span>
        )}
      </p>
      <p className="text-brand-offwhite text-sm leading-relaxed mb-2">{event.reason}</p>
      {event.reinforcement && (
        <p className="text-brand-gray-muted text-xs italic">{event.reinforcement}</p>
      )}
      {showActions && event.status === 'pending_approval' && (
        <div className="flex gap-2 mt-3">
          <button
            type="button"
            onClick={handleApprove}
            disabled={approving}
            className="flex-1 bg-brand-green text-white font-heading font-bold py-2 rounded-lg text-xs uppercase tracking-widest disabled:opacity-40 transition-colors"
          >
            {approving ? '...' : 'Apply Change'}
          </button>
          <button
            type="button"
            onClick={handleDismiss}
            disabled={dismissing}
            className="flex-1 border border-brand-gray-light text-brand-gray-muted font-heading font-bold py-2 rounded-lg text-xs uppercase tracking-widest disabled:opacity-40 transition-colors"
          >
            Dismiss
          </button>
        </div>
      )}
    </div>
  )
}

export default function AdaptationPanel({
  pendingEvents,
  activeEvents,
  isGuided,
}: {
  pendingEvents: AdaptationEvent[]
  activeEvents: AdaptationEvent[]
  isGuided: boolean
}) {
  const [localPending, setLocalPending] = useState(pendingEvents)
  const [localActive, setLocalActive] = useState(activeEvents)

  async function handleApprove(id: string) {
    await fetch('/api/adaptation/approve', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ eventId: id }),
    })
    const event = localPending.find(e => e.id === id)
    if (event) {
      setLocalPending(prev => prev.filter(e => e.id !== id))
      setLocalActive(prev => [...prev, { ...event, status: 'approved' }])
    }
  }

  function handleDismiss(id: string) {
    fetch('/api/adaptation/dismiss', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ eventId: id }),
    })
    setLocalPending(prev => prev.filter(e => e.id !== id))
    setLocalActive(prev => prev.filter(e => e.id !== id))
  }

  const hasContent = localPending.length > 0 || localActive.length > 0
  if (!hasContent) return null

  return (
    <div className="bg-brand-gray rounded-2xl p-5">
      <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-4">Plan Adjustments</p>
      <div className="flex flex-col gap-4">
        {localPending.map(event => (
          <EventCard
            key={event.id}
            event={event}
            showActions={isGuided}
            onApprove={handleApprove}
            onDismiss={handleDismiss}
          />
        ))}
        {localActive.map(event => (
          <EventCard
            key={event.id}
            event={event}
            showActions={false}
          />
        ))}
      </div>
    </div>
  )
}
