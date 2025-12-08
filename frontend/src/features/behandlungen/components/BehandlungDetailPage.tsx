import { useState, useEffect, useRef, useCallback } from 'react'
import { useParams, useNavigate, Link } from 'react-router-dom'
import { toast } from 'sonner'
import { ArrowLeft, Pencil, Trash2, Undo2, ExternalLink } from 'lucide-react'
import { Button } from '@/shared/components/ui/button'
import { Label } from '@/shared/components/ui/label'
import { Separator } from '@/shared/components/ui/separator'
import { useGetBehandlungQuery, useUpdateBemerkungMutation } from '../api/behandlungenApi'
import { useGetBehandlungsartenQuery } from '@/features/rezepte/api/rezepteApi'
import { useGetPatientQuery } from '@/features/patienten/api/patientenApi'
import { DeleteBehandlungDialog } from './DeleteBehandlungDialog'
import { BehandlungEditDialog } from './BehandlungEditDialog'
import type { BehandlungKalenderDto } from '../types/behandlung.types'

const DEBOUNCE_DELAY = 500

export const BehandlungDetailPage = () => {
  const { id } = useParams<{ id: string }>()
  const navigate = useNavigate()

  // Fetch data
  const { data: behandlung, isLoading, error } = useGetBehandlungQuery(id || '', { skip: !id })
  const { data: behandlungsarten } = useGetBehandlungsartenQuery()
  const { data: patient } = useGetPatientQuery(behandlung?.patientId || '', {
    skip: !behandlung?.patientId,
  })

  const [updateBemerkung] = useUpdateBemerkungMutation()

  // Local bemerkung state for editing
  const [bemerkung, setBemerkung] = useState('')
  const [originalBemerkung, setOriginalBemerkung] = useState('')
  const [hasChanges, setHasChanges] = useState(false)
  const [isSaving, setIsSaving] = useState(false)

  // Dialog states
  const [showDeleteDialog, setShowDeleteDialog] = useState(false)
  const [showEditDialog, setShowEditDialog] = useState(false)

  // Debounce timer ref
  const debounceTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null)

  // Initialize bemerkung state when behandlung loads
  useEffect(() => {
    if (behandlung) {
      setBemerkung(behandlung.bemerkung || '')
      setOriginalBemerkung(behandlung.bemerkung || '')
      setHasChanges(false)
    }
  }, [behandlung])

  // Cleanup debounce timer on unmount
  useEffect(() => {
    return () => {
      if (debounceTimerRef.current) {
        clearTimeout(debounceTimerRef.current)
      }
    }
  }, [])

  const saveBemerkung = useCallback(
    async (value: string) => {
      if (!id) return
      setIsSaving(true)
      try {
        await updateBemerkung({
          id,
          data: { bemerkung: value || null },
        }).unwrap()
        setOriginalBemerkung(value)
        setHasChanges(false)
      } catch {
        toast.error('Bemerkung konnte nicht gespeichert werden')
      } finally {
        setIsSaving(false)
      }
    },
    [id, updateBemerkung]
  )

  const handleBemerkungChange = (e: React.ChangeEvent<HTMLTextAreaElement>) => {
    const newValue = e.target.value
    setBemerkung(newValue)
    setHasChanges(newValue !== originalBemerkung)

    // Clear existing timer
    if (debounceTimerRef.current) {
      clearTimeout(debounceTimerRef.current)
    }

    // Set new timer for auto-save
    debounceTimerRef.current = setTimeout(() => {
      if (newValue !== originalBemerkung) {
        saveBemerkung(newValue)
      }
    }, DEBOUNCE_DELAY)
  }

  const handleUndo = () => {
    // Cancel pending save
    if (debounceTimerRef.current) {
      clearTimeout(debounceTimerRef.current)
    }
    setBemerkung(originalBemerkung)
    setHasChanges(false)
  }

  const handleBack = () => {
    navigate('/kalender')
  }

  const handleDeleteSuccess = () => {
    navigate('/kalender')
  }

  if (isLoading) {
    return (
      <div className="flex h-full items-center justify-center">
        <p className="text-muted-foreground">Laden...</p>
      </div>
    )
  }

  if (error || !behandlung) {
    return (
      <div className="flex h-full flex-col items-center justify-center gap-4">
        <p className="text-muted-foreground">Termin nicht gefunden</p>
        <Button variant="outline" onClick={handleBack}>
          Zurück zum Kalender
        </Button>
      </div>
    )
  }

  // Format date and time
  const startDate = new Date(behandlung.startZeit)
  const endDate = new Date(behandlung.endZeit)
  const formattedDate = startDate.toLocaleDateString('de-DE', {
    weekday: 'long',
    day: '2-digit',
    month: 'long',
    year: 'numeric',
  })
  const formattedTime = `${startDate.toLocaleTimeString('de-DE', {
    hour: '2-digit',
    minute: '2-digit',
  })} - ${endDate.toLocaleTimeString('de-DE', {
    hour: '2-digit',
    minute: '2-digit',
  })} Uhr`

  // Get behandlungsart name
  const behandlungsart = behandlungsarten?.find((b) => b.id === behandlung.behandlungsartId)

  const patientFullName = patient ? `${patient.vorname} ${patient.nachname}` : 'Patient'

  // Create a BehandlungKalenderDto for the dialogs
  const behandlungKalender: BehandlungKalenderDto = {
    id: behandlung.id,
    startZeit: behandlung.startZeit,
    endZeit: behandlung.endZeit,
    rezeptId: behandlung.rezeptId,
    behandlungsartId: behandlung.behandlungsartId,
    bemerkung: behandlung.bemerkung,
    patient: {
      id: patient?.id || behandlung.patientId,
      name: patientFullName,
      birthday: patient?.geburtstag || null,
      behandlungenProRezept: patient?.behandlungenProRezept || null,
    },
  }

  return (
    <div className="flex flex-col h-full">
      {/* Header */}
      <div className="flex items-center gap-2 p-4 border-b">
        <Button variant="ghost" size="icon" onClick={handleBack}>
          <ArrowLeft className="h-5 w-5" />
        </Button>
        <h1 className="font-semibold text-lg">Termindetails</h1>
      </div>

      {/* Content */}
      <div className="flex-1 overflow-auto p-4">
        <div className="space-y-6 max-w-lg mx-auto">
          {/* Patient */}
          <div>
            <Link
              to={`/patienten/${behandlung.patientId}`}
              className="group inline-flex items-center gap-2 font-semibold text-xl hover:text-primary transition-colors"
            >
              {patientFullName}
              <ExternalLink className="h-4 w-4 opacity-0 group-hover:opacity-100 transition-opacity" />
            </Link>
          </div>

          {/* Date and Time */}
          <div className="space-y-1">
            <p className="text-base">{formattedDate}</p>
            <p className="text-base text-muted-foreground">{formattedTime}</p>
          </div>

          {/* Behandlungsart */}
          {behandlungsart && (
            <div className="space-y-1">
              <Label className="text-sm text-muted-foreground">Behandlungsart</Label>
              <p className="text-base">{behandlungsart.name}</p>
            </div>
          )}

          {/* Rezept Link */}
          {behandlung.rezeptId && (
            <div className="space-y-1">
              <Label className="text-sm text-muted-foreground">Rezept</Label>
              <Link
                to={`/rezepte/${behandlung.rezeptId}`}
                className="group inline-flex items-center gap-2 text-base hover:text-primary transition-colors"
              >
                Rezept anzeigen
                <ExternalLink className="h-4 w-4 opacity-0 group-hover:opacity-100 transition-opacity" />
              </Link>
            </div>
          )}

          <Separator />

          {/* Bemerkung */}
          <div className="space-y-2">
            <div className="flex items-center justify-between">
              <Label className="text-sm text-muted-foreground">Bemerkung</Label>
              {hasChanges && (
                <Button variant="ghost" size="sm" className="h-8 px-3" onClick={handleUndo}>
                  <Undo2 className="h-4 w-4 mr-1.5" />
                  Rückgängig
                </Button>
              )}
            </div>
            <textarea
              value={bemerkung}
              onChange={handleBemerkungChange}
              placeholder="Bemerkung hinzufügen..."
              className="flex min-h-[120px] w-full rounded-md border border-input bg-background px-3 py-2 text-base ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 resize-none"
            />
            {isSaving && <p className="text-sm text-muted-foreground">Wird gespeichert...</p>}
          </div>
        </div>
      </div>

      {/* Footer with Actions */}
      <div className="p-4 border-t">
        <div className="flex gap-3 max-w-lg mx-auto">
          <Button variant="outline" className="flex-1" onClick={() => setShowEditDialog(true)}>
            <Pencil className="h-4 w-4 mr-2" />
            Bearbeiten
          </Button>
          <Button
            variant="outline"
            className="text-destructive hover:text-destructive hover:bg-destructive/10"
            onClick={() => setShowDeleteDialog(true)}
          >
            <Trash2 className="h-4 w-4 mr-2" />
            Löschen
          </Button>
        </div>
      </div>

      {/* Delete Dialog */}
      <DeleteBehandlungDialog
        open={showDeleteDialog}
        onOpenChange={setShowDeleteDialog}
        behandlungId={behandlung.id}
        patientName={patientFullName}
        startZeit={behandlung.startZeit}
        onSuccess={handleDeleteSuccess}
      />

      {/* Edit Dialog */}
      <BehandlungEditDialog
        open={showEditDialog}
        onOpenChange={setShowEditDialog}
        behandlung={behandlungKalender}
        behandlungsarten={behandlungsarten}
      />
    </div>
  )
}
