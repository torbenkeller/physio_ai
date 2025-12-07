import { Settings } from 'lucide-react'
import { Button } from '@/shared/components/ui/button'
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/shared/components/ui/dialog'
import { Switch } from '@/shared/components/ui/switch'
import { Label } from '@/shared/components/ui/label'

interface KalenderSettingsDialogProps {
  showWeekend: boolean
  onShowWeekendChange: (show: boolean) => void
}

export const KalenderSettingsDialog = ({
  showWeekend,
  onShowWeekendChange,
}: KalenderSettingsDialogProps) => {
  return (
    <Dialog>
      <DialogTrigger asChild>
        <Button variant="outline" size="icon" aria-label="Kalender-Einstellungen">
          <Settings className="h-4 w-4" />
        </Button>
      </DialogTrigger>
      <DialogContent className="sm:max-w-[425px]">
        <DialogHeader>
          <DialogTitle>Kalender-Einstellungen</DialogTitle>
          <DialogDescription>
            Passen Sie die Darstellung des Kalenders an.
          </DialogDescription>
        </DialogHeader>
        <div className="py-4">
          <div className="flex items-center justify-between">
            <Label htmlFor="show-weekend" className="flex flex-col gap-1">
              <span>Wochenende anzeigen</span>
              <span className="text-sm font-normal text-muted-foreground">
                Samstag und Sonntag im Kalender einblenden
              </span>
            </Label>
            <Switch
              id="show-weekend"
              checked={showWeekend}
              onCheckedChange={onShowWeekendChange}
              aria-label="Wochenende anzeigen"
            />
          </div>
        </div>
      </DialogContent>
    </Dialog>
  )
}
