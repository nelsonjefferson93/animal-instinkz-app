import type { Metadata, Viewport } from 'next'
import { Bebas_Neue, Oswald, Inter } from 'next/font/google'
import './globals.css'

const bebasNeue = Bebas_Neue({
  weight: '400',
  subsets: ['latin'],
  variable: '--font-bebas',
  display: 'swap',
})

const oswald = Oswald({
  weight: ['600', '700'],
  subsets: ['latin'],
  variable: '--font-oswald',
  display: 'swap',
})

const inter = Inter({
  subsets: ['latin'],
  variable: '--font-inter',
  display: 'swap',
})

export const metadata: Metadata = {
  title: 'Animal Instinkz',
  description: 'Unlock your instinct. Find your animal archetype. Train with full effort.',
  manifest: '/manifest.json',
  appleWebApp: {
    capable: true,
    statusBarStyle: 'black-translucent',
    title: 'Animal Instinkz',
  },
}

export const viewport: Viewport = {
  themeColor: '#0D0D0D',
  width: 'device-width',
  initialScale: 1,
  maximumScale: 1,
  userScalable: false,
}

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en" className={`${bebasNeue.variable} ${oswald.variable} ${inter.variable}`}>
      <body>{children}</body>
    </html>
  )
}
