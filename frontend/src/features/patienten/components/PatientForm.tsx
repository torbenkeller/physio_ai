import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import { Button } from '@/shared/components/ui/button'
import { Input } from '@/shared/components/ui/input'
import { Label } from '@/shared/components/ui/label'
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/shared/components/ui/card'
import type { PatientDto, PatientFormDto } from '../types/patient.types'
import { useGetProfileQuery } from '@/features/profil/api/profileApi'

const patientSchema = z.object({
  titel: z.string().optional().nullable(),
  vorname: z.string().min(1, 'Vorname ist erforderlich'),
  nachname: z.string().min(1, 'Nachname ist erforderlich'),
  strasse: z.string().optional().nullable(),
  hausnummer: z.string().optional().nullable(),
  plz: z.string().optional().nullable(),
  stadt: z.string().optional().nullable(),
  telMobil: z.string().optional().nullable(),
  telFestnetz: z.string().optional().nullable(),
  email: z.string().email('Ungültige E-Mail-Adresse').optional().nullable().or(z.literal('')),
  geburtstag: z.string().optional().nullable(),
  behandlungenProRezept: z.number().min(1).max(20).optional().nullable(),
})

type PatientFormValues = z.infer<typeof patientSchema>

interface PatientFormProps {
  patient?: PatientDto
  onSubmit: (data: PatientFormDto) => Promise<void>
  isLoading?: boolean
}

export const PatientForm = ({ patient, onSubmit, isLoading }: PatientFormProps) => {
  const { data: profile } = useGetProfileQuery()

  const {
    register,
    handleSubmit,
    formState: { errors },
    watch,
  } = useForm<PatientFormValues>({
    resolver: zodResolver(patientSchema),
    defaultValues: {
      titel: patient?.titel || '',
      vorname: patient?.vorname || '',
      nachname: patient?.nachname || '',
      strasse: patient?.strasse || '',
      hausnummer: patient?.hausnummer || '',
      plz: patient?.plz || '',
      stadt: patient?.stadt || '',
      telMobil: patient?.telMobil || '',
      telFestnetz: patient?.telFestnetz || '',
      email: patient?.email || '',
      geburtstag: patient?.geburtstag || '',
      behandlungenProRezept: patient?.behandlungenProRezept ?? null,
    },
  })

  const behandlungenProRezept = watch('behandlungenProRezept')

  const handleFormSubmit = async (data: PatientFormValues) => {
    const formData: PatientFormDto = {
      ...data,
      email: data.email || null,
      geburtstag: data.geburtstag || null,
    }
    await onSubmit(formData)
  }

  return (
    <form onSubmit={handleSubmit(handleFormSubmit)} className="space-y-6">
      <Card>
        <CardHeader>
          <CardTitle>Persönliche Daten</CardTitle>
        </CardHeader>
        <CardContent className="grid gap-4 md:grid-cols-2">
          <div className="space-y-2">
            <Label htmlFor="titel">Titel</Label>
            <Input id="titel" placeholder="z.B. Dr., Prof." {...register('titel')} />
          </div>
          <div className="space-y-2">
            <Label htmlFor="geburtstag">Geburtsdatum</Label>
            <Input id="geburtstag" type="date" {...register('geburtstag')} />
            {errors.geburtstag && (
              <p className="text-sm text-destructive">{errors.geburtstag.message}</p>
            )}
          </div>
          <div className="space-y-2">
            <Label htmlFor="vorname">Vorname *</Label>
            <Input id="vorname" {...register('vorname')} />
            {errors.vorname && (
              <p className="text-sm text-destructive">{errors.vorname.message}</p>
            )}
          </div>
          <div className="space-y-2">
            <Label htmlFor="nachname">Nachname *</Label>
            <Input id="nachname" {...register('nachname')} />
            {errors.nachname && (
              <p className="text-sm text-destructive">{errors.nachname.message}</p>
            )}
          </div>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>Adresse</CardTitle>
        </CardHeader>
        <CardContent className="grid gap-4 md:grid-cols-2">
          <div className="space-y-2">
            <Label htmlFor="strasse">Straße</Label>
            <Input id="strasse" {...register('strasse')} />
          </div>
          <div className="space-y-2">
            <Label htmlFor="hausnummer">Hausnummer</Label>
            <Input id="hausnummer" {...register('hausnummer')} />
          </div>
          <div className="space-y-2">
            <Label htmlFor="plz">PLZ</Label>
            <Input id="plz" {...register('plz')} />
          </div>
          <div className="space-y-2">
            <Label htmlFor="stadt">Stadt</Label>
            <Input id="stadt" {...register('stadt')} />
          </div>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>Kontakt</CardTitle>
        </CardHeader>
        <CardContent className="grid gap-4 md:grid-cols-2">
          <div className="space-y-2">
            <Label htmlFor="telMobil">Telefon (Mobil)</Label>
            <Input id="telMobil" type="tel" {...register('telMobil')} />
          </div>
          <div className="space-y-2">
            <Label htmlFor="telFestnetz">Telefon (Festnetz)</Label>
            <Input id="telFestnetz" type="tel" {...register('telFestnetz')} />
          </div>
          <div className="space-y-2 md:col-span-2">
            <Label htmlFor="email">E-Mail</Label>
            <Input id="email" type="email" {...register('email')} />
            {errors.email && (
              <p className="text-sm text-destructive">{errors.email.message}</p>
            )}
          </div>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>Behandlungseinstellungen</CardTitle>
          <CardDescription>
            Individuelle Einstellungen für diesen Patienten
          </CardDescription>
        </CardHeader>
        <CardContent>
          <div className="space-y-2">
            <Label htmlFor="behandlungenProRezept">Behandlungen pro Rezept</Label>
            <Input
              id="behandlungenProRezept"
              type="number"
              min={1}
              max={20}
              placeholder={profile?.defaultBehandlungenProRezept?.toString() ?? '8'}
              {...register('behandlungenProRezept', {
                setValueAs: (v) => (v === '' || v === null ? null : parseInt(v, 10)),
              })}
            />
            <p className="text-sm text-muted-foreground">
              {behandlungenProRezept === null || behandlungenProRezept === undefined
                ? `Standard: ${profile?.defaultBehandlungenProRezept ?? 8} (aus Profil-Einstellungen)`
                : 'Individuelle Einstellung für diesen Patienten'}
            </p>
          </div>
        </CardContent>
      </Card>

      <div className="flex justify-end">
        <Button type="submit" disabled={isLoading}>
          {isLoading ? 'Speichern...' : 'Speichern'}
        </Button>
      </div>
    </form>
  )
}
