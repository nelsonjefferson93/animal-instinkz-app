'use client'

import { useState } from 'react'
import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'

export default function LoginPage() {
  const router = useRouter()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  async function handleLogin(e: React.FormEvent) {
    e.preventDefault()
    setLoading(true)
    setError(null)

    const supabase = createClient()

    const { error: signInError } = await supabase.auth.signInWithPassword({
      email,
      password,
    })

    if (signInError) {
      setError('Invalid email or password.')
      setLoading(false)
      return
    }

    router.push('/dashboard')
  }

  return (
    <div className="flex flex-col min-h-dvh page-padding justify-center py-12">
      <div className="mb-10">
        <h1 className="font-display text-5xl text-brand-offwhite mb-2">
          WELCOME BACK
        </h1>
        <p className="text-brand-gray-muted text-sm">
          Your instinct is waiting.
        </p>
      </div>

      <form onSubmit={handleLogin} className="flex flex-col gap-4">
        <div>
          <label className="block text-xs text-brand-gray-muted uppercase tracking-widest mb-2">
            Email
          </label>
          <input
            type="email"
            value={email}
            onChange={e => setEmail(e.target.value)}
            required
            placeholder="you@example.com"
            className="w-full bg-brand-gray border border-brand-gray-light rounded-lg px-4 py-3 text-brand-offwhite placeholder-brand-gray-muted focus:outline-none focus:border-brand-green text-sm"
          />
        </div>

        <div>
          <label className="block text-xs text-brand-gray-muted uppercase tracking-widest mb-2">
            Password
          </label>
          <input
            type="password"
            value={password}
            onChange={e => setPassword(e.target.value)}
            required
            placeholder="Your password"
            className="w-full bg-brand-gray border border-brand-gray-light rounded-lg px-4 py-3 text-brand-offwhite placeholder-brand-gray-muted focus:outline-none focus:border-brand-green text-sm"
          />
        </div>

        {error && (
          <p className="text-red-400 text-sm">{error}</p>
        )}

        <button
          type="submit"
          disabled={loading}
          className="w-full bg-brand-green text-white font-heading font-bold py-4 rounded-lg text-base uppercase tracking-wide mt-2 disabled:opacity-50 active:bg-brand-green-light transition-colors"
        >
          {loading ? 'Signing In...' : 'Sign In'}
        </button>
      </form>

      <p className="text-center text-brand-gray-muted text-sm mt-8">
        No account?{' '}
        <Link href="/signup" className="text-brand-green">
          Create one
        </Link>
      </p>
    </div>
  )
}
