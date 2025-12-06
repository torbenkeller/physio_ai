import { memo, useCallback } from 'react'
import { X } from 'lucide-react'
import { Button } from '@/shared/components/ui/button'
import { TimeInput } from '@/shared/components/ui/time-input'
import { DateInput } from '@/shared/components/ui/date-input'
import type { SelectedTimeSlot } from '../types/behandlung.types'

interface SelectedSlotsListProps {
  slots: SelectedTimeSlot[]
  onRemove: (id: string) => void
  onUpdate: (id: string, updates: Partial<Omit<SelectedTimeSlot, 'id'>>) => void
}

// Wochentag-Kürzel
const getWeekdayShort = (date: Date) => {
  return date.toLocaleDateString('de-DE', { weekday: 'short' })
}

interface SlotItemProps {
  slot: SelectedTimeSlot
  index: number
  onRemove: (id: string) => void
  onUpdate: (id: string, updates: Partial<Omit<SelectedTimeSlot, 'id'>>) => void
}

// Memoized Slot-Item um Re-Renders zu vermeiden
const SlotItem = memo(function SlotItem({ slot, index, onRemove, onUpdate }: SlotItemProps) {
  const handleDateChange = useCallback(
    (date: Date) => onUpdate(slot.id, { date }),
    [slot.id, onUpdate]
  )

  const handleStartZeitChange = useCallback(
    (value: string) => onUpdate(slot.id, { startZeit: value }),
    [slot.id, onUpdate]
  )

  const handleEndZeitChange = useCallback(
    (value: string) => onUpdate(slot.id, { endZeit: value }),
    [slot.id, onUpdate]
  )

  const handleRemove = useCallback(
    () => onRemove(slot.id),
    [slot.id, onRemove]
  )

  return (
    <div className="flex items-center gap-2 p-2 rounded-md bg-muted/50 text-sm">
      <span className="text-muted-foreground w-6">{index + 1}.</span>
      <span className="text-muted-foreground text-xs w-8">{getWeekdayShort(slot.date)}</span>
      <DateInput
        value={slot.date}
        onChange={handleDateChange}
        className="h-7 text-xs"
      />
      <div className="flex items-center gap-1">
        <TimeInput
          value={slot.startZeit}
          onChange={handleStartZeitChange}
          className="w-20 h-7 text-xs"
        />
        <span className="text-muted-foreground">-</span>
        <TimeInput
          value={slot.endZeit}
          onChange={handleEndZeitChange}
          className="w-20 h-7 text-xs"
        />
      </div>
      <Button
        variant="ghost"
        size="icon"
        className="h-7 w-7 ml-auto"
        onClick={handleRemove}
      >
        <X className="h-4 w-4" />
      </Button>
    </div>
  )
})

export const SelectedSlotsList = ({ slots, onRemove, onUpdate }: SelectedSlotsListProps) => {
  if (slots.length === 0) {
    return (
      <div className="text-sm text-muted-foreground text-center py-4">
        Noch keine Termine ausgewählt
      </div>
    )
  }

  return (
    <div className="space-y-2 max-h-64 overflow-y-auto">
      {slots.map((slot, index) => (
        <SlotItem
          key={slot.id}
          slot={slot}
          index={index}
          onRemove={onRemove}
          onUpdate={onUpdate}
        />
      ))}
    </div>
  )
}
