import { useState } from 'react'
import { Button } from '@/shared/components/ui/button'
import { Textarea } from '@/shared/components/ui/textarea'
import { Check, X } from 'lucide-react'

interface NotizEditorProps {
  initialValue: string
  onSave: (inhalt: string) => void
  onCancel: () => void
  isLoading?: boolean
}

export const NotizEditor = ({ initialValue, onSave, onCancel, isLoading }: NotizEditorProps) => {
  const [inhalt, setInhalt] = useState(initialValue)

  const handleSave = () => {
    if (inhalt.trim()) {
      onSave(inhalt.trim())
    }
  }

  return (
    <div className="space-y-2">
      <Textarea
        value={inhalt}
        onChange={(e) => setInhalt(e.target.value)}
        placeholder="Notiz eingeben..."
        className="min-h-[100px]"
        disabled={isLoading}
      />
      <div className="flex justify-end gap-2">
        <Button variant="outline" size="sm" onClick={onCancel} disabled={isLoading}>
          <X className="mr-1 h-3 w-3" />
          Abbrechen
        </Button>
        <Button size="sm" onClick={handleSave} disabled={isLoading || !inhalt.trim()}>
          <Check className="mr-1 h-3 w-3" />
          Speichern
        </Button>
      </div>
    </div>
  )
}
