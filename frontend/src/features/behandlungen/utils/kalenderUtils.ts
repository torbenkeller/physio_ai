// Kalender-Konfiguration
export const HOUR_HEIGHT = 60 // Pixel pro Stunde

// Farb-Konstanten für Terminplanung

// Muster-Previews (blau, gestrichelt)
export const PATTERN_COLORS = {
  bg: 'bg-blue-500/60',
  border: 'border-blue-500',
  text: 'text-blue-50',
} as const

// Konkrete Slots (grün, durchgezogen)
export const SLOT_COLORS = {
  bg: 'bg-emerald-500/80',
  border: 'border-emerald-600',
  text: 'text-white',
} as const

// Konflikt-Slots (amber)
export const CONFLICT_COLORS = {
  bg: 'bg-amber-500/80',
  border: 'border-amber-600',
  text: 'text-white',
} as const

export const WEEKDAY_NAMES_SHORT = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'] as const

// Zeit addieren (HH:mm + Minuten → HH:mm)
export const addMinutesToTime = (time: string, minutes: number): string => {
  const [h, m] = time.split(':').map(Number)
  const totalMinutes = h * 60 + m + minutes
  const newH = Math.floor(totalMinutes / 60) % 24
  const newM = totalMinutes % 60
  return `${String(newH).padStart(2, '0')}:${String(newM).padStart(2, '0')}`
}
export const TOTAL_HOURS = 24
export const TOTAL_HEIGHT = TOTAL_HOURS * HOUR_HEIGHT
export const DEFAULT_SCROLL_HOUR = 8 // Beim Öffnen zu 8 Uhr scrollen
export const DAYS = ['Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag']

// Wochenstart berechnen (Montag)
export const getWeekStart = (date: Date): Date => {
  const d = new Date(date)
  const day = d.getDay()
  const diff = d.getDate() - day + (day === 0 ? -6 : 1)
  d.setDate(diff)
  d.setHours(0, 0, 0, 0)
  return d
}

// Datum für API formatieren (YYYY-MM-DD)
export const formatDateForApi = (date: Date): string => {
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  return `${year}-${month}-${day}`
}

// Wochentage als Array von Dates
export const getWeekDays = (weekStart: Date): Date[] => {
  return Array.from({ length: 5 }, (_, i) => {
    const date = new Date(weekStart)
    date.setDate(weekStart.getDate() + i)
    return date
  })
}

// Position und Höhe eines Termins berechnen (0-24 Uhr)
export const getTerminStyle = (startZeit: string, endZeit: string): { top: number; height: number } => {
  const start = new Date(startZeit)
  const end = new Date(endZeit)

  const startMinutes = start.getHours() * 60 + start.getMinutes()
  const endMinutes = end.getHours() * 60 + end.getMinutes()

  const top = (startMinutes / 60) * HOUR_HEIGHT
  const height = ((endMinutes - startMinutes) / 60) * HOUR_HEIGHT

  return { top, height: Math.max(height, 20) }
}

// Zeit aus Klick-Position berechnen (0-24 Uhr)
// Klickposition = Mitte des Termins (nicht Anfang)
export const getTimeFromPosition = (y: number, date: Date, duration: number = 90): { start: Date; end: Date } => {
  const totalMinutes = (y / HOUR_HEIGHT) * 60

  // Klickposition ist Mitte des Termins - berechne Startzeit
  const centerMinutes = Math.round(totalMinutes / 15) * 15 // Auf 15 Minuten runden
  const halfDuration = Math.floor(duration / 2)
  let startMinutes = centerMinutes - halfDuration

  // Sicherstellen dass Start nicht vor 00:00 liegt
  if (startMinutes < 0) startMinutes = 0

  // Sicherstellen dass Ende nicht nach 24:00 liegt
  const endMinutes = startMinutes + duration
  if (endMinutes > 24 * 60) {
    startMinutes = 24 * 60 - duration
  }

  // Auf 15-Minuten-Intervall snappen
  startMinutes = Math.round(startMinutes / 15) * 15

  const hours = Math.floor(startMinutes / 60)
  const minutes = startMinutes % 60

  const start = new Date(date)
  start.setHours(hours, minutes, 0, 0)

  const end = new Date(start)
  end.setMinutes(end.getMinutes() + duration)

  return { start, end }
}

// Zeit aus Date-Objekt formatieren (HH:mm)
export const formatTimeInput = (date: Date): string => {
  return `${String(date.getHours()).padStart(2, '0')}:${String(date.getMinutes()).padStart(2, '0')}`
}

// Zeit formatieren (HH:mm) aus ISO-String
export const formatTime = (dateString: string): string => {
  return new Date(dateString).toLocaleTimeString('de-DE', {
    hour: '2-digit',
    minute: '2-digit',
  })
}

// Prüfen ob Datum heute ist
export const isToday = (date: Date): boolean => {
  const today = new Date()
  return date.toDateString() === today.toDateString()
}

// Aktuelle Zeit-Position berechnen
export const getCurrentTimePosition = (): number => {
  const now = new Date()
  const minutes = now.getHours() * 60 + now.getMinutes()
  return (minutes / 60) * HOUR_HEIGHT
}

// Prüfen ob aktuelle Woche angezeigt wird
export const isCurrentWeek = (weekStart: Date): boolean => {
  const today = new Date()
  const currentWeekStart = getWeekStart(today)
  return currentWeekStart.getTime() === weekStart.getTime()
}

// Position aus Termin-Slot berechnen (für HH:mm Format)
export const getSlotStyle = (
  _date: Date,
  startZeit: string,
  endZeit: string
): { top: number; height: number } => {
  const [startHour, startMin] = startZeit.split(':').map(Number)
  const [endHour, endMin] = endZeit.split(':').map(Number)

  const startMinutes = startHour * 60 + startMin
  const endMinutes = endHour * 60 + endMin

  const top = (startMinutes / 60) * HOUR_HEIGHT
  const height = ((endMinutes - startMinutes) / 60) * HOUR_HEIGHT

  return { top, height: Math.max(height, 20) }
}

// DateTime für API formatieren (ISO Format)
export const formatDateTimeForApi = (date: Date, time: string): string => {
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  return `${year}-${month}-${day}T${time}:00`
}

// Wochenbereich formatieren (z.B. "1. Dez - 5. Dez 2025")
export const formatWeekRange = (weekStart: Date): string => {
  const endOfWeek = new Date(weekStart)
  endOfWeek.setDate(endOfWeek.getDate() + 4)
  const options: Intl.DateTimeFormatOptions = { day: 'numeric', month: 'short' }
  return `${weekStart.toLocaleDateString('de-DE', options)} - ${endOfWeek.toLocaleDateString('de-DE', options)} ${weekStart.getFullYear()}`
}
