import { useState } from 'react'
import { Button } from '@/shared/components/ui/button'
import { Label } from '@/shared/components/ui/label'
import { Input } from '@/shared/components/ui/input'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/shared/components/ui/select'
import type { SelectedTimeSlot, SeriesPattern } from '../types/behandlung.types'

interface SeriesCreatorProps {
  firstSlot: { date: Date; startZeit: string; endZeit: string } | null
  defaultCount: number
  onGenerate: (firstSlot: SelectedTimeSlot, pattern: SeriesPattern, count: number) => void
}

const patternLabels: Record<SeriesPattern, string> = {
  weekly: 'Wöchentlich',
  biweekly: 'Zweiwöchentlich',
  monthly: 'Monatlich (4 Wochen)',
  'twice-weekly': '2x pro Woche',
}

export const SeriesCreator = ({ firstSlot, defaultCount, onGenerate }: SeriesCreatorProps) => {
  const [pattern, setPattern] = useState<SeriesPattern>('weekly')
  const [count, setCount] = useState(defaultCount)

  const handleGenerate = () => {
    if (!firstSlot) return

    const slot: SelectedTimeSlot = {
      id: crypto.randomUUID(),
      date: firstSlot.date,
      startZeit: firstSlot.startZeit,
      endZeit: firstSlot.endZeit,
    }

    onGenerate(slot, pattern, count)
  }

  if (!firstSlot) {
    return (
      <div className="text-sm text-muted-foreground text-center py-2">
        Wähle zuerst einen Starttermin
      </div>
    )
  }

  return (
    <div className="space-y-4 p-4 rounded-lg border bg-muted/30">
      <div className="text-sm font-medium">Serie erstellen</div>

      <div className="grid grid-cols-2 gap-4">
        <div className="space-y-2">
          <Label>Muster</Label>
          <Select value={pattern} onValueChange={(v) => setPattern(v as SeriesPattern)}>
            <SelectTrigger>
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              {Object.entries(patternLabels).map(([value, label]) => (
                <SelectItem key={value} value={value}>
                  {label}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>

        <div className="space-y-2">
          <Label>Anzahl Termine</Label>
          <Input
            type="number"
            min={1}
            max={20}
            value={count}
            onChange={(e) => setCount(parseInt(e.target.value) || 1)}
          />
        </div>
      </div>

      <Button onClick={handleGenerate} className="w-full" variant="outline">
        {count} Termine generieren
      </Button>
    </div>
  )
}
