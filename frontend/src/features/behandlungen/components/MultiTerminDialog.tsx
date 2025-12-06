import { useState, useEffect } from 'react'
import { toast } from 'sonner'
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from '@/shared/components/ui/dialog'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/shared/components/ui/select'
import { Label } from '@/shared/components/ui/label'
import { TimeInput } from '@/shared/components/ui/time-input'
import { Button } from '@/shared/components/ui/button'
import { Separator } from '@/shared/components/ui/separator'
import { useGetPatientenQuery } from '@/features/patienten/api/patientenApi'
import { useCreateBehandlungenBatchMutation } from '../api/behandlungenApi'
import { useMultiTerminSelection } from '../hooks/useMultiTerminSelection'
import { SelectedSlotsList } from './SelectedSlotsList'
import { SeriesCreator } from './SeriesCreator'
import type { SelectedTimeSlot, SeriesPattern } from '../types/behandlung.types'

interface MultiTerminDialogProps {
  open: boolean
  onOpenChange: (open: boolean) => void
  initialSlot: { date: Date; startZeit: string; endZeit: string } | null
  onSuccess?: () => void
}

const formatDateTimeForApi = (date: Date, time: string) => {
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  return `${year}-${month}-${day}T${time}:00`
}

export const MultiTerminDialog = ({
  open,
  onOpenChange,
  initialSlot,
  onSuccess,
}: MultiTerminDialogProps) => {
  const { data: patienten } = useGetPatientenQuery()
  const [createBatch, { isLoading: isCreating }] = useCreateBehandlungenBatchMutation()

  const [selectedPatient, setSelectedPatient] = useState<string>('')
  const [firstSlotStartZeit, setFirstSlotStartZeit] = useState('')
  const [firstSlotEndZeit, setFirstSlotEndZeit] = useState('')

  const { slots, removeSlot, updateSlot, clearSlots, generateSeries } =
    useMultiTerminSelection()

  // Reset when dialog opens/closes or initialSlot changes
  useEffect(() => {
    if (open && initialSlot) {
      setFirstSlotStartZeit(initialSlot.startZeit)
      setFirstSlotEndZeit(initialSlot.endZeit)
      setSelectedPatient('')
      clearSlots()
    }
  }, [open, initialSlot, clearSlots])

  const selectedPatientData = patienten?.find((p) => p.id === selectedPatient)
  const defaultCount = selectedPatientData?.behandlungenProRezept ?? 8

  const handleGenerateSeries = (
    firstSlot: SelectedTimeSlot,
    pattern: SeriesPattern,
    count: number
  ) => {
    generateSeries(firstSlot, pattern, count)
  }

  const handleCreateTermine = async () => {
    if (!selectedPatient || slots.length === 0) return

    const behandlungen = slots.map((slot) => ({
      patientId: selectedPatient,
      startZeit: formatDateTimeForApi(slot.date, slot.startZeit),
      endZeit: formatDateTimeForApi(slot.date, slot.endZeit),
    }))

    try {
      await createBatch(behandlungen).unwrap()
      toast.success(`${slots.length} Termine erfolgreich erstellt`)
      onOpenChange(false)
      onSuccess?.()
    } catch {
      toast.error('Fehler beim Erstellen der Termine')
    }
  }

  const currentFirstSlot = initialSlot
    ? {
        date: initialSlot.date,
        startZeit: firstSlotStartZeit,
        endZeit: firstSlotEndZeit,
      }
    : null

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-lg">
        <DialogHeader>
          <DialogTitle>Mehrere Behandlungstermine erstellen</DialogTitle>
        </DialogHeader>

        <div className="space-y-4">
          {/* Patient Selection */}
          <div className="space-y-2">
            <Label>Patient</Label>
            <Select value={selectedPatient} onValueChange={setSelectedPatient}>
              <SelectTrigger>
                <SelectValue placeholder="Patient auswählen..." />
              </SelectTrigger>
              <SelectContent>
                {patienten?.map((patient) => (
                  <SelectItem key={patient.id} value={patient.id}>
                    {patient.vorname} {patient.nachname}
                    {patient.behandlungenProRezept && (
                      <span className="text-muted-foreground ml-2">
                        ({patient.behandlungenProRezept} Termine/Rezept)
                      </span>
                    )}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          {/* First Slot Info */}
          {initialSlot && (
            <div className="space-y-2">
              <Label>Erster Termin</Label>
              <div className="p-3 rounded-lg bg-muted/50">
                <div className="text-sm font-medium mb-2">
                  {initialSlot.date.toLocaleDateString('de-DE', {
                    weekday: 'long',
                    day: 'numeric',
                    month: 'long',
                    year: 'numeric',
                  })}
                </div>
                <div className="flex gap-2 items-center">
                  <TimeInput
                    value={firstSlotStartZeit}
                    onChange={setFirstSlotStartZeit}
                    className="w-20"
                  />
                  <span className="text-muted-foreground">bis</span>
                  <TimeInput
                    value={firstSlotEndZeit}
                    onChange={setFirstSlotEndZeit}
                    className="w-20"
                  />
                </div>
              </div>
            </div>
          )}

          <Separator />

          {/* Series Creator */}
          <SeriesCreator
            firstSlot={currentFirstSlot}
            defaultCount={defaultCount}
            onGenerate={handleGenerateSeries}
          />

          <Separator />

          {/* Selected Slots List */}
          <div className="space-y-2">
            <div className="flex items-center justify-between">
              <Label>Ausgewählte Termine ({slots.length})</Label>
              {slots.length > 0 && (
                <Button variant="ghost" size="sm" onClick={clearSlots}>
                  Alle entfernen
                </Button>
              )}
            </div>
            <SelectedSlotsList
              slots={slots}
              onRemove={removeSlot}
              onUpdate={updateSlot}
            />
          </div>

          {/* Action Buttons */}
          <div className="flex justify-end gap-2 pt-4">
            <Button variant="outline" onClick={() => onOpenChange(false)}>
              Abbrechen
            </Button>
            <Button
              onClick={handleCreateTermine}
              disabled={!selectedPatient || slots.length === 0 || isCreating}
            >
              {isCreating
                ? 'Erstellen...'
                : `${slots.length} Termine erstellen`}
            </Button>
          </div>
        </div>
      </DialogContent>
    </Dialog>
  )
}
