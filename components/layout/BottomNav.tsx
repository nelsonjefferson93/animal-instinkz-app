import Link from 'next/link'

type NavItem = {
  id: string
  label: string
  href: string
  icon: string
}

const NAV_ITEMS: NavItem[] = [
  { id: 'home', label: 'Home', href: '/dashboard', icon: '⊞' },
  { id: 'train', label: 'Train', href: '/train', icon: '🏋' },
  { id: 'hundred', label: '100', href: '/hundred', icon: '💯' },
  { id: 'nutrition', label: 'Nutrition', href: '/nutrition', icon: '🥩' },
  { id: 'profile', label: 'Profile', href: '/profile', icon: '◎' },
]

export default function BottomNav({ active }: { active: string }) {
  return (
    <nav className="fixed bottom-0 left-1/2 -translate-x-1/2 w-full max-w-[480px] bg-brand-black border-t border-brand-gray safe-bottom">
      <div className="flex items-center justify-around py-2">
        {NAV_ITEMS.map(item => {
          const isActive = item.id === active
          return (
            <Link
              key={item.id}
              href={item.href}
              className={`flex flex-col items-center gap-1 px-3 py-2 min-w-[60px] ${
                isActive ? 'text-brand-green' : 'text-brand-gray-muted'
              }`}
            >
              <span className="text-xl">{item.icon}</span>
              <span className="text-[10px] uppercase tracking-widest font-heading">{item.label}</span>
            </Link>
          )
        })}
      </div>
    </nav>
  )
}
