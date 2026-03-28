import type { ArchetypeId, AssessmentAnswers } from '@/types/database'

type ArchetypeScores = Record<ArchetypeId, number>

export function scoreArchetype(answers: AssessmentAnswers): {
  primary: ArchetypeId
  secondary: ArchetypeId
  scores: ArchetypeScores
} {
  const scores: ArchetypeScores = {
    wolf: 0,
    lion: 0,
    panther: 0,
    bear: 0,
    hawk: 0,
    gorilla: 0,
    stallion: 0,
    fox: 0,
  }

  // Q1 — Body type / physical response to training
  if (answers.q1 === 'A') { scores.gorilla += 3; scores.lion += 2; scores.bear += 1 }
  if (answers.q1 === 'B') { scores.panther += 3; scores.fox += 2; scores.hawk += 1 }
  if (answers.q1 === 'C') { scores.bear += 3; scores.gorilla += 2; scores.stallion += 1 }
  if (answers.q1 === 'D') { scores.stallion += 3; scores.wolf += 2; scores.fox += 1 }

  // Q2 — Training preference
  if (answers.q2 === 'A') { scores.wolf += 3; scores.gorilla += 2; scores.hawk += 1 }
  if (answers.q2 === 'B') { scores.lion += 3; scores.wolf += 2; scores.gorilla += 1 }
  if (answers.q2 === 'C') { scores.panther += 3; scores.hawk += 2; scores.fox += 1 }
  if (answers.q2 === 'D') { scores.stallion += 3; scores.bear += 2; scores.fox += 1 }

  // Q3 — Mindset under pressure
  if (answers.q3 === 'A') { scores.wolf += 3; scores.hawk += 2; scores.bear += 1 }
  if (answers.q3 === 'B') { scores.lion += 3; scores.gorilla += 2; scores.stallion += 1 }
  if (answers.q3 === 'C') { scores.panther += 3; scores.wolf += 2; scores.hawk += 1 }
  if (answers.q3 === 'D') { scores.fox += 3; scores.stallion += 2; scores.panther += 1 }

  // Q4 — Consistency pattern
  if (answers.q4 === 'A') { scores.wolf += 3; scores.hawk += 2; scores.bear += 1 }
  if (answers.q4 === 'B') { scores.lion += 3; scores.gorilla += 2; scores.fox += 1 }
  if (answers.q4 === 'C') { scores.bear += 3; scores.stallion += 2; scores.wolf += 1 }
  if (answers.q4 === 'D') { scores.fox += 3; scores.stallion += 2; scores.panther += 1 }

  // Q5 — Identity driver
  if (answers.q5 === 'A') { scores.wolf += 3; scores.hawk += 2 }
  if (answers.q5 === 'B') { scores.lion += 3; scores.gorilla += 2 }
  if (answers.q5 === 'C') { scores.stallion += 3; scores.bear += 2 }
  if (answers.q5 === 'D') { scores.fox += 3; scores.panther += 2 }

  const sorted = (Object.entries(scores) as [ArchetypeId, number][]).sort(
    (a, b) => b[1] - a[1]
  )

  return {
    primary: sorted[0][0],
    secondary: sorted[1][0],
    scores,
  }
}
