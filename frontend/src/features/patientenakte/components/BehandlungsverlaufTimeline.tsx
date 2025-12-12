import { useState } from 'react'
import { Button } from '@/shared/components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '@/shared/components/ui/card'
import { Plus } from 'lucide-react'
import { toast } from 'sonner'
import {
  useGetPatientenakteQuery,
  useCreateFreieNotizMutation,
  useDeleteFreieNotizMutation,
  useUpdateBehandlungsNotizMutation,
  useUpdateFreieNotizMutation,
  usePinBehandlungsEintragMutation,
  usePinFreieNotizMutation,
} from '../api/patientenakteApi'
import { isBehandlungsEintrag, isFreieNotiz } from '../types/patientenakte.types'
import type { AktenEintragDto, FreieNotizFormDto } from '../types/patientenakte.types'
import { BehandlungsEintragCard } from './BehandlungsEintragCard'
import { FreieNotizCard } from './FreieNotizCard'
import { NeueNotizDialog } from './NeueNotizDialog'

interface BehandlungsverlaufTimelineProps {
  patientId: string
}

export const BehandlungsverlaufTimeline = ({ patientId }: BehandlungsverlaufTimelineProps) => {
  const [neueNotizOpen, setNeueNotizOpen] = useState(false)

  const { data: akte, isLoading, error } = useGetPatientenakteQuery(patientId)
  const [createFreieNotiz, { isLoading: isCreating }] = useCreateFreieNotizMutation()
  const [deleteFreieNotiz] = useDeleteFreieNotizMutation()
  const [updateBehandlungsNotiz] = useUpdateBehandlungsNotizMutation()
  const [updateFreieNotiz] = useUpdateFreieNotizMutation()
  const [pinBehandlungsEintrag] = usePinBehandlungsEintragMutation()
  const [pinFreieNotiz] = usePinFreieNotizMutation()

  const handleCreateNotiz = async (data: FreieNotizFormDto) => {
    try {
      await createFreieNotiz({ patientId, data }).unwrap()
      toast.success('Notiz erstellt')
      setNeueNotizOpen(false)
    } catch {
      toast.error('Fehler beim Erstellen der Notiz')
    }
  }

  const handleDeleteNotiz = async (eintragId: string) => {
    try {
      await deleteFreieNotiz({ eintragId, patientId }).unwrap()
      toast.success('Notiz gelöscht')
    } catch {
      toast.error('Fehler beim Löschen der Notiz')
    }
  }

  const handleUpdateBehandlungsNotiz = async (eintragId: string, inhalt: string) => {
    try {
      await updateBehandlungsNotiz({ eintragId, patientId, data: { inhalt } }).unwrap()
      toast.success('Notiz aktualisiert')
    } catch {
      toast.error('Fehler beim Aktualisieren der Notiz')
    }
  }

  const handleUpdateFreieNotiz = async (eintragId: string, inhalt: string) => {
    try {
      await updateFreieNotiz({ eintragId, patientId, data: { inhalt } }).unwrap()
      toast.success('Notiz aktualisiert')
    } catch {
      toast.error('Fehler beim Aktualisieren der Notiz')
    }
  }

  const handleTogglePinBehandlung = async (eintragId: string, istAngepinnt: boolean) => {
    try {
      await pinBehandlungsEintrag({
        eintragId,
        patientId,
        data: { istAngepinnt: !istAngepinnt },
      }).unwrap()
      toast.success(istAngepinnt ? 'Nicht mehr angepinnt' : 'Angepinnt')
    } catch {
      toast.error('Fehler beim Ändern des Pin-Status')
    }
  }

  const handleTogglePinFreieNotiz = async (eintragId: string, istAngepinnt: boolean) => {
    try {
      await pinFreieNotiz({ eintragId, patientId, data: { istAngepinnt: !istAngepinnt } }).unwrap()
      toast.success(istAngepinnt ? 'Nicht mehr angepinnt' : 'Angepinnt')
    } catch {
      toast.error('Fehler beim Ändern des Pin-Status')
    }
  }

  const getEintragDate = (eintrag: AktenEintragDto): Date => {
    if (isBehandlungsEintrag(eintrag)) {
      return new Date(eintrag.behandlungsDatum)
    }
    return new Date(eintrag.erstelltAm)
  }

  // Sort: pinned first, then by date descending
  const sortedEintraege = [...(akte?.eintraege ?? [])].sort((a, b) => {
    if (a.istAngepinnt !== b.istAngepinnt) {
      return a.istAngepinnt ? -1 : 1
    }
    return getEintragDate(b).getTime() - getEintragDate(a).getTime()
  })

  if (isLoading) {
    return (
      <Card>
        <CardHeader>
          <CardTitle>Behandlungsverlauf</CardTitle>
        </CardHeader>
        <CardContent>
          <p className="text-muted-foreground">Laden...</p>
        </CardContent>
      </Card>
    )
  }

  if (error) {
    return (
      <Card>
        <CardHeader>
          <CardTitle>Behandlungsverlauf</CardTitle>
        </CardHeader>
        <CardContent>
          <p className="text-destructive">Fehler beim Laden der Patientenakte</p>
        </CardContent>
      </Card>
    )
  }

  return (
    <>
      <Card>
        <CardHeader>
          <div className="flex items-center justify-between">
            <CardTitle>Behandlungsverlauf</CardTitle>
            <Button size="sm" onClick={() => setNeueNotizOpen(true)}>
              <Plus className="mr-1 h-4 w-4" />
              Neue Notiz
            </Button>
          </div>
        </CardHeader>
        <CardContent>
          {sortedEintraege.length === 0 ? (
            <p className="text-muted-foreground">Keine Einträge vorhanden</p>
          ) : (
            <div className="relative space-y-4">
              {/* Timeline line */}
              <div className="absolute left-4 top-0 h-full w-0.5 bg-border" />

              {sortedEintraege.map((eintrag) => (
                <div key={eintrag.id} className="relative pl-10">
                  {/* Timeline dot */}
                  <div
                    className={`absolute left-2.5 top-4 h-3 w-3 rounded-full border-2 ${
                      eintrag.istAngepinnt
                        ? 'border-primary bg-primary'
                        : 'border-muted-foreground bg-background'
                    }`}
                  />

                  {isBehandlungsEintrag(eintrag) ? (
                    <BehandlungsEintragCard
                      eintrag={eintrag}
                      onUpdateNotiz={(inhalt) => handleUpdateBehandlungsNotiz(eintrag.id, inhalt)}
                      onTogglePin={() =>
                        handleTogglePinBehandlung(eintrag.id, eintrag.istAngepinnt)
                      }
                    />
                  ) : isFreieNotiz(eintrag) ? (
                    <FreieNotizCard
                      notiz={eintrag}
                      onUpdate={(inhalt) => handleUpdateFreieNotiz(eintrag.id, inhalt)}
                      onDelete={() => handleDeleteNotiz(eintrag.id)}
                      onTogglePin={() =>
                        handleTogglePinFreieNotiz(eintrag.id, eintrag.istAngepinnt)
                      }
                    />
                  ) : null}
                </div>
              ))}
            </div>
          )}
        </CardContent>
      </Card>

      <NeueNotizDialog
        open={neueNotizOpen}
        onOpenChange={setNeueNotizOpen}
        onSubmit={handleCreateNotiz}
        isLoading={isCreating}
      />
    </>
  )
}
