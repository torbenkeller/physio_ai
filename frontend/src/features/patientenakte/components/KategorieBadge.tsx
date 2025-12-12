import { Badge } from '@/shared/components/ui/badge'
import type { NotizKategorie } from '../types/patientenakte.types'

interface KategorieBadgeProps {
  kategorie: NotizKategorie
}

const kategorieConfig: Record<
  NotizKategorie,
  { label: string; variant: 'default' | 'secondary' | 'outline' }
> = {
  DIAGNOSE: { label: 'Diagnose', variant: 'default' },
  BEOBACHTUNG: { label: 'Beobachtung', variant: 'secondary' },
  SONSTIGES: { label: 'Sonstiges', variant: 'outline' },
}

export const KategorieBadge = ({ kategorie }: KategorieBadgeProps) => {
  const config = kategorieConfig[kategorie]
  return <Badge variant={config.variant}>{config.label}</Badge>
}
