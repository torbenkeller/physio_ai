import { NavLink } from 'react-router-dom'
import { cn } from '@/shared/utils'
import { Tooltip, TooltipContent, TooltipTrigger } from '@/shared/components/ui/tooltip'
import { NAV_ITEMS, FOOTER_NAV_ITEMS, type NavItemConfig } from './navigationConfig'

interface RailNavItemProps {
  item: NavItemConfig
}

const RailNavItem = ({ item }: RailNavItemProps) => (
  <Tooltip delayDuration={0}>
    <TooltipTrigger asChild>
      <NavLink
        to={item.to}
        className={({ isActive }) =>
          cn(
            'flex h-12 w-12 items-center justify-center rounded-lg transition-colors',
            isActive
              ? 'bg-primary text-primary-foreground'
              : 'text-muted-foreground hover:bg-accent hover:text-accent-foreground'
          )
        }
      >
        <item.icon className="h-5 w-5" />
        <span className="sr-only">{item.label}</span>
      </NavLink>
    </TooltipTrigger>
    <TooltipContent side="right" sideOffset={8}>
      {item.label}
    </TooltipContent>
  </Tooltip>
)

export const NavigationRail = () => {
  return (
    <aside className="hidden sm:flex lg:hidden h-screen w-16 flex-col items-center border-r bg-card py-4">
      {/* Logo (kompakt) */}
      <div className="flex h-12 w-12 items-center justify-center mb-4">
        <span className="text-lg font-bold text-primary">P</span>
      </div>

      {/* Haupt-Navigation */}
      <nav className="flex-1 flex flex-col items-center gap-2">
        {NAV_ITEMS.map((item) => (
          <RailNavItem key={item.to} item={item} />
        ))}
      </nav>

      {/* Footer-Navigation */}
      <div className="flex flex-col items-center gap-2 border-t pt-4">
        {FOOTER_NAV_ITEMS.map((item) => (
          <RailNavItem key={item.to} item={item} />
        ))}
      </div>
    </aside>
  )
}
