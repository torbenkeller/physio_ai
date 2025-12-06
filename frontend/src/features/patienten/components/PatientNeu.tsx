import { useNavigate } from 'react-router-dom'
import { useCreatePatientMutation } from '../api/patientenApi'
import { PageHeader } from '@/shared/components/PageHeader'
import { PatientForm } from './PatientForm'
import { Button } from '@/shared/components/ui/button'
import { ArrowLeft } from 'lucide-react'
import { toast } from 'sonner'
import type { PatientFormDto } from '../types/patient.types'

export const PatientNeu = () => {
  const navigate = useNavigate()
  const [createPatient, { isLoading }] = useCreatePatientMutation()

  const handleSubmit = async (data: PatientFormDto) => {
    try {
      const patient = await createPatient(data).unwrap()
      toast.success('Patient erfolgreich angelegt')
      navigate(`/patienten/${patient.id}`)
    } catch {
      toast.error('Fehler beim Anlegen des Patienten')
    }
  }

  return (
    <div>
      <PageHeader
        title="Neuer Patient"
        description="Erfassen Sie die Stammdaten eines neuen Patienten"
        actions={
          <Button variant="outline" onClick={() => navigate('/patienten')}>
            <ArrowLeft className="mr-2 h-4 w-4" />
            Zurück
          </Button>
        }
      />
      <PatientForm onSubmit={handleSubmit} isLoading={isLoading} />
    </div>
  )
}
