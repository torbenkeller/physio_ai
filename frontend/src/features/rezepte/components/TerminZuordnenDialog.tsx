import { useState } from 'react'
import { toast } from 'sonner'
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@/shared/components/ui/dialog'
import { Button } from '@/shared/components/ui/button'
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/shared/components/ui/table'
import { Checkbox } from '@/shared/components/ui/checkbox'
import {
  useGetUnassignedBehandlungenByPatientQuery,
  useUpdateBehandlungMutation,
} from '@/features/behandlungen/api/behandlungenApi'
import type { BehandlungKalenderDto } from '@/features/behandlungen/types/behandlung.types'

interface TerminZuordnenDialogProps {
  open: boolean
  onOpenChange: (open: boolean) => void
  patientId: string
  rezeptId: string
  onSuccess?: () => void
}

export const TerminZuordnenDialog = ({
  open,
  onOpenChange,
  patientId,
  rezeptId,
  onSuccess,
}: TerminZuordnenDialogProps) => {
  const [selectedIds, setSelectedIds] = useState<Set<string>>(new Set())
  const { data: termine, isLoading } = useGetUnassignedBehandlungenByPatientQuery(patientId, {
    skip: !open,
  })
  const [updateBehandlung, { isLoading: isUpdating }] = useUpdateBehandlungMutation()

  const formatDateTime = (dateString: string) => {
    const date = new Date(dateString)
    return {
      date: date.toLocaleDateString('de-DE'),
      time: date.toLocaleTimeString('de-DE', { hour: '2-digit', minute: '2-digit' }),
    }
  }

  const toggleSelect = (id: string) => {
    const newSet = new Set(selectedIds)
    if (newSet.has(id)) {
      newSet.delete(id)
    } else {
      newSet.add(id)
    }
    setSelectedIds(newSet)
  }

  const handleZuordnen = async () => {
    const updates = Array.from(selectedIds).map((id) => {
      const termin = termine?.find((t) => t.id === id)
      if (!termin) return null

      return updateBehandlung({
        id,
        data: {
          patientId,
          startZeit: termin.startZeit,
          endZeit: termin.endZeit,
          rezeptId,
        },
      })
    })

    const results = await Promise.allSettled(updates.filter(Boolean))
    const failures = results.filter((r) => r.status === 'rejected')
    const successes = results.filter((r) => r.status === 'fulfilled')

    if (failures.length > 0) {
      toast.error(`${failures.length} Termine konnten nicht zugeordnet werden`)
    }

    if (successes.length > 0) {
      toast.success(`${successes.length} Termine erfolgreich zugeordnet`)
    }

    setSelectedIds(new Set())
    onOpenChange(false)
    onSuccess?.()
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-2xl">
        <DialogHeader>
          <DialogTitle>Termine zuordnen</DialogTitle>
          <DialogDescription>
            Wählen Sie die Termine aus, die diesem Rezept zugeordnet werden sollen.
          </DialogDescription>
        </DialogHeader>

        {isLoading ? (
          <div className="flex h-32 items-center justify-center">
            <span className="text-muted-foreground">Laden...</span>
          </div>
        ) : termine && termine.length > 0 ? (
          <div className="max-h-96 overflow-auto">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead className="w-12"></TableHead>
                  <TableHead>Datum</TableHead>
                  <TableHead>Uhrzeit</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {termine.map((termin: BehandlungKalenderDto) => {
                  const { date, time } = formatDateTime(termin.startZeit)
                  const endTime = formatDateTime(termin.endZeit).time

                  return (
                    <TableRow
                      key={termin.id}
                      className="cursor-pointer"
                      onClick={() => toggleSelect(termin.id)}
                    >
                      <TableCell>
                        <Checkbox
                          checked={selectedIds.has(termin.id)}
                          onCheckedChange={() => toggleSelect(termin.id)}
                        />
                      </TableCell>
                      <TableCell>{date}</TableCell>
                      <TableCell>
                        {time} - {endTime}
                      </TableCell>
                    </TableRow>
                  )
                })}
              </TableBody>
            </Table>
          </div>
        ) : (
          <div className="flex h-32 items-center justify-center">
            <span className="text-muted-foreground">
              Keine unzugeordneten Termine für diesen Patienten vorhanden.
            </span>
          </div>
        )}

        <DialogFooter>
          <Button variant="outline" onClick={() => onOpenChange(false)}>
            Abbrechen
          </Button>
          <Button
            onClick={handleZuordnen}
            disabled={selectedIds.size === 0 || isUpdating}
          >
            {isUpdating ? 'Wird zugeordnet...' : `${selectedIds.size} Termine zuordnen`}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}
