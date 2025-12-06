import { useState, useCallback } from 'react'
import { useNavigate } from 'react-router-dom'
import { useUploadRezeptImageMutation, useCreateRezeptMutation } from '../api/rezepteApi'
import { useCreatePatientMutation } from '@/features/patienten/api/patientenApi'
import { PageHeader } from '@/shared/components/PageHeader'
import { Button } from '@/shared/components/ui/button'
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/shared/components/ui/card'
import { Input } from '@/shared/components/ui/input'
import { Label } from '@/shared/components/ui/label'
import { Separator } from '@/shared/components/ui/separator'
import { ArrowLeft, Upload, Loader2, Check, AlertCircle, User, FileText } from 'lucide-react'
import { toast } from 'sonner'
import type { RezeptEinlesenResponse } from '../types/rezept.types'

type UploadState = 'idle' | 'uploading' | 'processing' | 'success' | 'error'

export const RezeptUpload = () => {
  const navigate = useNavigate()
  const [uploadState, setUploadState] = useState<UploadState>('idle')
  const [selectedFile, setSelectedFile] = useState<File | null>(null)
  const [previewUrl, setPreviewUrl] = useState<string | null>(null)
  const [extractedData, setExtractedData] = useState<RezeptEinlesenResponse | null>(null)
  const [error, setError] = useState<string | null>(null)

  const [uploadRezeptImage] = useUploadRezeptImageMutation()
  const [createPatient] = useCreatePatientMutation()
  const [createRezept] = useCreateRezeptMutation()

  const handleFileSelect = useCallback((event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0]
    if (!file) return

    // Validate file type
    const validTypes = ['image/jpeg', 'image/png', 'application/pdf']
    if (!validTypes.includes(file.type)) {
      toast.error('Bitte wählen Sie eine JPEG, PNG oder PDF Datei')
      return
    }

    setSelectedFile(file)
    setExtractedData(null)
    setError(null)

    // Create preview for images
    if (file.type.startsWith('image/')) {
      const url = URL.createObjectURL(file)
      setPreviewUrl(url)
    } else {
      setPreviewUrl(null)
    }
  }, [])

  const handleUpload = async () => {
    if (!selectedFile) return

    setUploadState('uploading')
    setError(null)

    try {
      const formData = new FormData()
      formData.append('file', selectedFile)

      setUploadState('processing')
      const result = await uploadRezeptImage(formData).unwrap()

      if (result) {
        setExtractedData(result)
        setUploadState('success')
        toast.success('Rezept erfolgreich analysiert')
      } else {
        setUploadState('error')
        setError('Keine Daten konnten aus dem Rezept extrahiert werden')
      }
    } catch {
      setUploadState('error')
      setError('Fehler beim Hochladen des Rezepts')
      toast.error('Fehler beim Hochladen')
    }
  }

  const handleSaveRezept = async () => {
    if (!extractedData) return

    try {
      let patientId: string

      // Use existing patient or create new one
      if (extractedData.existingPatient) {
        patientId = extractedData.existingPatient.id
      } else {
        const newPatient = await createPatient({
          titel: extractedData.patient.titel,
          vorname: extractedData.patient.vorname,
          nachname: extractedData.patient.nachname,
          strasse: extractedData.patient.strasse,
          hausnummer: extractedData.patient.hausnummer,
          plz: extractedData.patient.postleitzahl,
          stadt: extractedData.patient.stadt,
          geburtstag: extractedData.patient.geburtstag,
        }).unwrap()
        patientId = newPatient.id
        toast.success('Neuer Patient angelegt')
      }

      // Create rezept
      const rezept = await createRezept({
        patientId,
        ausgestelltAm: extractedData.rezept.ausgestelltAm,
        positionen: extractedData.rezept.rezeptpositionen.map((pos) => ({
          behandlungsartId: pos.behandlungsart.id,
          anzahl: pos.anzahl,
        })),
      }).unwrap()

      toast.success('Rezept erfolgreich erstellt')
      navigate(`/rezepte/${rezept.id}`)
    } catch {
      toast.error('Fehler beim Speichern des Rezepts')
    }
  }

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('de-DE')
  }

  return (
    <div>
      <PageHeader
        title="Rezept hochladen"
        description="Laden Sie ein Rezeptbild hoch, um die Daten automatisch zu erfassen"
        actions={
          <Button variant="outline" onClick={() => navigate('/rezepte')}>
            <ArrowLeft className="mr-2 h-4 w-4" />
            Zurück
          </Button>
        }
      />

      <div className="grid gap-6 lg:grid-cols-2">
        {/* Upload Bereich */}
        <Card>
          <CardHeader>
            <CardTitle>Rezept Bild</CardTitle>
            <CardDescription>
              Unterstützte Formate: JPEG, PNG, PDF
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="flex items-center gap-4">
              <Input
                type="file"
                accept="image/jpeg,image/png,application/pdf"
                onChange={handleFileSelect}
                className="flex-1"
              />
            </div>

            {previewUrl && (
              <div className="mt-4 overflow-hidden rounded-lg border">
                <img
                  src={previewUrl}
                  alt="Rezept Vorschau"
                  className="max-h-[400px] w-full object-contain"
                />
              </div>
            )}

            {selectedFile && !previewUrl && (
              <div className="mt-4 rounded-lg border p-4 text-center">
                <FileText className="mx-auto h-12 w-12 text-muted-foreground" />
                <p className="mt-2 text-sm">{selectedFile.name}</p>
              </div>
            )}

            <Button
              onClick={handleUpload}
              disabled={!selectedFile || uploadState === 'uploading' || uploadState === 'processing'}
              className="w-full"
            >
              {uploadState === 'uploading' || uploadState === 'processing' ? (
                <>
                  <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                  {uploadState === 'uploading' ? 'Wird hochgeladen...' : 'Wird analysiert...'}
                </>
              ) : (
                <>
                  <Upload className="mr-2 h-4 w-4" />
                  Rezept analysieren
                </>
              )}
            </Button>

            {error && (
              <div className="rounded-lg bg-destructive/10 p-4 text-destructive">
                <div className="flex items-center gap-2">
                  <AlertCircle className="h-5 w-5" />
                  <span>{error}</span>
                </div>
              </div>
            )}
          </CardContent>
        </Card>

        {/* Extrahierte Daten */}
        {extractedData && (
          <div className="space-y-6">
            {/* Patient */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <User className="h-5 w-5" />
                  Patient
                  {extractedData.existingPatient && (
                    <span className="rounded bg-green-100 px-2 py-1 text-xs text-green-700">
                      Bestehender Patient
                    </span>
                  )}
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="grid gap-4 md:grid-cols-2">
                  <div>
                    <Label className="text-muted-foreground">Name</Label>
                    <p className="font-medium">
                      {extractedData.patient.titel && `${extractedData.patient.titel} `}
                      {extractedData.patient.vorname} {extractedData.patient.nachname}
                    </p>
                  </div>
                  <div>
                    <Label className="text-muted-foreground">Geburtsdatum</Label>
                    <p className="font-medium">{formatDate(extractedData.patient.geburtstag)}</p>
                  </div>
                  <div className="md:col-span-2">
                    <Label className="text-muted-foreground">Adresse</Label>
                    <p className="font-medium">
                      {extractedData.patient.strasse} {extractedData.patient.hausnummer},
                      {' '}{extractedData.patient.postleitzahl} {extractedData.patient.stadt}
                    </p>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* Rezept Daten */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <FileText className="h-5 w-5" />
                  Rezept Daten
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="space-y-4">
                  <div>
                    <Label className="text-muted-foreground">Ausgestellt am</Label>
                    <p className="font-medium">{formatDate(extractedData.rezept.ausgestelltAm)}</p>
                  </div>
                  <Separator />
                  <div>
                    <Label className="text-muted-foreground">Behandlungen</Label>
                    <div className="mt-2 space-y-2">
                      {extractedData.rezept.rezeptpositionen.map((pos, index) => (
                        <div
                          key={index}
                          className="flex items-center justify-between rounded-lg border p-3"
                        >
                          <span>{pos.behandlungsart.name}</span>
                          <span className="font-medium">{pos.anzahl}x</span>
                        </div>
                      ))}
                    </div>
                  </div>
                </div>
              </CardContent>
            </Card>

            <Button onClick={handleSaveRezept} className="w-full" size="lg">
              <Check className="mr-2 h-4 w-4" />
              Rezept speichern
            </Button>
          </div>
        )}
      </div>
    </div>
  )
}
