import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { computeWeeklyProgress, runAdaptation, getWeekStart } from '@/lib/adaptation/engine'

export async function POST(request: NextRequest) {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })

  const weekStart = getWeekStart()

  const { data: profile } = await supabase
    .from('users')
    .select('*')
    .eq('id', user.id)
    .single()

  if (!profile) return NextResponse.json({ event: null })

  const progressLog = await computeWeeklyProgress(user.id, weekStart)
  if (!progressLog) return NextResponse.json({ event: null })

  const event = await runAdaptation(user.id, progressLog, profile)
  return NextResponse.json({ event })
}
