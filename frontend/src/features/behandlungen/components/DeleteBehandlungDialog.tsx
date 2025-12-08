import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@/shared/components/ui/dialog'
import { Button } from '@/shared/components/ui/button'
import { useDeleteBehandlungMutation } from '../api/behandlungenApi'
import { toast } from 'sonner'

interface DeleteBehandlungDialogProps {
  open: boolean
  onOpenChange: (open: boolean) => void
  behandlungId: string
  patientName: string
  startZeit: string
  onSuccess?: () => void
}

export const DeleteBehandlungDialog = ({
  open,
  onOpenChange,
  behandlungId,
  patientName,
  startZeit,
  onSuccess,
}: DeleteBehandlungDialogProps) => {
  const [deleteBehandlung, { isLoading }] = useDeleteBehandlungMutation()

  const formatDateTime = (dateString: string) => {
    const date = new Date(dateString)
    return {
      date: date.toLocaleDateString('de-DE', {
        weekday: 'long',
        day: '2-digit',
        month: 'long',
        year: 'numeric',
      }),
      time: date.toLocaleTimeString('de-DE', { hour: '2-digit', minute: '2-digit' }),
    }
  }

  const { date, time } = formatDateTime(startZeit)

  const handleDelete = async () => {
    try {
      await deleteBehandlung(behandlungId).unwrap()
      toast.success('Termin wurde gelöscht')
      onOpenChange(false)
      onSuccess?.()
    } catch {
      toast.error('Termin konnte nicht gelöscht werden')
    }
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Termin löschen</DialogTitle>
          <DialogDescription>
            Sind Sie sicher, dass Sie diesen Termin löschen möchten? Diese Aktion kann nicht
            rückgängig gemacht werden.
          </DialogDescription>
        </DialogHeader>

        <div className="rounded-lg border bg-muted/50 p-4">
          <div className="space-y-1">
            <p className="font-medium">{patientName}</p>
            <p className="text-sm text-muted-foreground">{date}</p>
            <p className="text-sm text-muted-foreground">{time} Uhr</p>
          </div>
        </div>

        <DialogFooter>
          <Button variant="outline" onClick={() => onOpenChange(false)} disabled={isLoading}>
            Abbrechen
          </Button>
          <Button variant="destructive" onClick={handleDelete} disabled={isLoading}>
            {isLoading ? 'Wird gelöscht...' : 'Löschen'}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}
