import { NavLink } from 'react-router-dom'
import { cn } from '@/shared/utils'
import { NAV_ITEMS, FOOTER_NAV_ITEMS, type NavItemConfig } from './navigationConfig'

interface DrawerNavItemProps {
  item: NavItemConfig
}

const DrawerNavItem = ({ item }: DrawerNavItemProps) => (
  <NavLink
    to={item.to}
    className={({ isActive }) =>
      cn(
        'flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium transition-colors',
        isActive
          ? 'bg-primary text-primary-foreground'
          : 'text-muted-foreground hover:bg-accent hover:text-accent-foreground'
      )
    }
  >
    <item.icon className="h-5 w-5 shrink-0" />
    <span>{item.label}</span>
  </NavLink>
)

export const NavigationDrawer = () => {
  return (
    <aside className="hidden lg:flex h-screen w-64 flex-col border-r bg-card">
      {/* Logo */}
      <div className="flex h-16 items-center border-b px-6">
        <h1 className="text-xl font-bold text-primary">PhysioAI</h1>
      </div>

      {/* Haupt-Navigation */}
      <nav className="flex-1 space-y-1 p-4">
        {NAV_ITEMS.map((item) => (
          <DrawerNavItem key={item.to} item={item} />
        ))}
      </nav>

      {/* Footer-Navigation */}
      <div className="border-t p-4">
        {FOOTER_NAV_ITEMS.map((item) => (
          <DrawerNavItem key={item.to} item={item} />
        ))}
      </div>
    </aside>
  )
}
