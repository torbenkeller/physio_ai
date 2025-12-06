import type { ReactNode } from 'react'
import { Sidebar } from './Sidebar'
import { Toaster } from '@/shared/components/ui/sonner'

interface LayoutProps {
  children: ReactNode
}

export const Layout = ({ children }: LayoutProps) => {
  return (
    <div className="flex h-screen bg-background overflow-hidden">
      <Sidebar />
      <main className="flex-1 flex flex-col overflow-hidden">
        <div className="flex-1 p-4 overflow-auto">
          {children}
        </div>
      </main>
      <Toaster />
    </div>
  )
}
