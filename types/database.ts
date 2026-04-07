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
  // Phase 2: expanded profile fields
  height_inches: number | null
  current_weight_lbs: number | null
  target_weight_lbs: number | null
  body_build: 'lean' | 'average' | 'high_fat' | null
  fat_distribution: 'central' | 'lower' | 'balanced' | null
  training_experience: 'beginner' | 'intermediate' | 'advanced' | null
  workout_environment: 'gym' | 'home'
  equipment_level: 'full_gym' | 'dumbbells' | 'bands' | 'bodyweight'
  workout_days_per_week: number | null
  session_length_minutes: number | null
  nutrition_preference: 'balanced' | 'high_protein' | 'low_carb' | 'fasting' | null
  activity_level: 'sedentary' | 'light' | 'moderate' | 'active' | 'very_active' | null
  sleep_hours_avg: number | null
  stress_level: 'low' | 'moderate' | 'high' | null
  dietary_restrictions: string[]
  food_allergies: string[]
  disliked_foods: string[]
  profile_complete: boolean
  adaptation_mode: 'auto' | 'guided'
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
  // Phase 2: gym/home fields
  is_home_compatible: boolean
  exercise_substitution_group: string | null
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

// ============================================================
// Phase 2: Adaptive Coaching Engine types
// ============================================================

export interface HabitTemplate {
  id: string
  archetype: ArchetypeId | null
  goal: TrainingMode | 'longevity' | null
  fat_distribution: 'central' | 'lower' | 'balanced' | null
  workout_environment: 'gym' | 'home' | null
  habit_name: string
  habit_type: 'daily' | 'weekly'
  target_type: 'binary' | 'count' | 'duration' | 'amount'
  target_value: number | null
  target_unit: string | null
  description: string | null
  sort_order: number
  is_active: boolean
}

export interface UserHabit {
  id: string
  user_id: string
  habit_template_id: string
  is_active: boolean
  assigned_at: string
  current_streak: number
  longest_streak: number
  last_completed_date: string | null
  habit_template?: HabitTemplate
}

export interface UserHabitLog {
  id: string
  user_id: string
  user_habit_id: string
  log_date: string
  completed: boolean
  value_logged: number | null
  notes: string | null
  logged_at: string
}

export interface UserCheckin {
  id: string
  user_id: string
  checkin_date: string
  weight_lbs: number | null
  energy_level: number | null
  sleep_quality: number | null
  stress_level: number | null
  soreness_level: number | null
  hunger_level: number | null
  notes: string | null
  created_at: string
}

export interface UserProgressLog {
  id: string
  user_id: string
  week_start: string
  workouts_completed: number
  workouts_scheduled: number
  habits_completed_rate: number | null
  avg_energy: number | null
  avg_sleep_quality: number | null
  avg_stress: number | null
  weight_change_lbs: number | null
  confidence_score: number
  notes: string | null
  created_at: string
}

export interface AdaptationEvent {
  id: string
  user_id: string
  event_date: string
  event_type: 'habits_simplified' | 'session_shortened' | 'volume_reduced' | 'deload_recommended' | 'calories_adjusted'
  priority_tier: 1 | 2 | 3
  old_value: string | null
  new_value: string | null
  reason: string
  reinforcement: string | null
  confidence_score: number
  week_start: string | null
  status: 'active' | 'pending_approval' | 'approved' | 'dismissed'
  dismissed_at: string | null
  approved_at: string | null
  created_at: string
}

// Nutrition engine output types
export type NutritionGuidanceMode = 'macro' | 'behavioral'

export interface NutritionTargets {
  calories: number
  protein_g: number
  carbs_g: number
  fats_g: number
  hydration_liters: number
  deficit_surplus: number        // negative = deficit, positive = surplus
  tdee: number
  source: 'calculated' | 'static'
  guidance_mode: NutritionGuidanceMode
  behavioral_tips?: string[]
  behavioral_reason?: string
}

// Training engine output types
export interface ProgrammingParams {
  sets_per_muscle_per_week: number
  rep_range_min: number
  rep_range_max: number
  cardio_sessions_per_week: number
  progression_type: 'double_progression' | 'linear' | 'wave_loading'
  deload_week: boolean
  session_length_adjusted: number
}

export interface UserHabitWithTemplate extends UserHabit {
  habit_template: HabitTemplate
  todays_log?: UserHabitLog | null
}
