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

// Wochentag-Konfiguration für UI-Komponenten
export const WEEK_DAYS_CONFIG = [
  { index: 0, short: 'Mo', long: 'Montag' },
  { index: 1, short: 'Di', long: 'Dienstag' },
  { index: 2, short: 'Mi', long: 'Mittwoch' },
  { index: 3, short: 'Do', long: 'Donnerstag' },
  { index: 4, short: 'Fr', long: 'Freitag' },
  { index: 5, short: 'Sa', long: 'Samstag' },
  { index: 6, short: 'So', long: 'Sonntag' },
] as const

export const getWeekDaysConfig = (includeWeekend: boolean = false) =>
  includeWeekend ? WEEK_DAYS_CONFIG : WEEK_DAYS_CONFIG.slice(0, 5)

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
// Tagesname formatieren (lang oder kurz) mit Intl API
export const formatWeekday = (date: Date, style: 'long' | 'short' = 'long'): string => {
  const name = new Intl.DateTimeFormat('de-DE', { weekday: style }).format(date)
  // Bei 'short' einen Punkt anhängen ("Mo" → "Mo.")
  return style === 'short' ? `${name}.` : name
}

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
export const getWeekDays = (weekStart: Date, includeWeekend: boolean = false): Date[] => {
  const length = includeWeekend ? 7 : 5
  return Array.from({ length }, (_, i) => {
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
  let endMinutes = endHour * 60 + endMin

  // Falls Endzeit über Mitternacht geht (00:xx), auf 24:00 begrenzen
  if (endMinutes <= startMinutes) {
    endMinutes = 24 * 60 // 24:00 = Ende des Tages
  }

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

// ISO Kalenderwoche berechnen
export const getISOWeekNumber = (date: Date): number => {
  const d = new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate()))
  const dayNum = d.getUTCDay() || 7
  d.setUTCDate(d.getUTCDate() + 4 - dayNum)
  const yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1))
  return Math.ceil((((d.getTime() - yearStart.getTime()) / 86400000) + 1) / 7)
}

// Wochenbereich formatieren (z.B. "KW 49 · Dezember 2025")
export const formatWeekRange = (weekStart: Date, _includeWeekend: boolean = false): string => {
  const weekNumber = getISOWeekNumber(weekStart)
  const month = new Intl.DateTimeFormat('de-DE', { month: 'long' }).format(weekStart)
  const year = weekStart.getFullYear()
  return `KW ${weekNumber} · ${month} ${year}`
}
