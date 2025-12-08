import type { ReactNode } from 'react'
import { TooltipProvider } from '@/shared/components/ui/tooltip'
import { Toaster } from '@/shared/components/ui/sonner'
import { NavigationDrawer } from './navigation/NavigationDrawer'
import { NavigationRail } from './navigation/NavigationRail'
import { BottomNavigation } from './navigation/BottomNavigation'
import { MobileHeader } from './navigation/MobileHeader'

interface LayoutProps {
  children: ReactNode
}

export const Layout = ({ children }: LayoutProps) => {
  return (
    <TooltipProvider>
      <div className="flex h-screen bg-background overflow-hidden">
        {/* Desktop Navigation (>= 1024px) */}
        <NavigationDrawer />

        {/* Tablet Navigation (640px - 1024px) */}
        <NavigationRail />

        {/* Main Content Area */}
        <div className="flex-1 flex flex-col overflow-hidden">
          {/* Mobile Header (< 640px) */}
          <MobileHeader />

          {/* Content */}
          <main className="flex-1 p-4 overflow-auto pb-16 sm:pb-4">{children}</main>
        </div>

        {/* Mobile Bottom Navigation (< 640px) */}
        <BottomNavigation />

        <Toaster />
      </div>
    </TooltipProvider>
  )
}
