import type { PatientDto } from '@/features/patienten/types/patient.types'

export interface BehandlungsartDto {
  id: string
  name: string
  preis: number
}

export interface ArztDto {
  id: string
  name: string
}

export interface RechnungDto {
  id: string
  rechnungsnummer: string
  status: RezeptRechnungStatus
}

export const RezeptRechnungStatus = {
  ERSTELLT: 'ERSTELLT',
  OFFEN: 'OFFEN',
  BEZAHLT: 'BEZAHLT',
} as const

export type RezeptRechnungStatus = typeof RezeptRechnungStatus[keyof typeof RezeptRechnungStatus]

export interface RezeptPosDto {
  behandlungsart: BehandlungsartDto
  anzahl: number
}

export interface RezeptDto {
  id: string
  patient: PatientDto
  ausgestelltAm: string
  ausgestelltVon: ArztDto | null
  preisGesamt: number
  rechnung: RechnungDto | null
  positionen: RezeptPosDto[]
}

export interface RezeptPosCreateDto {
  behandlungsartId: string
  anzahl: number
}

export interface RezeptCreateDto {
  patientId: string
  ausgestelltAm: string
  positionen: RezeptPosCreateDto[]
}

export interface RezeptUpdateDto {
  patientId: string
  ausgestelltAm: string
  positionen: RezeptPosCreateDto[]
}

// KI-Erkennungs-DTOs
export interface EingelesenerPatientDto {
  titel: string | null
  vorname: string
  nachname: string
  strasse: string
  hausnummer: string
  postleitzahl: string
  stadt: string
  geburtstag: string
}

export interface EingelesenesRezeptPosDto {
  anzahl: number
  behandlungsart: BehandlungsartDto
}

export interface EingelesenesRezeptDto {
  ausgestelltAm: string
  rezeptpositionen: EingelesenesRezeptPosDto[]
}

export interface RezeptEinlesenResponse {
  existingPatient: PatientDto | null
  patient: EingelesenerPatientDto
  rezept: EingelesenesRezeptDto
}
