export interface ProfileDto {
  id: string
  praxisName: string
  inhaberName: string
  profilePictureUrl: string | null
  calenderUrl: string
  defaultBehandlungenProRezept: number
}

export interface ProfileFormDto {
  praxisName: string
  inhaberName: string
  profilePictureUrl?: string | null
  defaultBehandlungenProRezept?: number
}
