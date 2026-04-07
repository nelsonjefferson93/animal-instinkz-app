import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import { ARCHETYPES } from '@/lib/archetype/profiles'
import { calculateNutrition, filterMeals } from '@/lib/nutrition/engine'
import type { User } from '@/types/database'
import BottomNav from '@/components/layout/BottomNav'

const MEAL_TYPE_LABELS: Record<string, string> = {
  breakfast: 'Breakfast',
  lunch: 'Lunch',
  dinner: 'Dinner',
  snack: 'Snack',
  performance: 'Performance',
}

export default async function NutritionPage() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect('/login')

  const [archetypeRes, profileRes] = await Promise.all([
    supabase.from('user_archetypes').select('primary_archetype').eq('user_id', user.id).eq('is_active', true).single(),
    supabase.from('users').select('*').eq('id', user.id).single(),
  ])

  const archetypeId = archetypeRes.data?.primary_archetype?.toLowerCase() ?? 'lion'
  const profile = profileRes.data as User | null
  const goal = profile?.training_mode ?? 'fat_loss'
  const archetype = ARCHETYPES[archetypeId as keyof typeof ARCHETYPES] ?? null

  // Get recent adherence for behavioral fallback decision
  const { data: recentProgress } = await supabase
    .from('user_progress_logs')
    .select('habits_completed_rate')
    .eq('user_id', user.id)
    .order('week_start', { ascending: false })
    .limit(1)
    .single()

  const recentAdherence = recentProgress?.habits_completed_rate ?? undefined

  // Calculate dynamic nutrition targets if profile is complete
  const calculatedTargets = profile?.profile_complete
    ? calculateNutrition(profile, recentAdherence)
    : null

  // Always fetch static plan as fallback
  const { data: plan } = await supabase
    .from('nutrition_plans')
    .select('*')
    .eq('archetype', archetypeId)
    .eq('goal', goal)
    .single()

  const [mealsRes, tipsRes] = plan
    ? await Promise.all([
        supabase.from('nutrition_meals').select('*').eq('nutrition_plan_id', plan.id).order('sort_order'),
        supabase.from('nutrition_tips').select('*').eq('nutrition_plan_id', plan.id).order('sort_order'),
      ])
    : [{ data: [] }, { data: [] }]

  // Filter meals based on dietary preferences if profile is complete
  const rawMeals = mealsRes.data ?? []
  const meals = profile?.profile_complete ? filterMeals(rawMeals, profile) : rawMeals
  const tips = tipsRes.data ?? []

  // Determine what targets to show
  const displayTargets = calculatedTargets ?? (plan ? {
    calories: plan.calories,
    protein_g: plan.protein_g,
    carbs_g: plan.carbs_g,
    fats_g: plan.fats_g,
    hydration_liters: plan.hydration_liters,
    deficit_surplus: 0,
    tdee: 0,
    source: 'static' as const,
    guidance_mode: 'macro' as const,
  } : null)

  return (
    <div className="flex flex-col min-h-dvh bg-brand-black pb-24">
      <div className="page-padding pt-10 pb-4">
        <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-1">
          {archetype ? `${archetype.display_name} Plan` : 'Your Plan'}
        </p>
        <h1 className="font-display text-5xl text-brand-offwhite">NUTRITION</h1>
        <p className="text-brand-gray-muted text-sm mt-1">
          {goal.replace('_', ' ').toUpperCase()}
          {calculatedTargets && (
            <span className="ml-2 text-brand-green">· Personalized</span>
          )}
        </p>
      </div>

      {/* Targets — behavioral or macro */}
      {displayTargets ? (
        <>
          <div className="page-padding mb-4">
            <div className="bg-brand-gray rounded-2xl p-5">
              {displayTargets.guidance_mode === 'behavioral' ? (
                // Low-adherence behavioral mode
                <div>
                  <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-2">Focus Right Now</p>
                  <p className="text-brand-gray-muted text-sm mb-4 leading-relaxed">
                    {(displayTargets as typeof calculatedTargets)?.behavioral_reason}
                  </p>
                  <div className="flex flex-col gap-2">
                    {((displayTargets as typeof calculatedTargets)?.behavioral_tips ?? []).map((tip, i) => (
                      <div key={i} className="flex items-start gap-2">
                        <span className="text-brand-green text-sm flex-shrink-0 mt-0.5">→</span>
                        <p className="text-brand-offwhite text-sm">{tip}</p>
                      </div>
                    ))}
                  </div>
                  {/* Still show reduced macro summary */}
                  <div className="mt-4 pt-4 border-t border-brand-gray-light">
                    <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-2">Your Targets (Reference)</p>
                    <div className="grid grid-cols-4 gap-2 text-center opacity-60">
                      <div>
                        <p className="font-heading font-bold text-brand-green text-base">{displayTargets.calories}</p>
                        <p className="text-brand-gray-muted text-xs mt-0.5">kcal</p>
                      </div>
                      <div>
                        <p className="font-heading font-bold text-brand-offwhite text-base">{displayTargets.protein_g}g</p>
                        <p className="text-brand-gray-muted text-xs mt-0.5">protein</p>
                      </div>
                      <div>
                        <p className="font-heading font-bold text-brand-offwhite text-base">{displayTargets.carbs_g}g</p>
                        <p className="text-brand-gray-muted text-xs mt-0.5">carbs</p>
                      </div>
                      <div>
                        <p className="font-heading font-bold text-brand-offwhite text-base">{displayTargets.fats_g}g</p>
                        <p className="text-brand-gray-muted text-xs mt-0.5">fats</p>
                      </div>
                    </div>
                  </div>
                </div>
              ) : (
                // Standard macro mode
                <div>
                  <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-3">Daily Targets</p>
                  <div className="grid grid-cols-4 gap-2 text-center">
                    <div>
                      <p className="font-heading font-bold text-brand-green text-xl">{displayTargets.calories}</p>
                      <p className="text-brand-gray-muted text-xs mt-0.5">kcal</p>
                    </div>
                    <div>
                      <p className="font-heading font-bold text-brand-offwhite text-xl">{displayTargets.protein_g}g</p>
                      <p className="text-brand-gray-muted text-xs mt-0.5">protein</p>
                    </div>
                    <div>
                      <p className="font-heading font-bold text-brand-offwhite text-xl">{displayTargets.carbs_g}g</p>
                      <p className="text-brand-gray-muted text-xs mt-0.5">carbs</p>
                    </div>
                    <div>
                      <p className="font-heading font-bold text-brand-offwhite text-xl">{displayTargets.fats_g}g</p>
                      <p className="text-brand-gray-muted text-xs mt-0.5">fats</p>
                    </div>
                  </div>
                  {displayTargets.hydration_liters && (
                    <p className="text-brand-gray-muted text-xs text-center mt-3 border-t border-brand-gray-light pt-3">
                      Hydration: {displayTargets.hydration_liters}L / day
                    </p>
                  )}
                  {calculatedTargets && calculatedTargets.deficit_surplus !== 0 && (
                    <p className="text-brand-gray-muted text-xs text-center mt-1">
                      {calculatedTargets.deficit_surplus < 0
                        ? `${Math.abs(calculatedTargets.deficit_surplus)} kcal deficit · TDEE ${calculatedTargets.tdee}`
                        : `${calculatedTargets.deficit_surplus} kcal surplus · TDEE ${calculatedTargets.tdee}`}
                    </p>
                  )}
                </div>
              )}
            </div>
          </div>

          {/* Guidance from static plan */}
          {plan?.guidance && calculatedTargets?.guidance_mode !== 'behavioral' && (
            <div className="page-padding mb-4">
              <p className="text-brand-gray-muted text-sm italic leading-relaxed">&quot;{plan.guidance}&quot;</p>
            </div>
          )}

          {/* Meals */}
          {meals.length > 0 && (
            <div className="page-padding mb-4">
              <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-3">Meal Plan</p>
              <div className="flex flex-col gap-3">
                {meals.map((meal: {
                  id: string
                  meal_type: string
                  meal_name: string
                  calories: number | null
                  description: string | null
                  protein_g: number | null
                  carbs_g: number | null
                  fats_g: number | null
                }) => (
                  <div key={meal.id} className="bg-brand-gray rounded-2xl p-4">
                    <div className="flex items-start justify-between mb-1">
                      <div>
                        <p className="text-brand-gray-muted text-xs uppercase tracking-widest">
                          {MEAL_TYPE_LABELS[meal.meal_type] ?? meal.meal_type}
                        </p>
                        <p className="font-heading font-bold text-brand-offwhite text-base mt-0.5">
                          {meal.meal_name}
                        </p>
                      </div>
                      {meal.calories && (
                        <p className="font-heading font-bold text-brand-green text-sm flex-shrink-0 ml-3">
                          {meal.calories} kcal
                        </p>
                      )}
                    </div>
                    {meal.description && (
                      <p className="text-brand-gray-muted text-xs mt-1">{meal.description}</p>
                    )}
                    {(meal.protein_g || meal.carbs_g || meal.fats_g) && (
                      <div className="flex gap-3 mt-2 pt-2 border-t border-brand-gray-light">
                        {meal.protein_g ? <span className="text-brand-gray-muted text-xs">{meal.protein_g}g protein</span> : null}
                        {meal.carbs_g ? <span className="text-brand-gray-muted text-xs">{meal.carbs_g}g carbs</span> : null}
                        {meal.fats_g ? <span className="text-brand-gray-muted text-xs">{meal.fats_g}g fats</span> : null}
                      </div>
                    )}
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* Tips */}
          {tips.length > 0 && (
            <div className="page-padding mb-4">
              <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-3">Nutrition Tips</p>
              <div className="flex flex-col gap-2">
                {tips.map((tip: { id: string; tip: string }) => (
                  <div key={tip.id} className="bg-brand-gray rounded-2xl p-4 flex items-start gap-3">
                    <span className="text-brand-green text-sm flex-shrink-0 mt-0.5">→</span>
                    <p className="text-brand-offwhite text-sm">{tip.tip}</p>
                  </div>
                ))}
              </div>
            </div>
          )}
        </>
      ) : (
        <div className="page-padding">
          <div className="bg-brand-gray rounded-2xl p-6 text-center">
            <p className="font-heading font-bold text-brand-offwhite text-base mb-2">
              Nutrition Plan Coming Soon
            </p>
            <p className="text-brand-gray-muted text-sm">
              Macro targets and meal guidance for your archetype will appear here.
            </p>
            <a href="/profile-setup">
              <button type="button" className="mt-4 w-full border border-brand-green text-brand-green font-heading font-bold py-3 rounded-lg text-sm uppercase tracking-widest">
                Complete Profile for Personalized Targets
              </button>
            </a>
          </div>
        </div>
      )}

      <BottomNav active="nutrition" />
    </div>
  )
}
