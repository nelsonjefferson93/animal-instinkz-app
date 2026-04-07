'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'
import { assignHabits } from '@/lib/habits/assign'
import type { ArchetypeId } from '@/types/database'

type Screen = 1 | 2 | 3

interface ProfileForm {
  // Screen 1 — Body
  height_ft: string
  height_in: string
  current_weight_lbs: string
  target_weight_lbs: string
  body_build: 'lean' | 'average' | 'high_fat' | ''
  fat_distribution: 'central' | 'lower' | 'balanced' | ''
  // Screen 2 — Training
  training_experience: 'beginner' | 'intermediate' | 'advanced' | ''
  workout_environment: 'gym' | 'home' | ''
  equipment_level: 'full_gym' | 'dumbbells' | 'bands' | 'bodyweight' | ''
  workout_days_per_week: string
  session_length_minutes: string
  // Screen 3 — Nutrition & Lifestyle
  nutrition_preference: 'balanced' | 'high_protein' | 'low_carb' | 'fasting' | ''
  activity_level: 'sedentary' | 'light' | 'moderate' | 'active' | 'very_active' | ''
  sleep_hours_avg: string
  stress_level: 'low' | 'moderate' | 'high' | ''
  dietary_restrictions: string[]
  food_allergies: string
  disliked_foods: string
}

const INITIAL_FORM: ProfileForm = {
  height_ft: '', height_in: '0',
  current_weight_lbs: '', target_weight_lbs: '',
  body_build: '', fat_distribution: '',
  training_experience: '', workout_environment: '',
  equipment_level: '', workout_days_per_week: '4',
  session_length_minutes: '60',
  nutrition_preference: '', activity_level: '',
  sleep_hours_avg: '7', stress_level: '',
  dietary_restrictions: [],
  food_allergies: '', disliked_foods: '',
}

const DIETARY_OPTIONS = [
  'vegetarian', 'vegan', 'halal', 'kosher',
  'dairy_free', 'gluten_free', 'nut_free',
]

const SESSION_OPTIONS = [
  { value: '30', label: '30 min' },
  { value: '45', label: '45 min' },
  { value: '60', label: '60 min' },
  { value: '75', label: '75 min' },
  { value: '90', label: '90+ min' },
]

function CardButton<T extends string>({
  value, selected, onClick, label, sublabel,
}: { value: T; selected: boolean; onClick: (v: T) => void; label: string; sublabel?: string }) {
  return (
    <button
      type="button"
      onClick={() => onClick(value)}
      className={`w-full rounded-lg px-4 py-3 text-left border transition-all ${
        selected ? 'bg-brand-green border-brand-green' : 'bg-brand-gray border-brand-gray-light'
      }`}
    >
      <p className="font-heading font-bold text-brand-offwhite text-sm">{label}</p>
      {sublabel && <p className="text-brand-gray-muted text-xs mt-0.5">{sublabel}</p>}
    </button>
  )
}

export default function ProfileSetupPage() {
  const router = useRouter()
  const [screen, setScreen] = useState<Screen>(1)
  const [form, setForm] = useState<ProfileForm>(INITIAL_FORM)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  function set<K extends keyof ProfileForm>(key: K, value: ProfileForm[K]) {
    setForm(prev => ({ ...prev, [key]: value }))
  }

  function toggleRestriction(r: string) {
    set('dietary_restrictions',
      form.dietary_restrictions.includes(r)
        ? form.dietary_restrictions.filter(x => x !== r)
        : [...form.dietary_restrictions, r]
    )
  }

  async function handleSubmit() {
    setLoading(true)
    setError(null)
    const supabase = createClient()
    const { data: { user } } = await supabase.auth.getUser()
    if (!user) { router.push('/login'); return }

    const heightInches = parseInt(form.height_ft || '0') * 12 + parseInt(form.height_in || '0')

    // Fetch archetype for habit assignment
    const { data: archetypeRow } = await supabase
      .from('user_archetypes')
      .select('primary_archetype')
      .eq('user_id', user.id)
      .eq('is_active', true)
      .single()
    const archetypeId = (archetypeRow?.primary_archetype ?? 'wolf') as ArchetypeId

    const profileData = {
      height_inches:           heightInches > 0 ? heightInches : null,
      current_weight_lbs:      form.current_weight_lbs ? parseFloat(form.current_weight_lbs) : null,
      target_weight_lbs:       form.target_weight_lbs ? parseFloat(form.target_weight_lbs) : null,
      body_build:               form.body_build || null,
      fat_distribution:         form.fat_distribution || null,
      training_experience:      form.training_experience || null,
      workout_environment:      form.workout_environment || 'gym',
      equipment_level:          form.equipment_level || 'full_gym',
      workout_days_per_week:    parseInt(form.workout_days_per_week) || 4,
      session_length_minutes:   parseInt(form.session_length_minutes) || 60,
      nutrition_preference:     form.nutrition_preference || null,
      activity_level:           form.activity_level || null,
      sleep_hours_avg:          form.sleep_hours_avg ? parseFloat(form.sleep_hours_avg) : null,
      stress_level:             form.stress_level || null,
      dietary_restrictions:     form.dietary_restrictions,
      food_allergies:           form.food_allergies ? form.food_allergies.split(',').map(s => s.trim()).filter(Boolean) : [],
      disliked_foods:           form.disliked_foods ? form.disliked_foods.split(',').map(s => s.trim()).filter(Boolean) : [],
      profile_complete:         true,
    }

    const { error: updateErr } = await supabase
      .from('users')
      .update(profileData)
      .eq('id', user.id)

    if (updateErr) {
      setError('Something went wrong saving your profile. Please try again.')
      setLoading(false)
      return
    }

    // Assign habits based on profile signals
    await assignHabits(user.id, { ...profileData, training_mode: undefined }, archetypeId)

    router.push('/dashboard')
  }

  return (
    <div className="flex flex-col min-h-dvh page-padding pt-10 pb-8">
      {/* Progress indicator */}
      <div className="flex gap-2 mb-8">
        {([1, 2, 3] as Screen[]).map(s => (
          <div
            key={s}
            className={`h-1 flex-1 rounded-full transition-all ${s <= screen ? 'bg-brand-green' : 'bg-brand-gray-light'}`}
          />
        ))}
      </div>

      {/* ─── SCREEN 1: BODY ─── */}
      {screen === 1 && (
        <div className="flex flex-col gap-6 flex-1">
          <div>
            <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-1">Step 1 of 3</p>
            <h1 className="font-display text-4xl text-brand-offwhite leading-none">YOUR BODY</h1>
            <p className="text-brand-gray-muted text-sm mt-1">Used to calculate your nutrition targets and training load.</p>
          </div>

          {/* Height */}
          <div>
            <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-2">Height</p>
            <div className="flex gap-3">
              <div className="flex-1">
                <input
                  type="number" inputMode="numeric" placeholder="5" min="4" max="7"
                  value={form.height_ft}
                  onChange={e => set('height_ft', e.target.value)}
                  className="w-full bg-brand-gray border border-brand-gray-light rounded-lg px-4 py-3 text-brand-offwhite placeholder-brand-gray-muted text-sm"
                />
                <p className="text-brand-gray-muted text-xs mt-1 text-center">ft</p>
              </div>
              <div className="flex-1">
                <input
                  type="number" inputMode="numeric" placeholder="10" min="0" max="11"
                  value={form.height_in}
                  onChange={e => set('height_in', e.target.value)}
                  className="w-full bg-brand-gray border border-brand-gray-light rounded-lg px-4 py-3 text-brand-offwhite placeholder-brand-gray-muted text-sm"
                />
                <p className="text-brand-gray-muted text-xs mt-1 text-center">in</p>
              </div>
            </div>
          </div>

          {/* Weight */}
          <div className="flex gap-3">
            <div className="flex-1">
              <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-2">Current Weight</p>
              <input
                type="number" inputMode="decimal" placeholder="185"
                value={form.current_weight_lbs}
                onChange={e => set('current_weight_lbs', e.target.value)}
                className="w-full bg-brand-gray border border-brand-gray-light rounded-lg px-4 py-3 text-brand-offwhite placeholder-brand-gray-muted text-sm"
              />
              <p className="text-brand-gray-muted text-xs mt-1 text-center">lbs</p>
            </div>
            <div className="flex-1">
              <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-2">Target Weight</p>
              <input
                type="number" inputMode="decimal" placeholder="175"
                value={form.target_weight_lbs}
                onChange={e => set('target_weight_lbs', e.target.value)}
                className="w-full bg-brand-gray border border-brand-gray-light rounded-lg px-4 py-3 text-brand-offwhite placeholder-brand-gray-muted text-sm"
              />
              <p className="text-brand-gray-muted text-xs mt-1 text-center">lbs</p>
            </div>
          </div>

          {/* Body Build */}
          <div>
            <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-2">Body Build</p>
            <div className="flex flex-col gap-2">
              <CardButton value="lean" selected={form.body_build === 'lean'} onClick={v => set('body_build', v)} label="Lean" sublabel="Naturally lean, struggle to gain weight" />
              <CardButton value="average" selected={form.body_build === 'average'} onClick={v => set('body_build', v)} label="Average" sublabel="Moderate build, gain and lose with moderate effort" />
              <CardButton value="high_fat" selected={form.body_build === 'high_fat'} onClick={v => set('body_build', v)} label="Higher Body Fat" sublabel="Tend to carry more fat, harder to lose" />
            </div>
          </div>

          {/* Fat Distribution */}
          <div>
            <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-2">Where Do You Carry Fat?</p>
            <div className="flex flex-col gap-2">
              <CardButton value="central" selected={form.fat_distribution === 'central'} onClick={v => set('fat_distribution', v)} label="Central (belly/torso)" sublabel="Most fat around the midsection" />
              <CardButton value="lower" selected={form.fat_distribution === 'lower'} onClick={v => set('fat_distribution', v)} label="Lower body (hips/thighs)" sublabel="Most fat in hips, glutes, thighs" />
              <CardButton value="balanced" selected={form.fat_distribution === 'balanced'} onClick={v => set('fat_distribution', v)} label="Balanced" sublabel="Distributed fairly evenly" />
            </div>
          </div>

          <button
            onClick={() => setScreen(2)}
            className="w-full bg-brand-green text-white font-heading font-bold py-5 rounded-lg text-base uppercase tracking-widest mt-auto disabled:opacity-40 active:bg-brand-green-light transition-colors"
          >
            Next
          </button>
        </div>
      )}

      {/* ─── SCREEN 2: TRAINING ─── */}
      {screen === 2 && (
        <div className="flex flex-col gap-6 flex-1">
          <div>
            <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-1">Step 2 of 3</p>
            <h1 className="font-display text-4xl text-brand-offwhite leading-none">YOUR TRAINING</h1>
            <p className="text-brand-gray-muted text-sm mt-1">Used to build your workout program.</p>
          </div>

          {/* Experience */}
          <div>
            <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-2">Training Experience</p>
            <div className="flex flex-col gap-2">
              <CardButton value="beginner" selected={form.training_experience === 'beginner'} onClick={v => set('training_experience', v)} label="Beginner" sublabel="Less than 1 year of consistent training" />
              <CardButton value="intermediate" selected={form.training_experience === 'intermediate'} onClick={v => set('training_experience', v)} label="Intermediate" sublabel="1–3 years of consistent training" />
              <CardButton value="advanced" selected={form.training_experience === 'advanced'} onClick={v => set('training_experience', v)} label="Advanced" sublabel="3+ years of structured training" />
            </div>
          </div>

          {/* Environment */}
          <div>
            <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-2">Where Do You Train?</p>
            <div className="flex gap-3">
              <button
                type="button"
                onClick={() => { set('workout_environment', 'gym'); set('equipment_level', 'full_gym') }}
                className={`flex-1 rounded-lg px-4 py-4 text-center border transition-all ${form.workout_environment === 'gym' ? 'bg-brand-green border-brand-green' : 'bg-brand-gray border-brand-gray-light'}`}
              >
                <p className="text-2xl mb-1">🏋️</p>
                <p className="font-heading font-bold text-brand-offwhite text-sm">Gym</p>
              </button>
              <button
                type="button"
                onClick={() => { set('workout_environment', 'home'); set('equipment_level', 'bodyweight') }}
                className={`flex-1 rounded-lg px-4 py-4 text-center border transition-all ${form.workout_environment === 'home' ? 'bg-brand-green border-brand-green' : 'bg-brand-gray border-brand-gray-light'}`}
              >
                <p className="text-2xl mb-1">🏠</p>
                <p className="font-heading font-bold text-brand-offwhite text-sm">Home</p>
              </button>
            </div>
          </div>

          {/* Equipment (only shown for home) */}
          {form.workout_environment === 'home' && (
            <div>
              <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-2">Available Equipment</p>
              <div className="flex flex-col gap-2">
                <CardButton value="bodyweight" selected={form.equipment_level === 'bodyweight'} onClick={v => set('equipment_level', v)} label="Bodyweight Only" />
                <CardButton value="bands" selected={form.equipment_level === 'bands'} onClick={v => set('equipment_level', v)} label="Resistance Bands" />
                <CardButton value="dumbbells" selected={form.equipment_level === 'dumbbells'} onClick={v => set('equipment_level', v)} label="Dumbbells + Bodyweight" />
              </div>
            </div>
          )}

          {/* Days per week */}
          <div>
            <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-2">
              Training Days / Week: <span className="text-brand-green">{form.workout_days_per_week}</span>
            </p>
            <input
              type="range" min={2} max={7} step={1}
              value={form.workout_days_per_week}
              onChange={e => set('workout_days_per_week', e.target.value)}
              className="w-full accent-brand-green"
            />
            <div className="flex justify-between text-brand-gray-muted text-xs mt-1">
              <span>2 days</span><span>7 days</span>
            </div>
          </div>

          {/* Session length */}
          <div>
            <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-2">Session Length</p>
            <div className="flex gap-2 flex-wrap">
              {SESSION_OPTIONS.map(opt => (
                <button
                  key={opt.value} type="button"
                  onClick={() => set('session_length_minutes', opt.value)}
                  className={`px-4 py-2 rounded-lg border text-sm font-heading font-bold transition-all ${
                    form.session_length_minutes === opt.value ? 'bg-brand-green border-brand-green text-white' : 'bg-brand-gray border-brand-gray-light text-brand-offwhite'
                  }`}
                >
                  {opt.label}
                </button>
              ))}
            </div>
          </div>

          <div className="flex gap-3 mt-auto">
            <button onClick={() => setScreen(1)} className="flex-1 border border-brand-gray-light text-brand-offwhite font-heading font-bold py-4 rounded-lg text-sm uppercase tracking-widest">
              Back
            </button>
            <button onClick={() => setScreen(3)} className="flex-1 bg-brand-green text-white font-heading font-bold py-4 rounded-lg text-sm uppercase tracking-widest active:bg-brand-green-light transition-colors">
              Next
            </button>
          </div>
        </div>
      )}

      {/* ─── SCREEN 3: NUTRITION & LIFESTYLE ─── */}
      {screen === 3 && (
        <div className="flex flex-col gap-6 flex-1">
          <div>
            <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-1">Step 3 of 3</p>
            <h1 className="font-display text-4xl text-brand-offwhite leading-none">NUTRITION &amp; LIFE</h1>
            <p className="text-brand-gray-muted text-sm mt-1">Used to personalize your nutrition targets and habits.</p>
          </div>

          {/* Nutrition preference */}
          <div>
            <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-2">Eating Style</p>
            <div className="flex flex-col gap-2">
              <CardButton value="balanced" selected={form.nutrition_preference === 'balanced'} onClick={v => set('nutrition_preference', v)} label="Balanced" sublabel="No strong preference — healthy, whole foods" />
              <CardButton value="high_protein" selected={form.nutrition_preference === 'high_protein'} onClick={v => set('nutrition_preference', v)} label="High Protein" sublabel="Lean meats, eggs, protein-first meals" />
              <CardButton value="low_carb" selected={form.nutrition_preference === 'low_carb'} onClick={v => set('nutrition_preference', v)} label="Low Carb / Keto" sublabel="Minimize carbs, higher fat intake" />
              <CardButton value="fasting" selected={form.nutrition_preference === 'fasting'} onClick={v => set('nutrition_preference', v)} label="Intermittent Fasting" sublabel="Compressed eating window" />
            </div>
          </div>

          {/* Activity level */}
          <div>
            <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-2">Activity Level (Outside Gym)</p>
            <div className="flex flex-col gap-2">
              <CardButton value="sedentary" selected={form.activity_level === 'sedentary'} onClick={v => set('activity_level', v)} label="Sedentary" sublabel="Desk job, minimal daily movement" />
              <CardButton value="light" selected={form.activity_level === 'light'} onClick={v => set('activity_level', v)} label="Light" sublabel="Some walking, light daily activity" />
              <CardButton value="moderate" selected={form.activity_level === 'moderate'} onClick={v => set('activity_level', v)} label="Moderate" sublabel="Active job or regular daily movement" />
              <CardButton value="active" selected={form.activity_level === 'active'} onClick={v => set('activity_level', v)} label="Active" sublabel="Physical job or very high daily activity" />
            </div>
          </div>

          {/* Sleep */}
          <div>
            <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-2">
              Avg Sleep: <span className="text-brand-green">{form.sleep_hours_avg} hrs</span>
            </p>
            <input
              type="range" min={4} max={10} step={0.5}
              value={form.sleep_hours_avg}
              onChange={e => set('sleep_hours_avg', e.target.value)}
              className="w-full accent-brand-green"
            />
            <div className="flex justify-between text-brand-gray-muted text-xs mt-1">
              <span>4 hrs</span><span>10 hrs</span>
            </div>
          </div>

          {/* Stress level */}
          <div>
            <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-2">Current Stress Level</p>
            <div className="flex gap-3">
              {(['low','moderate','high'] as const).map(s => (
                <button
                  key={s} type="button"
                  onClick={() => set('stress_level', s)}
                  className={`flex-1 rounded-lg px-3 py-3 border text-sm font-heading font-bold capitalize transition-all ${
                    form.stress_level === s ? 'bg-brand-green border-brand-green text-white' : 'bg-brand-gray border-brand-gray-light text-brand-offwhite'
                  }`}
                >
                  {s}
                </button>
              ))}
            </div>
          </div>

          {/* Dietary restrictions */}
          <div>
            <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-2">Dietary Restrictions</p>
            <div className="flex flex-wrap gap-2">
              {DIETARY_OPTIONS.map(r => (
                <button
                  key={r} type="button"
                  onClick={() => toggleRestriction(r)}
                  className={`px-3 py-1.5 rounded-full border text-xs font-heading font-bold capitalize transition-all ${
                    form.dietary_restrictions.includes(r) ? 'bg-brand-green border-brand-green text-white' : 'bg-brand-gray border-brand-gray-light text-brand-gray-muted'
                  }`}
                >
                  {r.replace('_', ' ')}
                </button>
              ))}
            </div>
          </div>

          {/* Allergies + dislikes */}
          <div className="flex flex-col gap-3">
            <div>
              <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-1">Food Allergies</p>
              <input
                type="text" placeholder="e.g. peanuts, shellfish"
                value={form.food_allergies}
                onChange={e => set('food_allergies', e.target.value)}
                className="w-full bg-brand-gray border border-brand-gray-light rounded-lg px-4 py-3 text-brand-offwhite placeholder-brand-gray-muted text-sm"
              />
            </div>
            <div>
              <p className="text-brand-gray-muted text-xs uppercase tracking-widest mb-1">Foods You Dislike</p>
              <input
                type="text" placeholder="e.g. fish, broccoli"
                value={form.disliked_foods}
                onChange={e => set('disliked_foods', e.target.value)}
                className="w-full bg-brand-gray border border-brand-gray-light rounded-lg px-4 py-3 text-brand-offwhite placeholder-brand-gray-muted text-sm"
              />
            </div>
          </div>

          {error && <p className="text-red-400 text-sm">{error}</p>}

          <div className="flex gap-3 mt-auto">
            <button onClick={() => setScreen(2)} className="flex-1 border border-brand-gray-light text-brand-offwhite font-heading font-bold py-4 rounded-lg text-sm uppercase tracking-widest">
              Back
            </button>
            <button
              onClick={handleSubmit}
              disabled={loading}
              className="flex-1 bg-brand-green text-white font-heading font-bold py-4 rounded-lg text-sm uppercase tracking-widest active:bg-brand-green-light transition-colors disabled:opacity-40"
            >
              {loading ? 'Saving...' : 'Build My Plan'}
            </button>
          </div>
        </div>
      )}
    </div>
  )
}
