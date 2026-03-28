'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { ASSESSMENT_QUESTIONS } from '@/lib/archetype/profiles'
import { scoreArchetype } from '@/lib/archetype/scoring'
import { createClient } from '@/lib/supabase/client'
import type { AssessmentAnswers } from '@/types/database'

export default function AssessmentPage() {
  const router = useRouter()
  const [currentQ, setCurrentQ] = useState(0)
  const [answers, setAnswers] = useState<Partial<AssessmentAnswers>>({})
  const [loading, setLoading] = useState(false)

  const question = ASSESSMENT_QUESTIONS[currentQ]
  const progress = ((currentQ) / ASSESSMENT_QUESTIONS.length) * 100

  async function handleAnswer(key: string) {
    const newAnswers = { ...answers, [question.id]: key }
    setAnswers(newAnswers)

    if (currentQ < ASSESSMENT_QUESTIONS.length - 1) {
      setCurrentQ(prev => prev + 1)
      return
    }

    // All questions answered — score and save
    setLoading(true)
    const completeAnswers = newAnswers as AssessmentAnswers
    const result = scoreArchetype(completeAnswers)

    const supabase = createClient()
    const { data: { user } } = await supabase.auth.getUser()

    if (!user) {
      router.push('/login')
      return
    }

    // Save assessment response
    await supabase.from('assessment_responses').insert({
      user_id: user.id,
      answers: completeAnswers,
      result_scores: result.scores,
      primary_result: result.primary,
    })

    // Save / update user archetype
    await supabase.from('user_archetypes').upsert({
      user_id: user.id,
      primary_archetype: result.primary,
      secondary_archetype: result.secondary,
      scores: result.scores,
      is_active: true,
    })

    // Store result in sessionStorage for reveal page
    sessionStorage.setItem('archetype_result', JSON.stringify(result))

    router.push('/reveal')
  }

  if (loading) {
    return (
      <div className="flex flex-col min-h-dvh items-center justify-center gap-6">
        <div className="w-16 h-16 rounded-full bg-brand-gray border-2 border-brand-green flex items-center justify-center">
          <span className="font-display text-2xl text-brand-green">AI</span>
        </div>
        <p className="font-heading text-xl text-brand-offwhite">Finding your animal...</p>
      </div>
    )
  }

  return (
    <div className="flex flex-col min-h-dvh page-padding pt-8 pb-6">
      {/* Progress bar */}
      <div className="w-full bg-brand-gray rounded-full h-1 mb-8">
        <div
          className="bg-brand-green h-1 rounded-full transition-all duration-300"
          style={{ width: `${progress}%` }}
        />
      </div>

      <div className="flex-1 flex flex-col justify-between">
        <div>
          <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-4">
            Question {currentQ + 1} of {ASSESSMENT_QUESTIONS.length}
          </p>
          <h2 className="font-heading text-2xl text-brand-offwhite leading-snug mb-10">
            {question.question}
          </h2>

          <div className="flex flex-col gap-3">
            {question.options.map(option => (
              <button
                key={option.key}
                onClick={() => handleAnswer(option.key)}
                className="w-full bg-brand-gray border border-brand-gray-light rounded-lg px-5 py-4 text-left text-brand-offwhite text-sm font-body active:bg-brand-gray-light active:border-brand-green transition-colors"
              >
                <span className="text-brand-green font-bold mr-3">{option.key}</span>
                {option.text}
              </button>
            ))}
          </div>
        </div>
      </div>
    </div>
  )
}
