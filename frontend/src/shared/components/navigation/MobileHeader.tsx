import { Link } from 'react-router-dom'
import { User } from 'lucide-react'
import { Button } from '@/shared/components/ui/button'

export const MobileHeader = () => {
  return (
    <header className="flex h-14 items-center justify-between border-b bg-card px-4">
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
