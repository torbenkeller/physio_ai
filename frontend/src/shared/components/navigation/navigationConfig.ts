import type { LucideIcon } from 'lucide-react'
import { LayoutDashboard, Calendar, Users, FileText, Receipt, Settings } from 'lucide-react'

export interface NavItemConfig {
  to: string
  label: string
  icon: LucideIcon
}

/** Hauptnavigation (Desktop/Tablet/Mobile Sheet) */
export const NAV_ITEMS: NavItemConfig[] = [
  { to: '/', label: 'Dashboard', icon: LayoutDashboard },
  { to: '/kalender', label: 'Kalender', icon: Calendar },
  { to: '/patienten', label: 'Patienten', icon: Users },
  { to: '/rezepte', label: 'Rezepte', icon: FileText },
  { to: '/abrechnung', label: 'Abrechnung', icon: Receipt },
]

/** Footer-Navigation für Desktop Drawer und Tablet Rail */
export const FOOTER_NAV_ITEMS: NavItemConfig[] = [
  { to: '/profil', label: 'Profil', icon: Settings },
]

/** Mobile Bottom Navigation (alle 5 Business-Items) */
export const MOBILE_NAV_ITEMS: NavItemConfig[] = [
  { to: '/', label: 'Dashboard', icon: LayoutDashboard },
  { to: '/kalender', label: 'Kalender', icon: Calendar },
  { to: '/patienten', label: 'Patienten', icon: Users },
  { to: '/rezepte', label: 'Rezepte', icon: FileText },
  { to: '/abrechnung', label: 'Abrechnung', icon: Receipt },
]
