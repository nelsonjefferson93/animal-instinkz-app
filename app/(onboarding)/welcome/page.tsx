import Link from 'next/link'

export default function WelcomePage() {
  return (
    <div className="flex flex-col min-h-dvh items-center justify-between py-16 page-padding text-center">
      <div />

      <div className="flex flex-col items-center gap-6">
        {/* Logo placeholder — replace with actual logo image */}
        <div className="w-24 h-24 rounded-full bg-brand-gray border-2 border-brand-green flex items-center justify-center">
          <span className="font-display text-3xl text-brand-green">AI</span>
        </div>

        <div>
          <h1 className="font-display text-6xl text-brand-offwhite leading-none tracking-wider mb-3">
            UNLOCK YOUR<br />INSTINCT.
          </h1>
          <p className="text-brand-gray-muted text-base max-w-xs mx-auto">
            Find your animal archetype. Train with full effort.
          </p>
        </div>
      </div>

      <div className="w-full">
        <Link href="/assessment">
          <button className="w-full bg-brand-green text-white font-heading font-bold py-5 rounded-lg text-lg uppercase tracking-widest active:bg-brand-green-light transition-colors">
            Begin
          </button>
        </Link>
        <p className="text-brand-gray-muted text-xs mt-4">
          5 questions. 2 minutes. Life-changing clarity.
        </p>
      </div>
    </div>
  )
}
