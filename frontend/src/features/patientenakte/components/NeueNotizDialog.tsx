import { useState } from 'react'
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
} from '@/shared/components/ui/dialog'
import { Button } from '@/shared/components/ui/button'
import { Textarea } from '@/shared/components/ui/textarea'
import { Label } from '@/shared/components/ui/label'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/shared/components/ui/select'
import type { NotizKategorie, FreieNotizFormDto } from '../types/patientenakte.types'

interface NeueNotizDialogProps {
  open: boolean
  onOpenChange: (open: boolean) => void
  onSubmit: (data: FreieNotizFormDto) => void
  isLoading?: boolean
}

const kategorieOptions: { value: NotizKategorie; label: string }[] = [
  { value: 'DIAGNOSE', label: 'Diagnose' },
  { value: 'BEOBACHTUNG', label: 'Beobachtung' },
  { value: 'SONSTIGES', label: 'Sonstiges' },
]

export const NeueNotizDialog = ({
  open,
  onOpenChange,
  onSubmit,
  isLoading,
}: NeueNotizDialogProps) => {
  const [kategorie, setKategorie] = useState<NotizKategorie>('SONSTIGES')
  const [inhalt, setInhalt] = useState('')

  const handleSubmit = () => {
    if (inhalt.trim()) {
      onSubmit({ kategorie, inhalt: inhalt.trim() })
      setKategorie('SONSTIGES')
      setInhalt('')
    }
  }

  const handleOpenChange = (newOpen: boolean) => {
    if (!newOpen) {
      setKategorie('SONSTIGES')
      setInhalt('')
    }
    onOpenChange(newOpen)
  }

  return (
    <Dialog open={open} onOpenChange={handleOpenChange}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Neue Notiz erstellen</DialogTitle>
        </DialogHeader>
        <div className="space-y-4 py-4">
          <div className="space-y-2">
            <Label htmlFor="kategorie">Kategorie</Label>
            <Select
              value={kategorie}
              onValueChange={(value) => setKategorie(value as NotizKategorie)}
            >
              <SelectTrigger id="kategorie">
                <SelectValue placeholder="Kategorie wählen" />
              </SelectTrigger>
              <SelectContent>
                {kategorieOptions.map((option) => (
                  <SelectItem key={option.value} value={option.value}>
                    {option.label}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
          <div className="space-y-2">
            <Label htmlFor="inhalt">Notiz</Label>
            <Textarea
              id="inhalt"
              value={inhalt}
              onChange={(e) => setInhalt(e.target.value)}
              placeholder="Notiz eingeben..."
              className="min-h-[150px]"
              disabled={isLoading}
            />
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" onClick={() => handleOpenChange(false)} disabled={isLoading}>
            Abbrechen
          </Button>
          <Button onClick={handleSubmit} disabled={isLoading || !inhalt.trim()}>
            Erstellen
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}
