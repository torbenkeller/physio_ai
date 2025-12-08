import { NavLink } from 'react-router-dom'
import { cn } from '@/shared/utils'
import { Sheet, SheetContent, SheetHeader, SheetTitle } from '@/shared/components/ui/sheet'
import { NAV_ITEMS, FOOTER_NAV_ITEMS, type NavItemConfig } from './navigationConfig'

interface MobileSheetProps {
  open: boolean
  onOpenChange: (open: boolean) => void
}

interface SheetNavItemProps {
  item: NavItemConfig
  onNavigate: () => void
}

const SheetNavItem = ({ item, onNavigate }: SheetNavItemProps) => (
  <NavLink
    to={item.to}
    onClick={onNavigate}
    className={({ isActive }) =>
      cn(
        'flex items-center gap-3 rounded-lg px-3 py-3 text-base font-medium transition-colors',
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

export const MobileSheet = ({ open, onOpenChange }: MobileSheetProps) => {
  const handleNavigate = () => {
    onOpenChange(false)
  }

  return (
    <Sheet open={open} onOpenChange={onOpenChange}>
      <SheetContent side="left" className="w-72 p-0">
        <SheetHeader className="border-b px-6 py-4">
          <SheetTitle className="text-left text-primary">PhysioAI</SheetTitle>
        </SheetHeader>

        <nav className="flex-1 space-y-1 p-4">
          {NAV_ITEMS.map((item) => (
            <SheetNavItem key={item.to} item={item} onNavigate={handleNavigate} />
          ))}
        </nav>

        <div className="border-t p-4">
          {FOOTER_NAV_ITEMS.map((item) => (
            <SheetNavItem key={item.to} item={item} onNavigate={handleNavigate} />
          ))}
        </div>
      </SheetContent>
    </Sheet>
  )
}
