import { useState, useEffect } from 'react'
import { toast } from 'sonner'
import {
  Dialog,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@/shared/components/ui/dialog'
import { Button } from '@/shared/components/ui/button'
import { Label } from '@/shared/components/ui/label'
import { DateInput } from '@/shared/components/ui/date-input'
import { TimeInput } from '@/shared/components/ui/time-input'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/shared/components/ui/select'
import { useUpdateBehandlungMutation } from '../api/behandlungenApi'
import { useGetRezepteQuery } from '@/features/rezepte/api/rezepteApi'
import type { BehandlungKalenderDto } from '../types/behandlung.types'
import type { BehandlungsartDto } from '@/features/rezepte/types/rezept.types'

interface BehandlungEditDialogProps {
  open: boolean
  onOpenChange: (open: boolean) => void
  behandlung: BehandlungKalenderDto
  behandlungsarten: BehandlungsartDto[] | undefined
  onSuccess?: () => void
}

const NO_SELECTION = '__NONE__'

export const BehandlungEditDialog = ({
  open,
  onOpenChange,
  behandlung,
  behandlungsarten,
  onSuccess,
}: BehandlungEditDialogProps) => {
  const [updateBehandlung, { isLoading }] = useUpdateBehandlungMutation()
  const { data: rezepte } = useGetRezepteQuery(undefined, {
    skip: !open,
  })

  // Filter rezepte für den aktuellen Patienten
  const patientRezepte = rezepte?.filter((r) => r.patient.id === behandlung.patient.id) || []

  // Form state
  const [date, setDate] = useState<Date>(new Date(behandlung.startZeit))
  const [startZeit, setStartZeit] = useState<string>('')
  const [endZeit, setEndZeit] = useState<string>('')
  const [behandlungsartId, setBehandlungsartId] = useState<string>(NO_SELECTION)
  const [rezeptId, setRezeptId] = useState<string>(NO_SELECTION)

  // Initialize form when dialog opens or behandlung changes
  useEffect(() => {
    if (open) {
      const start = new Date(behandlung.startZeit)
      const end = new Date(behandlung.endZeit)

      setDate(start)
      setStartZeit(
        `${String(start.getHours()).padStart(2, '0')}:${String(start.getMinutes()).padStart(2, '0')}`
      )
      setEndZeit(
        `${String(end.getHours()).padStart(2, '0')}:${String(end.getMinutes()).padStart(2, '0')}`
      )
      setBehandlungsartId(behandlung.behandlungsartId || NO_SELECTION)
      setRezeptId(behandlung.rezeptId || NO_SELECTION)
    }
  }, [open, behandlung])

  const handleSubmit = async () => {
    try {
      // Combine date and time
      const [startHours, startMinutes] = startZeit.split(':').map(Number)
      const [endHours, endMinutes] = endZeit.split(':').map(Number)

      const startDateTime = new Date(date)
      startDateTime.setHours(startHours, startMinutes, 0, 0)

      const endDateTime = new Date(date)
      endDateTime.setHours(endHours, endMinutes, 0, 0)

      await updateBehandlung({
        id: behandlung.id,
        data: {
          patientId: behandlung.patient.id,
          startZeit: startDateTime.toISOString(),
          endZeit: endDateTime.toISOString(),
          behandlungsartId: behandlungsartId === NO_SELECTION ? null : behandlungsartId,
          rezeptId: rezeptId === NO_SELECTION ? null : rezeptId,
          bemerkung: behandlung.bemerkung,
        },
      }).unwrap()

      toast.success('Termin wurde aktualisiert')
      onOpenChange(false)
      onSuccess?.()
    } catch {
      toast.error('Termin konnte nicht aktualisiert werden')
    }
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-md">
        <DialogHeader>
          <DialogTitle>Termin bearbeiten</DialogTitle>
        </DialogHeader>

        <div className="space-y-4 py-4">
          {/* Patient (nur Anzeige) */}
          <div className="space-y-2">
            <Label className="text-muted-foreground">Patient</Label>
            <p className="text-sm font-medium">{behandlung.patient.name}</p>
          </div>

          {/* Datum */}
          <div className="space-y-2">
            <Label>Datum</Label>
            <DateInput value={date} onChange={setDate} />
          </div>

          {/* Zeitraum */}
          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-2">
              <Label>Von</Label>
              <TimeInput value={startZeit} onChange={setStartZeit} />
            </div>
            <div className="space-y-2">
              <Label>Bis</Label>
              <TimeInput value={endZeit} onChange={setEndZeit} />
            </div>
          </div>

          {/* Behandlungsart */}
          <div className="space-y-2">
            <Label>Behandlungsart</Label>
            <Select value={behandlungsartId} onValueChange={setBehandlungsartId}>
              <SelectTrigger>
                <SelectValue placeholder="Behandlungsart auswählen..." />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value={NO_SELECTION}>Keine</SelectItem>
                {behandlungsarten?.map((art) => (
                  <SelectItem key={art.id} value={art.id}>
                    {art.name}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          {/* Rezept */}
          <div className="space-y-2">
            <Label>Rezept</Label>
            <Select value={rezeptId} onValueChange={setRezeptId}>
              <SelectTrigger>
                <SelectValue placeholder="Rezept auswählen..." />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value={NO_SELECTION}>Kein Rezept</SelectItem>
                {patientRezepte.map((rezept) => (
                  <SelectItem key={rezept.id} value={rezept.id}>
                    {new Date(rezept.ausgestelltAm).toLocaleDateString('de-DE')} -{' '}
                    {rezept.positionen.map((p) => p.behandlungsart.name).join(', ')}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
        </div>

        <DialogFooter>
          <Button variant="outline" onClick={() => onOpenChange(false)} disabled={isLoading}>
            Abbrechen
          </Button>
          <Button onClick={handleSubmit} disabled={isLoading}>
            {isLoading ? 'Wird gespeichert...' : 'Speichern'}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}
