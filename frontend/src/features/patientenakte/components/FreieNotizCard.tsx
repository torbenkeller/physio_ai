import { useState } from 'react'
import { Card, CardContent, CardHeader } from '@/shared/components/ui/card'
import { Button } from '@/shared/components/ui/button'
import { Edit, Pin, PinOff, Trash2 } from 'lucide-react'
import type { FreieNotizDto } from '../types/patientenakte.types'
import { KategorieBadge } from './KategorieBadge'
import { NotizEditor } from './NotizEditor'

interface FreieNotizCardProps {
  notiz: FreieNotizDto
  onUpdate: (inhalt: string) => void
  onDelete: () => void
  onTogglePin: () => void
  isUpdating?: boolean
  isDeleting?: boolean
}

export const FreieNotizCard = ({
  notiz,
  onUpdate,
  onDelete,
  onTogglePin,
  isUpdating,
  isDeleting,
}: FreieNotizCardProps) => {
  const [isEditing, setIsEditing] = useState(false)

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('de-DE', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric',
    })
  }

  const formatTime = (dateString: string) => {
    return new Date(dateString).toLocaleTimeString('de-DE', {
      hour: '2-digit',
      minute: '2-digit',
    })
  }

  const handleSave = (inhalt: string) => {
    onUpdate(inhalt)
    setIsEditing(false)
  }

  return (
    <Card className={notiz.istAngepinnt ? 'border-primary/50 bg-primary/5' : ''}>
      <CardHeader className="pb-2">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <KategorieBadge kategorie={notiz.kategorie} />
            <span className="text-sm text-muted-foreground">
              {formatDate(notiz.erstelltAm)} {formatTime(notiz.erstelltAm)}
            </span>
            {notiz.aktualisiertAm && (
              <span className="text-xs text-muted-foreground">(bearbeitet)</span>
            )}
          </div>
          <div className="flex items-center gap-1">
            <Button
              variant="ghost"
              size="icon-sm"
              onClick={onTogglePin}
              title={notiz.istAngepinnt ? 'Nicht mehr anpinnen' : 'Anpinnen'}
            >
              {notiz.istAngepinnt ? <PinOff className="h-4 w-4" /> : <Pin className="h-4 w-4" />}
            </Button>
            <Button
              variant="ghost"
              size="icon-sm"
              onClick={() => setIsEditing(true)}
              title="Bearbeiten"
            >
              <Edit className="h-4 w-4" />
            </Button>
            <Button
              variant="ghost"
              size="icon-sm"
              onClick={onDelete}
              disabled={isDeleting}
              title="Löschen"
            >
              <Trash2 className="h-4 w-4" />
            </Button>
          </div>
        </div>
      </CardHeader>
      <CardContent>
        {isEditing ? (
          <NotizEditor
            initialValue={notiz.inhalt}
            onSave={handleSave}
            onCancel={() => setIsEditing(false)}
            isLoading={isUpdating}
          />
        ) : (
          <p className="whitespace-pre-wrap text-sm">{notiz.inhalt}</p>
        )}
      </CardContent>
    </Card>
  )
}
