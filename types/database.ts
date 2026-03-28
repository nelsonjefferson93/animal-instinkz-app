export type ArchetypeId = 'wolf' | 'lion' | 'panther' | 'bear' | 'hawk' | 'gorilla' | 'stallion' | 'fox'
export type TrainingMode = 'fat_loss' | 'muscle_gain' | 'performance' | 'general'
export type SubscriptionTier = 'free' | 'premium'

export interface Archetype {
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
  illustration_url: string | null
  color_accent: string | null
  created_at: string
}

export interface User {
  id: string
  email: string
  display_name: string | null
  avatar_url: string | null
  training_mode: TrainingMode
  subscription_tier: SubscriptionTier
  subscription_status: 'active' | 'cancelled' | 'past_due'
  stripe_customer_id: string | null
  onboarding_complete: boolean
  created_at: string
  updated_at: string
}

export interface UserArchetype {
  id: string
  user_id: string
  primary_archetype: ArchetypeId
  secondary_archetype: ArchetypeId | null
  scores: Record<ArchetypeId, number>
  is_active: boolean
  assigned_at: string
}

export interface AssessmentResponse {
  id: string
  user_id: string
  answers: Record<string, string>
  result_scores: Record<ArchetypeId, number>
  primary_result: ArchetypeId
  attempt_number: number
  completed_at: string
}

export interface Exercise {
  id: string
  name: string
  category: 'compound_lift' | 'bodyweight' | 'machine' | 'kettlebell' | 'conditioning' | 'mobility' | 'hundred_series'
  equipment: string[]
  movement_pattern: 'push' | 'pull' | 'hinge' | 'squat' | 'carry' | 'rotation' | 'locomotion' | null
  muscle_primary: string[]
  muscle_secondary: string[]
  difficulty: 'beginner' | 'intermediate' | 'advanced'
  hundred_series_approved: boolean
  coaching_cues: string[]
  archetype_affinity: ArchetypeId[]
  video_url: string | null
  created_at: string
}

export interface WorkoutTemplate {
  id: string
  archetype_id: ArchetypeId | null
  training_mode: TrainingMode
  week_number: number
  day_label: string
  day_number: number
  estimated_duration_min: number | null
  notes: string | null
  created_at: string
}

export interface WorkoutTemplateExercise {
  id: string
  template_id: string
  exercise_id: string
  exercise_order: number
  block: 'activation' | 'primary' | 'accessory' | 'finisher' | 'cooldown'
  sets: number
  reps_min: number | null
  reps_max: number | null
  rpe_target: number | null
  rest_seconds: number
  coaching_note: string | null
  exercise?: Exercise
}

export interface WorkoutLog {
  id: string
  user_id: string
  template_id: string | null
  archetype_id: ArchetypeId | null
  training_mode: TrainingMode | null
  completed_at: string
  duration_actual_min: number | null
  perceived_difficulty: number | null
  notes: string | null
}

export interface HundredSeriesLog {
  id: string
  user_id: string
  exercise_id: string
  archetype_id: ArchetypeId | null
  level_attempted: 20 | 40 | 60 | 80 | 100
  reps_completed: number
  level_completed: boolean
  duration_seconds: number | null
  rest_count: number
  attempted_at: string
  notes: string | null
}

export interface UserHundredSeriesProgress {
  user_id: string
  current_level: 20 | 40 | 60 | 80 | 100
  exercise_id: string | null
  best_reps: number
  total_attempts: number
  last_attempted_at: string | null
  updated_at: string
}

export interface HabitLog {
  id: string
  user_id: string
  habit_id: string
  logged_date: string
  completed: boolean
  logged_at: string
}

export interface Habit {
  id: string
  archetype_id: ArchetypeId
  habit_name: string
  description: string | null
  habit_order: number
  icon: string | null
}

export interface Streak {
  user_id: string
  current_streak: number
  longest_streak: number
  last_activity_date: string | null
  streak_type: string
  updated_at: string
}

// Assessment answer map
export type AssessmentAnswers = {
  q1: string
  q2: string
  q3: string
  q4: string
  q5: string
}
