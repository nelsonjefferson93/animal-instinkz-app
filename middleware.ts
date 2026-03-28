import { updateSession } from '@/lib/supabase/middleware'
import type { NextRequest } from 'next/server'

export async function middleware(request: NextRequest) {
  return await updateSession(request)
}

export const config = {
  matcher: [
    '/dashboard/:path*',
    '/train/:path*',
    '/profile/:path*',
    '/hundred/:path*',
    '/nutrition/:path*',
    '/welcome/:path*',
    '/assessment/:path*',
    '/reveal/:path*',
    '/mode-select/:path*',
  ],
}
