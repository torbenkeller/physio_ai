export interface ProfileDto {
  id: string
  praxisName: string
  inhaberName: string
  profilePictureUrl: string | null
  calenderUrl: string
  defaultBehandlungenProRezept: number
  externalCalendarUrl: string | null
}

export interface ProfileFormDto {
  praxisName: string
  inhaberName: string
  profilePictureUrl?: string | null
  defaultBehandlungenProRezept?: number
  externalCalendarUrl?: string | null
}

export interface ExternalCalendarEventDto {
  id: string
  title: string
  startZeit: string
  endZeit: string
  isAllDay: boolean
}
