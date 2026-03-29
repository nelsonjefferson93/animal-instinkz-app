import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import { ARCHETYPES } from '@/lib/archetype/profiles'
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
    supabase.from('users').select('training_mode').eq('id', user.id).single(),
  ])

  const archetypeId = archetypeRes.data?.primary_archetype?.toLowerCase() ?? 'lion'
  const goal = profileRes.data?.training_mode ?? 'fat_loss'
  const archetype = ARCHETYPES[archetypeId as keyof typeof ARCHETYPES] ?? null

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

  const meals = mealsRes.data ?? []
  const tips = tipsRes.data ?? []

  return (
    <div className="flex flex-col min-h-dvh bg-brand-black pb-24">
      <div className="page-padding pt-10 pb-4">
        <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-1">
          {archetype ? `${archetype.display_name} Plan` : 'Your Plan'}
        </p>
        <h1 className="font-display text-5xl text-brand-offwhite">NUTRITION</h1>
        <p className="text-brand-gray-muted text-sm mt-1">
          {goal.replace('_', ' ').toUpperCase()}
        </p>
      </div>

      {plan ? (
        <>
          {/* Daily macro targets */}
          <div className="page-padding mb-4">
            <div className="bg-brand-gray rounded-2xl p-5">
              <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-3">Daily Targets</p>
              <div className="grid grid-cols-4 gap-2 text-center">
                <div>
                  <p className="font-heading font-bold text-brand-green text-xl">{plan.calories}</p>
                  <p className="text-brand-gray-muted text-xs mt-0.5">kcal</p>
                </div>
                <div>
                  <p className="font-heading font-bold text-brand-offwhite text-xl">{plan.protein_g}g</p>
                  <p className="text-brand-gray-muted text-xs mt-0.5">protein</p>
                </div>
                <div>
                  <p className="font-heading font-bold text-brand-offwhite text-xl">{plan.carbs_g}g</p>
                  <p className="text-brand-gray-muted text-xs mt-0.5">carbs</p>
                </div>
                <div>
                  <p className="font-heading font-bold text-brand-offwhite text-xl">{plan.fats_g}g</p>
                  <p className="text-brand-gray-muted text-xs mt-0.5">fats</p>
                </div>
              </div>
              {plan.hydration_liters && (
                <p className="text-brand-gray-muted text-xs text-center mt-3 border-t border-brand-gray-light pt-3">
                  Hydration: {plan.hydration_liters}L / day
                </p>
              )}
            </div>
          </div>

          {/* Guidance */}
          {plan.guidance && (
            <div className="page-padding mb-4">
              <p className="text-brand-gray-muted text-sm italic leading-relaxed">"{plan.guidance}"</p>
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
          </div>
        </div>
      )}

      <BottomNav active="nutrition" />
    </div>
  )
}
