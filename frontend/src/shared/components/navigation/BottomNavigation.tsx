import { NavLink } from 'react-router-dom'
import { cn } from '@/shared/utils'
import { MOBILE_NAV_ITEMS } from './navigationConfig'

export const BottomNavigation = () => {
  return (
    <nav className="flex sm:hidden fixed bottom-0 left-0 right-0 h-16 items-center justify-around border-t bg-card px-2 z-50">
      {MOBILE_NAV_ITEMS.map((item) => (
        <NavLink
          key={item.to}
          to={item.to}
          className={({ isActive }) =>
            cn(
              'flex flex-col items-center justify-center gap-1 px-3 py-2 rounded-lg min-w-[64px] transition-colors',
              isActive ? 'text-primary' : 'text-muted-foreground hover:text-accent-foreground'
            )
          }
        >
          <item.icon className="h-5 w-5" />
          <span className="text-xs font-medium truncate">{item.label}</span>
        </NavLink>
      ))}
    </nav>
  )
}
