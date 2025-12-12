import { useState } from 'react'
import { Card, CardContent, CardHeader } from '@/shared/components/ui/card'
import { Button } from '@/shared/components/ui/button'
import { Calendar, Clock, Edit, Pin, PinOff } from 'lucide-react'
import type { BehandlungsEintragDto } from '../types/patientenakte.types'
import { NotizEditor } from './NotizEditor'

interface BehandlungsEintragCardProps {
  eintrag: BehandlungsEintragDto
  onUpdateNotiz: (inhalt: string) => void
  onTogglePin: () => void
  isUpdating?: boolean
}

export const BehandlungsEintragCard = ({
  eintrag,
  onUpdateNotiz,
  onTogglePin,
  isUpdating,
}: BehandlungsEintragCardProps) => {
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
    onUpdateNotiz(inhalt)
    setIsEditing(false)
  }

  return (
    <Card className={eintrag.istAngepinnt ? 'border-primary/50 bg-primary/5' : ''}>
      <CardHeader className="pb-2">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3 text-sm text-muted-foreground">
            <span className="flex items-center gap-1">
              <Calendar className="h-4 w-4" />
              {formatDate(eintrag.behandlungsDatum)}
            </span>
            <span className="flex items-center gap-1">
              <Clock className="h-4 w-4" />
              {formatTime(eintrag.behandlungsDatum)}
            </span>
            {eintrag.notiz?.aktualisiertAm && (
              <span className="text-xs text-muted-foreground">(bearbeitet)</span>
            )}
          </div>
          <div className="flex items-center gap-1">
            <Button
              variant="ghost"
              size="icon-sm"
              onClick={onTogglePin}
              title={eintrag.istAngepinnt ? 'Nicht mehr anpinnen' : 'Anpinnen'}
            >
              {eintrag.istAngepinnt ? <PinOff className="h-4 w-4" /> : <Pin className="h-4 w-4" />}
            </Button>
            <Button
              variant="ghost"
              size="icon-sm"
              onClick={() => setIsEditing(true)}
              title="Notiz bearbeiten"
            >
              <Edit className="h-4 w-4" />
            </Button>
          </div>
        </div>
      </CardHeader>
      <CardContent>
        {isEditing ? (
          <NotizEditor
            initialValue={eintrag.notiz?.inhalt ?? ''}
            onSave={handleSave}
            onCancel={() => setIsEditing(false)}
            isLoading={isUpdating}
          />
        ) : (
          <div>
            <div className="mb-1 text-xs font-medium text-muted-foreground">Behandlung</div>
            {eintrag.notiz?.inhalt ? (
              <p className="whitespace-pre-wrap text-sm">{eintrag.notiz.inhalt}</p>
            ) : (
              <p className="text-sm italic text-muted-foreground">Keine Notiz vorhanden</p>
            )}
          </div>
        )}
      </CardContent>
    </Card>
  )
}
