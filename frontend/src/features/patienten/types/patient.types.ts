export interface PatientDto {
  id: string
  titel: string | null
  vorname: string
  nachname: string
  strasse: string | null
  hausnummer: string | null
  plz: string | null
  stadt: string | null
  telMobil: string | null
  telFestnetz: string | null
  email: string | null
  geburtstag: string | null
  behandlungenProRezept: number | null
}

export interface PatientFormDto {
  titel?: string | null
  vorname?: string | null
  nachname?: string | null
  strasse?: string | null
  hausnummer?: string | null
  plz?: string | null
  stadt?: string | null
  telMobil?: string | null
  telFestnetz?: string | null
  email?: string | null
  geburtstag?: string | null
  behandlungenProRezept?: number | null
}

export interface PatientSummaryDto {
  id: string
  name: string
  birthday: string | null
  behandlungenProRezept: number | null
}
