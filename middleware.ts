import { createServerClient } from '@supabase/ssr'
import { NextResponse, type NextRequest } from 'next/server'

export async function middleware(request: NextRequest) {
  let supabaseResponse = NextResponse.next({ request })

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return request.cookies.getAll()
        },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value }) => request.cookies.set(name, value))
          supabaseResponse = NextResponse.next({ request })
          cookiesToSet.forEach(({ name, value, options }) =>
            supabaseResponse.cookies.set(name, value, options)
          )
        },
      },
    }
  )

  const { data: { user } } = await supabase.auth.getUser()

  const { pathname } = request.nextUrl

  // Public routes — no auth required
  const publicRoutes = ['/', '/login', '/signup']
  const isPublic = publicRoutes.includes(pathname) || pathname.startsWith('/auth')

  // Not logged in → redirect to login
  if (!user && !isPublic) {
    return NextResponse.redirect(new URL('/login', request.url))
  }

  // Logged in but not onboarded → redirect to onboarding
  if (user && !isPublic) {
    const { data: profile } = await supabase
      .from('users')
      .select('onboarding_complete')
      .eq('id', user.id)
      .single()

    const onboardingRoutes = ['/welcome', '/assessment', '/reveal', '/mode-select']
    const isOnboarding = onboardingRoutes.some(r => pathname.startsWith(r))

    if (profile && !profile.onboarding_complete && !isOnboarding) {
      return NextResponse.redirect(new URL('/welcome', request.url))
    }
  }

  // Logged in, trying to visit auth pages → redirect to dashboard
  if (user && (pathname === '/login' || pathname === '/signup')) {
    return NextResponse.redirect(new URL('/dashboard', request.url))
  }

  return supabaseResponse
}

export const config = {
  matcher: ['/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)'],
}
