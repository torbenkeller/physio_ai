import type { ReactNode } from 'react'
import { TooltipProvider } from '@/shared/components/ui/tooltip'
import { Toaster } from '@/shared/components/ui/sonner'
import { useMediaQuery } from '@/shared/hooks'
import { NavigationDrawer } from './navigation/NavigationDrawer'
import { NavigationRail } from './navigation/NavigationRail'
import { BottomNavigation } from './navigation/BottomNavigation'
import { MobileHeader } from './navigation/MobileHeader'

interface LayoutProps {
  children: ReactNode
}

export const Layout = ({ children }: LayoutProps) => {
  const isDesktop = useMediaQuery('(min-width: 1024px)')
  const isTablet = useMediaQuery('(min-width: 640px)')
  const isMobile = !isTablet

  return (
    <TooltipProvider>
      <div className="flex h-screen bg-background overflow-hidden">
        {/* Desktop Navigation (>= 1024px) */}
        {isDesktop && <NavigationDrawer />}

        {/* Tablet Navigation (640px - 1024px) */}
        {isTablet && !isDesktop && <NavigationRail />}

        {/* Main Content Area */}
        <div className="flex-1 flex flex-col overflow-hidden">
          {/* Mobile Header (< 640px) */}
          {isMobile && <MobileHeader />}

          {/* Content */}
          <main className={`flex-1 p-4 overflow-auto ${isMobile ? 'pb-16' : ''}`}>{children}</main>
        </div>

        {/* Mobile Bottom Navigation (< 640px) */}
        {isMobile && <BottomNavigation />}

        <Toaster />
      </div>
    </TooltipProvider>
  )
}
