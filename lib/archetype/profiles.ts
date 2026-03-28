import type { ArchetypeId } from '@/types/database'

export interface ArchetypeProfile {
  id: ArchetypeId
  display_name: string
  headline: string
  description: string
  traits: string[]
  strengths: string[]
  blind_spots: string[]
  training_style: string
  nutrition_style: string
  coaching_tone: string
  color_accent: string
  hundred_series_cues: string[]
}

export const ARCHETYPES: Record<ArchetypeId, ArchetypeProfile> = {
  wolf: {
    id: 'wolf',
    display_name: 'Wolf',
    headline: 'Disciplined. Structured. Relentless.',
    description:
      'The Wolf is built on systems. Where others improvise, the Wolf executes the plan. Consistency is the weapon — not intensity, not inspiration. The Wolf shows up because that is what the Wolf does.',
    traits: ['Methodical', 'Consistent', 'Goal-oriented', 'Strategic'],
    strengths: ['Follows through on plans', 'Thrives on routine', 'High mental endurance'],
    blind_spots: ['Over-structures', 'Struggles when plans break', 'Can miss intuitive opportunities'],
    training_style: 'Periodized programming, progressive overload, structured splits',
    nutrition_style: 'Strict macro tracking, meal prep, consistency over optimization',
    coaching_tone: 'Direct and minimal — trusts you to execute',
    color_accent: '#4A90D9',
    hundred_series_cues: [
      'Stay the course. The plan is working.',
      'One rep at a time. Systems win.',
      'Discipline over motivation. Keep moving.',
    ],
  },
  lion: {
    id: 'lion',
    display_name: 'Lion',
    headline: 'Powerful. Dominant. Present.',
    description:
      'The Lion trains with full presence and raw intensity. Every session is a statement. The Lion does not grind in silence — it commands the room and the moment.',
    traits: ['Explosive', 'Confident', 'Dominant', 'Present'],
    strengths: ['Thrives under pressure', 'Natural intensity', 'Leads by example'],
    blind_spots: ['Inconsistent when motivation dips', 'Can overtrain', 'Undervalues recovery'],
    training_style: 'High-intensity, compound movements, max effort days',
    nutrition_style: 'High protein, performance fueling, aggressive surplus for muscle',
    coaching_tone: 'Bold and energizing — commands action',
    color_accent: '#E8A020',
    hundred_series_cues: [
      'You were built for this moment.',
      'The room feels you. Keep going.',
      'Dominate every single rep.',
    ],
  },
  panther: {
    id: 'panther',
    display_name: 'Panther',
    headline: 'Precise. Agile. Calculated.',
    description:
      'The Panther moves with intention. Every rep is deliberate, every session is engineered. The Panther does not waste movement — it executes with surgical precision and athletic grace.',
    traits: ['Precise', 'Agile', 'Calculated', 'Efficient'],
    strengths: ['Technical excellence', 'Athletic versatility', 'Smart training decisions'],
    blind_spots: ['Can overthink execution', 'Perfectionism slows momentum', 'Avoids messy effort'],
    training_style: 'Athletic training, skill development, movement quality focus',
    nutrition_style: 'Precision nutrition, timed fueling, body composition focus',
    coaching_tone: 'Technical and encouraging — rewards precision',
    color_accent: '#9B59B6',
    hundred_series_cues: [
      'Precision is power. Each rep counts.',
      'Move with intention. Stay sharp.',
      'Calculated effort. Maximum output.',
    ],
  },
  bear: {
    id: 'bear',
    display_name: 'Bear',
    headline: 'Durable. Grounded. Relentless.',
    description:
      'The Bear does not peak — it endures. Built on a foundation of grit and durability, the Bear outlasts everything. It does not need to be the fastest or most explosive. It just needs to still be standing.',
    traits: ['Durable', 'Grounded', 'Persistent', 'Resilient'],
    strengths: ['Long-term consistency', 'Handles high volume', 'Mental toughness in grind'],
    blind_spots: ['Undervalues intensity', 'Can plateau without variation', 'Resists change'],
    training_style: 'High volume, slow progression, powerlifting foundations',
    nutrition_style: 'Whole food focused, steady caloric surplus, anti-inflammatory emphasis',
    coaching_tone: 'Steady and grounding — keeps you moving no matter what',
    color_accent: '#8B4513',
    hundred_series_cues: [
      'You outlast everything. Keep grinding.',
      'Durability wins. One more rep.',
      'The Bear does not quit. Ever.',
    ],
  },
  hawk: {
    id: 'hawk',
    display_name: 'Hawk',
    headline: 'Strategic. Aware. Above the noise.',
    description:
      'The Hawk sees what others miss. Training is a chess match — every session is optimized, every variable considered. The Hawk does not just work hard. It works smart.',
    traits: ['Strategic', 'Analytical', 'Self-aware', 'Adaptive'],
    strengths: ['Optimizes training variables', 'Learns fast from data', 'Avoids overtraining'],
    blind_spots: ['Can analyze instead of act', 'Overthinks simple sessions', 'Loses the feel of training'],
    training_style: 'Data-driven, periodized, auto-regulation based on performance',
    nutrition_style: 'Strategic macro cycling, planned re-feeds, performance tracking',
    coaching_tone: 'Analytical and precise — gives you the why behind everything',
    color_accent: '#27AE60',
    hundred_series_cues: [
      'You see the full picture. Execute.',
      'Strategic effort. Maximum return.',
      'Rise above. The Hawk always does.',
    ],
  },
  gorilla: {
    id: 'gorilla',
    display_name: 'Gorilla',
    headline: 'Powerful. Grounded. Built for dominance.',
    description:
      'The Gorilla is raw power with a foundation. Heavy, controlled, and built to dominate. The Gorilla does not chase aesthetics — it earns strength through hard work and shows up to move serious weight.',
    traits: ['Powerful', 'Physical', 'Grounded', 'Dominant'],
    strengths: ['Exceptional raw strength', 'High pain tolerance', 'Built for heavy compound work'],
    blind_spots: ['Mobility limitations', 'Ignores accessory work', 'Can plateau on ego lifting'],
    training_style: 'Powerbuilding, heavy compound lifts, strength first mindset',
    nutrition_style: 'High calorie, protein-dense, performance over aesthetics',
    coaching_tone: 'Raw and powerful — demands maximum effort',
    color_accent: '#2C3E50',
    hundred_series_cues: [
      'Pure power. No excuses.',
      'Gorillas do not stop. Neither do you.',
      'Built for this. Own every rep.',
    ],
  },
  stallion: {
    id: 'stallion',
    display_name: 'Stallion',
    headline: 'Endurance. Freedom. Grit that outlasts.',
    description:
      'The Stallion runs when others walk. Built for the long haul — mentally and physically. The Stallion does not burn out because it was made to keep moving. Distance is home.',
    traits: ['Enduring', 'Free-spirited', 'Gritty', 'Adaptive'],
    strengths: ['Exceptional cardiovascular capacity', 'Mental stamina', 'Thrives in long sessions'],
    blind_spots: ['Undertrains strength', 'Avoids rest', 'Can neglect muscle development'],
    training_style: 'Endurance-based, hybrid cardio-strength, long duration sessions',
    nutrition_style: 'Carb-forward, endurance fueling, consistent energy maintenance',
    coaching_tone: 'Motivating and free — keeps the fire alive for the long run',
    color_accent: '#E74C3C',
    hundred_series_cues: [
      'Stallions are built to outlast.',
      'Keep running. The finish line is yours.',
      'Endurance is your superpower. Use it.',
    ],
  },
  fox: {
    id: 'fox',
    display_name: 'Fox',
    headline: 'Adaptive. Intelligent. Tactically superior.',
    description:
      'The Fox wins by being smarter, not louder. Training adapts to the situation — no rigid plan, no wasted effort. The Fox reads the environment and finds the most efficient path to the result.',
    traits: ['Adaptive', 'Intelligent', 'Creative', 'Efficient'],
    strengths: ['Fast adaptation', 'Creative problem solving', 'Gets results with less waste'],
    blind_spots: ['Inconsistency without structure', 'Chases novelty over depth', 'Can avoid hard fundamentals'],
    training_style: 'Flexible programming, variety-driven, instinctive training approach',
    nutrition_style: 'Flexible dieting, intuitive eating framework, outcome-based adjustments',
    coaching_tone: 'Clever and adaptive — gives you options, not orders',
    color_accent: '#E67E22',
    hundred_series_cues: [
      'The smartest path wins. Keep adapting.',
      'Efficiency is strength. No wasted reps.',
      'Tactical. Relentless. Fox never loses.',
    ],
  },
}

export const ASSESSMENT_QUESTIONS = [
  {
    id: 'q1',
    question: 'When you train consistently, what does your body tend to do?',
    options: [
      { key: 'A', text: 'Build muscle relatively easily' },
      { key: 'B', text: 'Stay lean or lose fat easily' },
      { key: 'C', text: 'Gain mass if I\'m not precise' },
      { key: 'D', text: 'Athletic and responsive to any training' },
    ],
  },
  {
    id: 'q2',
    question: 'What type of training session feels most natural to you?',
    options: [
      { key: 'A', text: 'Structured plans with clear progression' },
      { key: 'B', text: 'Heavy, intense, all-out effort' },
      { key: 'C', text: 'Technical, skill-based, precise movement' },
      { key: 'D', text: 'Long sessions, steady pacing, endurance work' },
    ],
  },
  {
    id: 'q3',
    question: 'When things get hard mid-workout, what do you do?',
    options: [
      { key: 'A', text: 'Lock in. The plan says keep going, so I keep going.' },
      { key: 'B', text: 'Dig deeper. The hardest moment is where I separate myself.' },
      { key: 'C', text: 'Recalibrate. Find the most efficient path through.' },
      { key: 'D', text: 'Adapt. I\'ll find another way to get the result.' },
    ],
  },
  {
    id: 'q4',
    question: 'How would you describe your training consistency?',
    options: [
      { key: 'A', text: 'I follow a plan — same time, same structure, every week' },
      { key: 'B', text: 'I show up when the fire is there — and I go all out when I do' },
      { key: 'C', text: 'I grind steadily — not flashy, just always there' },
      { key: 'D', text: 'I shift based on what\'s working — always adjusting' },
    ],
  },
  {
    id: 'q5',
    question: 'What drives you to train?',
    options: [
      { key: 'A', text: 'The discipline. The system. Executing the plan.' },
      { key: 'B', text: 'Power, dominance, being at my physical peak.' },
      { key: 'C', text: 'Outlasting everything. Grit. Not stopping.' },
      { key: 'D', text: 'Being smarter, more efficient, always evolving.' },
    ],
  },
]
