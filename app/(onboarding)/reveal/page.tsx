'use client'

import { useEffect, useState } from 'react'
import { useRouter } from 'next/navigation'
import { ARCHETYPES } from '@/lib/archetype/profiles'
import type { ArchetypeId } from '@/types/database'

export default function RevealPage() {
  const router = useRouter()
  const [primary, setPrimary] = useState<ArchetypeId | null>(null)
  const [secondary, setSecondary] = useState<ArchetypeId | null>(null)
  const [visible, setVisible] = useState(false)

  useEffect(() => {
    const stored = sessionStorage.getItem('archetype_result')
    if (!stored) {
      router.push('/assessment')
      return
    }
    const result = JSON.parse(stored)
    setPrimary(result.primary)
    setSecondary(result.secondary)
    setTimeout(() => setVisible(true), 300)
  }, [router])

  if (!primary) return null

  const archetype = ARCHETYPES[primary]
  const secondaryArchetype = secondary ? ARCHETYPES[secondary] : null

  return (
    <div
      className={`flex flex-col min-h-dvh page-padding pb-8 transition-opacity duration-700 ${visible ? 'opacity-100' : 'opacity-0'}`}
    >
      {/* Archetype image placeholder */}
      <div className="w-full aspect-square max-w-xs mx-auto mt-8 mb-6 rounded-2xl bg-brand-gray border border-brand-gray-light flex items-center justify-center">
        <span className="font-display text-8xl" style={{ color: archetype.color_accent }}>
          {archetype.display_name[0]}
        </span>
      </div>

      {/* Archetype name */}
      <div className="text-center mb-6">
        <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-1">You are</p>
        <h1
          className="font-display text-7xl leading-none"
          style={{ color: archetype.color_accent }}
        >
          THE {archetype.display_name.toUpperCase()}
        </h1>
        <p className="font-heading text-lg text-brand-offwhite mt-2">
          {archetype.headline}
        </p>
      </div>

      {/* Description */}
      <p className="text-brand-gray-muted text-sm leading-relaxed text-center px-2 mb-4">
        {archetype.description}
      </p>

      {/* Traits */}
      <div className="flex flex-wrap gap-2 justify-center mb-6">
        {archetype.traits.map(trait => (
          <span
            key={trait}
            className="text-xs px-3 py-1 rounded-full border"
            style={{ borderColor: archetype.color_accent, color: archetype.color_accent }}
          >
            {trait}
          </span>
        ))}
      </div>

      {/* Secondary archetype */}
      {secondaryArchetype && (
        <p className="text-center text-brand-gray-muted text-xs mb-8">
          Secondary: The {secondaryArchetype.display_name}
        </p>
      )}

      <button
        onClick={() => router.push('/mode-select')}
        className="w-full bg-brand-green text-white font-heading font-bold py-5 rounded-lg text-base uppercase tracking-widest active:bg-brand-green-light transition-colors mt-auto"
      >
        Enter Your Training
      </button>
    </div>
  )
}
