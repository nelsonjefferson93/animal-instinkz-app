import type { User, TrainingMode, Exercise, ProgrammingParams } from '@/types/database'

// ============================================================
// Equipment compatibility rules
// Determines which exercise categories are allowed based on
// the user's equipment_level and workout_environment.
// ============================================================
type AllowedCategories = Set<Exercise['category']>

export function getAllowedCategories(user: Partial<User>): AllowedCategories {
  const env = user.workout_environment ?? 'gym'
  const equip = user.equipment_level ?? 'full_gym'

  if (env === 'home') {
    // Home always restricts to home-compatible regardless of equip level
    // Category filtering is secondary — is_home_compatible is the primary gate
    const allowed: AllowedCategories = new Set(['bodyweight', 'mobility', 'conditioning'])
    if (equip === 'dumbbells' || equip === 'full_gym') {
      allowed.add('kettlebell')  // dumbbells substitute for kettlebells at home
    }
    return allowed
  }

  // Gym environment
  switch (equip) {
    case 'bodyweight':
      return new Set(['bodyweight', 'mobility', 'conditioning'])
    case 'bands':
      return new Set(['bodyweight', 'mobility', 'conditioning'])
    case 'dumbbells':
      return new Set(['bodyweight', 'kettlebell', 'mobility', 'conditioning'])
    case 'full_gym':
    default:
      return new Set(['compound_lift', 'bodyweight', 'machine', 'kettlebell', 'conditioning', 'mobility'])
  }
}

// ============================================================
// isExerciseCompatible
// Returns true if an exercise can be performed given the user's
// environment and equipment constraints.
// ============================================================
export function isExerciseCompatible(exercise: Exercise, user: Partial<User>): boolean {
  const allowed = getAllowedCategories(user)
  if (!allowed.has(exercise.category)) return false
  // Home mode: must be flagged as home-compatible
  if (user.workout_environment === 'home' && !exercise.is_home_compatible) return false
  return true
}

// ============================================================
// substituteExercise
// Given an incompatible exercise and a pool of all exercises,
// finds the best compatible substitute with the same substitution group.
// Returns null if no substitute exists.
// ============================================================
export function substituteExercise(
  incompatible: Exercise,
  allExercises: Exercise[],
  user: Partial<User>
): Exercise | null {
  if (!incompatible.exercise_substitution_group) return null

  return allExercises.find(ex =>
    ex.id !== incompatible.id &&
    ex.exercise_substitution_group === incompatible.exercise_substitution_group &&
    isExerciseCompatible(ex, user)
  ) ?? null
}

// ============================================================
// filterAndSubstituteExercises
// Takes a list of exercises from a workout template and returns
// a filtered + substituted list compatible with the user's setup.
// ============================================================
export function filterAndSubstituteExercises(
  templateExercises: Exercise[],
  allExercises: Exercise[],
  user: Partial<User>
): Array<{ exercise: Exercise; substituted: boolean }> {
  return templateExercises
    .map(ex => {
      if (isExerciseCompatible(ex, user)) {
        return { exercise: ex, substituted: false }
      }
      const sub = substituteExercise(ex, allExercises, user)
      if (sub) {
        return { exercise: sub, substituted: true }
      }
      return null  // no compatible substitute — skip
    })
    .filter((item): item is { exercise: Exercise; substituted: boolean } => item !== null)
}

// ============================================================
// getProgrammingParams
// Returns weekly programming parameters based on goal + experience.
// ============================================================
export function getProgrammingParams(user: Partial<User>): ProgrammingParams {
  const goal = (user.training_mode ?? 'general') as TrainingMode
  const exp = user.training_experience ?? 'intermediate'
  const daysPerWeek = user.workout_days_per_week ?? 4
  const requestedLength = user.session_length_minutes ?? 60

  switch (goal) {
    case 'fat_loss': {
      const cardio = daysPerWeek >= 5 ? 3 : 2
      return {
        sets_per_muscle_per_week: exp === 'beginner' ? 8 : exp === 'intermediate' ? 10 : 12,
        rep_range_min: 10,
        rep_range_max: 15,
        cardio_sessions_per_week: cardio,
        progression_type: 'double_progression',
        deload_week: false,
        session_length_adjusted: Math.min(requestedLength, 60),
      }
    }
    case 'muscle_gain': {
      return {
        sets_per_muscle_per_week: exp === 'beginner' ? 10 : exp === 'intermediate' ? 14 : 18,
        rep_range_min: exp === 'advanced' ? 6 : 8,
        rep_range_max: exp === 'advanced' ? 12 : 15,
        cardio_sessions_per_week: 1,
        progression_type: 'double_progression',
        deload_week: false,
        session_length_adjusted: requestedLength,
      }
    }
    case 'performance': {
      return {
        sets_per_muscle_per_week: exp === 'beginner' ? 8 : 12,
        rep_range_min: 3,
        rep_range_max: 8,
        cardio_sessions_per_week: 2,
        progression_type: 'wave_loading',
        deload_week: false,
        session_length_adjusted: Math.min(requestedLength, 75),
      }
    }
    case 'general':
    default: {
      return {
        sets_per_muscle_per_week: 8,
        rep_range_min: 8,
        rep_range_max: 15,
        cardio_sessions_per_week: 2,
        progression_type: 'double_progression',
        deload_week: false,
        session_length_adjusted: requestedLength,
      }
    }
  }
}

// ============================================================
// applySessionLengthReduction
// Used by adaptation engine when 'session_shortened' fires.
// Reduces by 15 minutes, minimum 20 minutes.
// ============================================================
export function applySessionLengthReduction(currentLength: number): number {
  return Math.max(20, currentLength - 15)
}

// ============================================================
// getEnvironmentLabel
// Returns display label for the environment badge in the UI.
// ============================================================
export function getEnvironmentLabel(user: Partial<User>): { mode: string; subtitle: string } {
  if (user.workout_environment === 'home') {
    return {
      mode: 'HOME MODE',
      subtitle: 'Workouts optimized for your environment',
    }
  }
  return {
    mode: 'GYM MODE',
    subtitle: 'Workouts optimized for your environment',
  }
}
