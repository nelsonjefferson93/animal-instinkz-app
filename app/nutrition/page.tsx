import BottomNav from '@/components/layout/BottomNav'

export default function NutritionPage() {
  return (
    <div className="flex flex-col min-h-dvh bg-brand-black pb-24">
      <div className="page-padding pt-10 pb-4">
        <h1 className="font-display text-5xl text-brand-offwhite">NUTRITION</h1>
        <p className="text-brand-gray-muted text-sm mt-1">Coming in Phase 1.</p>
      </div>
      <div className="page-padding">
        <div className="bg-brand-gray rounded-2xl p-6 text-center">
          <p className="font-heading font-bold text-brand-offwhite text-base mb-2">
            Archetype Nutrition Plans
          </p>
          <p className="text-brand-gray-muted text-sm">
            Macro targets and meal guidance tailored to your animal will be available here.
          </p>
        </div>
      </div>
      <BottomNav active="nutrition" />
    </div>
  )
}
