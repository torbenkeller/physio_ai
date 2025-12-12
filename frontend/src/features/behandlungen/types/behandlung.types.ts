import type { PatientSummaryDto } from '@/features/patienten/types/patient.types'
import type { ExternalCalendarEventDto } from '@/features/profil/types/profil.types'

export interface BehandlungDto {
  id: string
  patientId: string
  startZeit: string
  endZeit: string
  rezeptId: string | null
  behandlungsartId: string | null
  bemerkung: string | null
}

export interface BehandlungFormDto {
  patientId: string
  startZeit: string
  endZeit: string
  rezeptId?: string | null
  behandlungsartId?: string | null
  bemerkung?: string | null
}

export interface BehandlungKalenderDto {
  id: string
  startZeit: string
  endZeit: string
  rezeptId: string | null
  behandlungsartId: string | null
  bemerkung: string | null
  patient: PatientSummaryDto
}

export interface UpdateBemerkungDto {
  bemerkung: string | null
}

export interface VerschiebeBehandlungDto {
  nach: string
}

export interface WeeklyCalendarResponse {
  behandlungen: Record<string, BehandlungKalenderDto[]>
  externeTermine: ExternalCalendarEventDto[]
}

// Multi-Termin-Erstellung
export interface SelectedTimeSlot {
  id: string // Temporäre Client-ID für UI
  date: Date
  startZeit: string // HH:mm Format
  endZeit: string // HH:mm Format
  hasConflict?: boolean
  conflictingWith?: ConflictingBehandlung[]
}

export type SeriesPattern = 'weekly' | 'biweekly' | 'monthly' | 'twice-weekly'

// Wochentag mit individueller Startzeit
export interface DayTimeConfig {
  dayIndex: number // 0=Mo, 1=Di, ... 6=So
  startZeit: string // HH:mm Format
}

// Flexible Serie-Konfiguration
export interface SeriesConfig {
  repeatEveryWeeks: number // Wiederholung alle X Wochen
  selectedDays: number[] // Ausgewählte Wochentage (0=Mo, 1=Di, ... 6=So) - Rückwärtskompatibilität
  dayTimeConfigs?: DayTimeConfig[] // Wochentage mit individueller Startzeit
}

// Konflikt-Prüfung
export interface TimeSlotCheckDto {
  startZeit: string // ISO DateTime Format
  endZeit: string // ISO DateTime Format
}

export interface ConflictCheckRequest {
  slots: TimeSlotCheckDto[]
}

export interface ConflictingBehandlung {
  id: string
  startZeit: string
  endZeit: string
  patientName: string
}

export interface ConflictResult {
  slotIndex: number
  hasConflict: boolean
  conflictingBehandlungen: ConflictingBehandlung[]
}
