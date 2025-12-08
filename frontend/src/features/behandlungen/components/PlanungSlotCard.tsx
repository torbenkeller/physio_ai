import { memo, useCallback, useMemo } from 'react'
import { X, AlertTriangle } from 'lucide-react'
import { Button } from '@/shared/components/ui/button'
import { TimeInput } from '@/shared/components/ui/time-input'
import { DateInput } from '@/shared/components/ui/date-input'
import { cn } from '@/shared/utils'
import type { SelectedTimeSlot } from '../types/behandlung.types'

interface PlanungSlotCardProps {
  slot: SelectedTimeSlot
  index: number
  isSelected: boolean
  onSelect: (slotId: string | null) => void
  onUpdate: (slotId: string, updates: Partial<Omit<SelectedTimeSlot, 'id'>>) => void
  onRemove: (slotId: string) => void
}

export const PlanungSlotCard = memo(function PlanungSlotCard({
  slot,
  index,
  isSelected,
  onSelect,
  onUpdate,
  onRemove,
}: PlanungSlotCardProps) {
  const handleClick = useCallback(() => {
    onSelect(isSelected ? null : slot.id)
  }, [slot.id, isSelected, onSelect])

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
    (e: React.MouseEvent) => {
      e.stopPropagation()
      onRemove(slot.id)
    },
    [slot.id, onRemove]
  )

  const handleStopPropagation = useCallback((e: React.MouseEvent) => {
    e.stopPropagation()
  }, [])

  const weekday = useMemo(
    () => slot.date.toLocaleDateString('de-DE', { weekday: 'short' }).replace('.', ''),
    [slot.date]
  )

  return (
    <div
      className={cn(
        'p-2 rounded-md border cursor-pointer transition-colors',
        isSelected
          ? 'border-primary bg-primary/5'
          : 'border-transparent bg-muted/50 hover:bg-muted',
        slot.hasConflict && 'border-amber-500 bg-amber-500/10'
      )}
      onClick={handleClick}
    >
      <div className="flex items-center gap-2">
        <span className="text-xs text-muted-foreground w-10 flex-shrink-0">
          {index + 1}. {weekday}
        </span>
        <div className="flex-1" onClick={handleStopPropagation}>
          <DateInput
            value={slot.date}
            onChange={handleDateChange}
            className="h-7 text-xs w-full"
          />
        </div>
        {slot.hasConflict && (
          <AlertTriangle className="h-4 w-4 text-amber-500 flex-shrink-0" />
        )}
        <Button
          variant="ghost"
          size="icon"
          className="h-6 w-6 flex-shrink-0"
          onClick={handleRemove}
        >
          <X className="h-3 w-3" />
        </Button>
      </div>
      <div
        className="flex items-center gap-1 mt-2 ml-12"
        onClick={handleStopPropagation}
      >
        <TimeInput
          value={slot.startZeit}
          onChange={handleStartZeitChange}
          className="w-20 h-7 text-xs"
        />
        <span className="text-xs text-muted-foreground">-</span>
        <TimeInput
          value={slot.endZeit}
          onChange={handleEndZeitChange}
          className="w-20 h-7 text-xs"
        />
      </div>
      {slot.hasConflict && slot.conflictingWith && slot.conflictingWith.length > 0 && (
        <div className="mt-2 ml-12 text-xs text-amber-600">
          Konflikt mit: {slot.conflictingWith.map((c) => c.patientName).join(', ')}
        </div>
      )}
    </div>
  )
})
