import { useState } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { useGetPatientQuery, useUpdatePatientMutation } from '../api/patientenApi'
import { BehandlungsverlaufTimeline } from '@/features/patientenakte'
import { PageHeader } from '@/shared/components/PageHeader'
import { PatientForm } from './PatientForm'
import { Button } from '@/shared/components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '@/shared/components/ui/card'
import { ArrowLeft, Edit, X } from 'lucide-react'
import { toast } from 'sonner'
import type { PatientFormDto } from '../types/patient.types'

export const PatientDetail = () => {
  const { id } = useParams<{ id: string }>()
  const navigate = useNavigate()
  const [isEditing, setIsEditing] = useState(false)

  const { data: patient, isLoading, error } = useGetPatientQuery(id!)
  const [updatePatient, { isLoading: isUpdating }] = useUpdatePatientMutation()

  const handleUpdate = async (data: PatientFormDto) => {
    try {
      await updatePatient({ id: id!, data }).unwrap()
      toast.success('Patient erfolgreich aktualisiert')
      setIsEditing(false)
    } catch {
      toast.error('Fehler beim Aktualisieren des Patienten')
    }
  }

  const formatDate = (dateString: string | null) => {
    if (!dateString) return '-'
    return new Date(dateString).toLocaleDateString('de-DE')
  }

  if (isLoading) {
    return (
      <div className="flex h-64 items-center justify-center">
        <div className="text-muted-foreground">Laden...</div>
      </div>
    )
  }

  if (error || !patient) {
    return (
      <div className="flex h-64 items-center justify-center">
        <div className="text-destructive">Patient nicht gefunden</div>
      </div>
    )
  }

  const patientName = `${patient.titel ? patient.titel + ' ' : ''}${patient.vorname} ${patient.nachname}`

  return (
    <div>
      <PageHeader
        title={patientName}
        description={patient.geburtstag ? `Geb. ${formatDate(patient.geburtstag)}` : undefined}
        actions={
          <div className="flex items-center gap-2">
            {isEditing ? (
              <Button variant="outline" onClick={() => setIsEditing(false)}>
                <X className="mr-2 h-4 w-4" />
                Abbrechen
              </Button>
            ) : (
              <Button variant="outline" onClick={() => setIsEditing(true)}>
                <Edit className="mr-2 h-4 w-4" />
                Bearbeiten
              </Button>
            )}
            <Button variant="outline" onClick={() => navigate('/patienten')}>
              <ArrowLeft className="mr-2 h-4 w-4" />
              Zurück
            </Button>
          </div>
        }
      />

      {isEditing ? (
        <PatientForm patient={patient} onSubmit={handleUpdate} isLoading={isUpdating} />
      ) : (
        <div className="space-y-6">
          {/* Stammdaten */}
          <div className="grid gap-6 md:grid-cols-2">
            <Card>
              <CardHeader>
                <CardTitle>Kontaktdaten</CardTitle>
              </CardHeader>
              <CardContent className="space-y-2">
                {patient.telMobil && (
                  <div>
                    <span className="text-muted-foreground">Mobil:</span>{' '}
                    <a href={`tel:${patient.telMobil}`} className="text-primary hover:underline">
                      {patient.telMobil}
                    </a>
                  </div>
                )}
                {patient.telFestnetz && (
                  <div>
                    <span className="text-muted-foreground">Festnetz:</span>{' '}
                    <a href={`tel:${patient.telFestnetz}`} className="text-primary hover:underline">
                      {patient.telFestnetz}
                    </a>
                  </div>
                )}
                {patient.email && (
                  <div>
                    <span className="text-muted-foreground">E-Mail:</span>{' '}
                    <a href={`mailto:${patient.email}`} className="text-primary hover:underline">
                      {patient.email}
                    </a>
                  </div>
                )}
                {!patient.telMobil && !patient.telFestnetz && !patient.email && (
                  <p className="text-muted-foreground">Keine Kontaktdaten hinterlegt</p>
                )}
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle>Adresse</CardTitle>
              </CardHeader>
              <CardContent>
                {patient.strasse || patient.stadt ? (
                  <address className="not-italic">
                    {patient.strasse && patient.hausnummer && (
                      <div>
                        {patient.strasse} {patient.hausnummer}
                      </div>
                    )}
                    {patient.plz && patient.stadt && (
                      <div>
                        {patient.plz} {patient.stadt}
                      </div>
                    )}
                  </address>
                ) : (
                  <p className="text-muted-foreground">Keine Adresse hinterlegt</p>
                )}
              </CardContent>
            </Card>
          </div>

          {/* Behandlungsverlauf */}
          <BehandlungsverlaufTimeline patientId={id!} />
        </div>
      )}
    </div>
  )
}
