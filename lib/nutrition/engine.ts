import type { User, TrainingMode, NutritionTargets, NutritionGuidanceMode } from '@/types/database'

// ============================================================
// Activity multipliers for TDEE calculation (Mifflin-St Jeor)
// ============================================================
const ACTIVITY_MULTIPLIERS: Record<string, number> = {
  sedentary:   1.2,
  light:       1.375,
  moderate:    1.55,
  active:      1.725,
  very_active: 1.9,
}

// Calorie adjustments by goal (relative to TDEE)
const GOAL_CALORIE_OFFSET: Record<TrainingMode, number> = {
  fat_loss:     -400,
  muscle_gain:  +275,
  performance:  +100,
  general:      0,
}

// Protein multiplier (g per lb bodyweight) by goal
const PROTEIN_MULTIPLIER: Record<TrainingMode, number> = {
  fat_loss:     1.0,  // higher protein to preserve muscle in deficit
  muscle_gain:  0.85,
  performance:  0.9,
  general:      0.8,
}

// Behavioral guidance for low-adherence mode
const BEHAVIORAL_TIPS = [
  "Eat protein at every meal — don't count, just prioritize it.",
  "Fill half your plate with vegetables at lunch and dinner.",
  "Drink a full glass of water before every meal.",
  "Stop eating when you feel 80% full — not stuffed.",
  "Avoid eating within 2 hours of bedtime when possible.",
  "Prep one high-protein food in advance each week (eggs, chicken, Greek yogurt).",
]

// ============================================================
// calculateNutrition
// Returns macro targets calculated from user profile.
// Falls back to estimated values when height/weight are missing.
// guidanceMode: 'behavioral' when recent adherence is low.
// ============================================================
export function calculateNutrition(
  user: Partial<User>,
  recentHabitAdherence?: number   // 0.0–1.0 from UserProgressLog; undefined = no data yet
): NutritionTargets {

  const goal = (user.training_mode ?? 'general') as TrainingMode
  const activityKey = user.activity_level ?? 'moderate'
  const activityMult = ACTIVITY_MULTIPLIERS[activityKey] ?? 1.55

  // Use profile weight if available, otherwise estimate a neutral 180 lbs
  const weightLbs = user.current_weight_lbs ?? 180
  // Use profile height if available, otherwise estimate 70 inches (5'10")
  const heightInches = user.height_inches ?? 70

  // Mifflin-St Jeor BMR (using male formula as default — no sex field yet)
  // BMR = 10 × kg + 6.25 × cm − 5 × age + 5
  // Convert: lbs → kg, inches → cm
  const weightKg = weightLbs * 0.453592
  const heightCm = heightInches * 2.54
  const age = 35  // neutral default; no dob field yet
  const bmr = Math.round(10 * weightKg + 6.25 * heightCm - 5 * age + 5)
  const tdee = Math.round(bmr * activityMult)

  // Calorie target
  let calorieOffset = GOAL_CALORIE_OFFSET[goal]
  // Adjust offset for body composition
  if (user.body_build === 'high_fat' && goal === 'fat_loss') calorieOffset -= 100
  if (user.body_build === 'lean' && goal === 'fat_loss') calorieOffset += 100
  const calories = Math.max(1200, tdee + calorieOffset)

  // Macros
  const proteinMult = PROTEIN_MULTIPLIER[goal]
  // Apply nutrition preference adjustments
  let proteinG = Math.round(weightLbs * proteinMult)
  let fatsPercent = 0.25
  if (user.nutrition_preference === 'high_protein') {
    proteinG = Math.round(proteinG * 1.1)
    fatsPercent = 0.22
  } else if (user.nutrition_preference === 'low_carb') {
    fatsPercent = 0.35
  } else if (user.nutrition_preference === 'fasting') {
    fatsPercent = 0.30
  }

  const fatsG = Math.round((calories * fatsPercent) / 9)
  const proteinCals = proteinG * 4
  const fatsCals = fatsG * 9
  const carbsG = Math.max(0, Math.round((calories - proteinCals - fatsCals) / 4))

  // Hydration: 0.5 oz per lb bodyweight → convert to liters
  const hydrationLiters = Math.round((weightLbs * 0.5 / 33.814) * 10) / 10

  const deficitSurplus = calories - tdee

  // Guidance mode: shift to behavioral tips when adherence is low
  const guidanceMode: NutritionGuidanceMode =
    recentHabitAdherence !== undefined && recentHabitAdherence < 0.5
      ? 'behavioral'
      : 'macro'

  if (guidanceMode === 'behavioral') {
    return {
      calories,
      protein_g: proteinG,
      carbs_g: carbsG,
      fats_g: fatsG,
      hydration_liters: hydrationLiters,
      deficit_surplus: deficitSurplus,
      tdee,
      source: 'calculated',
      guidance_mode: 'behavioral',
      behavioral_tips: BEHAVIORAL_TIPS,
      behavioral_reason:
        "When adherence is low, behavior beats macro math. Focus on these habits first — the numbers will follow.",
    }
  }

  return {
    calories,
    protein_g: proteinG,
    carbs_g: carbsG,
    fats_g: fatsG,
    hydration_liters: hydrationLiters,
    deficit_surplus: deficitSurplus,
    tdee,
    source: 'calculated',
    guidance_mode: 'macro',
  }
}

// ============================================================
// filterMeals
// Removes meals that conflict with user's dietary restrictions,
// allergies, or disliked foods. Case-insensitive substring match.
// ============================================================
export function filterMeals<T extends { meal_name: string; description?: string | null }>(
  meals: T[],
  user: Partial<User>
): T[] {
  const restrictions = [
    ...(user.dietary_restrictions ?? []),
    ...(user.food_allergies ?? []),
    ...(user.disliked_foods ?? []),
  ].map(s => s.toLowerCase().trim()).filter(Boolean)

  if (restrictions.length === 0) return meals

  return meals.filter(meal => {
    const searchText = `${meal.meal_name} ${meal.description ?? ''}`.toLowerCase()
    return !restrictions.some(r => searchText.includes(r))
  })
}

// ============================================================
// getCalorieAdjustment
// Used by the adaptation engine to calculate adjusted targets
// after a 'calories_adjusted' event has fired.
// ============================================================
export function getCalorieAdjustment(
  base: NutritionTargets,
  deltaCalories: number
): NutritionTargets {
  const newCalories = Math.max(1200, base.calories + deltaCalories)
  const delta = newCalories - base.calories
  const carbsDelta = Math.round(delta / 4)  // adjust carbs first

  return {
    ...base,
    calories: newCalories,
    carbs_g: Math.max(0, base.carbs_g + carbsDelta),
    deficit_surplus: base.deficit_surplus + delta,
  }
}
