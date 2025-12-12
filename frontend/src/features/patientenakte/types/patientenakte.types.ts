// Response DTOs

export interface PatientenakteDto {
  patientId: string
  eintraege: AktenEintragDto[]
}

export type AktenEintragDto = BehandlungsEintragDto | FreieNotizDto

export interface BehandlungsEintragDto {
  id: string
  typ: 'BEHANDLUNG'
  behandlungId: string
  behandlungsDatum: string
  notiz: NotizDto | null
  istAngepinnt: boolean
  erstelltAm: string
}

export interface FreieNotizDto {
  id: string
  typ: 'FREIE_NOTIZ'
  kategorie: NotizKategorie
  inhalt: string
  aktualisiertAm: string | null
  istAngepinnt: boolean
  erstelltAm: string
}

export interface NotizDto {
  inhalt: string
  erstelltAm: string
  aktualisiertAm: string | null
}

// Request DTOs

export interface FreieNotizFormDto {
  kategorie: NotizKategorie
  inhalt: string
}

export interface NotizUpdateDto {
  inhalt: string
}

export interface PinUpdateDto {
  istAngepinnt: boolean
}

// Enums

export type NotizKategorie = 'DIAGNOSE' | 'BEOBACHTUNG' | 'SONSTIGES'

// Type Guards

export function isBehandlungsEintrag(eintrag: AktenEintragDto): eintrag is BehandlungsEintragDto {
  return eintrag.typ === 'BEHANDLUNG'
}

export function isFreieNotiz(eintrag: AktenEintragDto): eintrag is FreieNotizDto {
  return eintrag.typ === 'FREIE_NOTIZ'
}
