import type { PatientDto } from '../types/patient.types'

/**
 * Parst ein ISO-Datum (yyyy-MM-dd) ohne Timezone-Probleme
 * (new Date(isoDate) kann in manchen Zeitzonen zum falschen Tag führen)
 */
function parseIsoDate(isoDate: string): { day: number; month: number; year: number } {
  const [year, month, day] = isoDate.split('-').map(Number)
  return { day, month, year }
}

/**
 * Formatiert ein ISO-Datum (yyyy-MM-dd) zu deutschem Format (dd.MM.yyyy)
 */
export function formatGeburtstag(isoDate: string): string {
  const { day, month, year } = parseIsoDate(isoDate)
  return `${day.toString().padStart(2, '0')}.${month.toString().padStart(2, '0')}.${year}`
}

/**
 * Erzeugt verschiedene Suchbegriffe für einen Patienten
 * - Vorname, Nachname
 * - "Vorname Nachname", "Nachname Vorname"
 * - Geburtsdatum in verschiedenen Formaten
 */
function prepareSearchTerms(patient: PatientDto): string[] {
  const terms: string[] = [
    patient.vorname.toLowerCase(),
    patient.nachname.toLowerCase(),
    `${patient.vorname} ${patient.nachname}`.toLowerCase(),
    `${patient.nachname} ${patient.vorname}`.toLowerCase(),
    `${patient.nachname}, ${patient.vorname}`.toLowerCase(),
  ]

  if (patient.geburtstag) {
    const { day, month, year } = parseIsoDate(patient.geburtstag)
    const yearShort = year.toString().slice(-2)

    // Verschiedene Datumsformate
    terms.push(
      // dd.MM.yyyy
      `${day.toString().padStart(2, '0')}.${month.toString().padStart(2, '0')}.${year}`,
      // d.M.yyyy
      `${day}.${month}.${year}`,
      // dd.MM.yy
      `${day.toString().padStart(2, '0')}.${month.toString().padStart(2, '0')}.${yearShort}`,
      // d.M.yy
      `${day}.${month}.${yearShort}`,
    )
  }

  return terms
}

/**
 * Sucht Patienten basierend auf einem Freitext-Query
 *
 * @param patienten - Liste aller Patienten
 * @param query - Suchbegriff (kann Name oder Geburtsdatum sein)
 * @param limit - Maximale Anzahl der Ergebnisse (default: 50)
 * @returns Gefilterte und sortierte Patientenliste
 */
export function searchPatienten(
  patienten: PatientDto[],
  query: string,
  limit: number = 50,
): PatientDto[] {
  const queryTrimmed = query.trim()

  // Bei leerem Query: Alle Patienten zurückgeben (sortiert nach Nachname)
  if (!queryTrimmed) {
    return patienten.slice(0, limit)
  }

  const queryLower = queryTrimmed.toLowerCase()
  const queryParts = queryLower.split(/\s+/)

  return patienten
    .filter((patient) => {
      const terms = prepareSearchTerms(patient)

      // Alle Query-Teile müssen in mindestens einem Term vorkommen
      return queryParts.every((part) => terms.some((term) => term.includes(part)))
    })
    .slice(0, limit)
}

/**
 * Formatiert einen Patienten für die Anzeige im Dropdown
 */
export function formatPatientForDisplay(patient: PatientDto): string {
  return `${patient.vorname} ${patient.nachname}`
}
