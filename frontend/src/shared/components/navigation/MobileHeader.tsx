import { Link } from 'react-router-dom'
import { Menu, User } from 'lucide-react'
import { Button } from '@/shared/components/ui/button'

interface MobileHeaderProps {
  onMenuClick: () => void
}

export const MobileHeader = ({ onMenuClick }: MobileHeaderProps) => {
  return (
    <header className="flex sm:hidden h-14 items-center justify-between border-b bg-card px-4">
      {/* Hamburger Menu */}
      <Button variant="ghost" size="icon" onClick={onMenuClick} aria-label="Menü öffnen">
        <Menu className="h-5 w-5" />
      </Button>

      {/* Logo */}
      <h1 className="text-lg font-bold text-primary">PhysioAI</h1>

      {/* Avatar/Profil Button */}
      <Button variant="ghost" size="icon" asChild aria-label="Profil öffnen">
        <Link to="/profil">
          <User className="h-5 w-5" />
        </Link>
      </Button>
    </header>
  )
}
