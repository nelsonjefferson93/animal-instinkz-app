import { NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { assignHabits } from '@/lib/habits/assign'
import type { ArchetypeId } from '@/types/database'

export async function POST() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })

  const [profileRes, archetypeRes] = await Promise.all([
    supabase.from('users').select('*').eq('id', user.id).single(),
    supabase.from('user_archetypes').select('primary_archetype').eq('user_id', user.id).eq('is_active', true).single(),
  ])

  if (!profileRes.data) return NextResponse.json({ error: 'Profile not found' }, { status: 404 })

  const archetypeId = (archetypeRes.data?.primary_archetype ?? 'wolf') as ArchetypeId
  await assignHabits(user.id, profileRes.data, archetypeId)

  return NextResponse.json({ ok: true })
}
