import { NextResponse, type NextRequest } from 'next/server'

export function middleware(request: NextRequest) {
  return NextResponse.next()
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
