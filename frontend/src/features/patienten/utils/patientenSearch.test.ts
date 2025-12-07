import { describe, it, expect } from 'vitest'
import { searchPatienten, formatGeburtstag, formatPatientForDisplay } from './patientenSearch'
import type { PatientDto } from '../types/patient.types'

const createPatient = (overrides: Partial<PatientDto> = {}): PatientDto => ({
  id: '1',
  titel: null,
  vorname: 'Max',
  nachname: 'Müller',
  strasse: null,
  hausnummer: null,
  plz: null,
  stadt: null,
  telMobil: null,
  telFestnetz: null,
  email: null,
  geburtstag: '1990-05-01',
  behandlungenProRezept: null,
  ...overrides,
})

const mockPatienten: PatientDto[] = [
  createPatient({ id: '1', vorname: 'Max', nachname: 'Müller', geburtstag: '1990-05-01' }),
  createPatient({ id: '2', vorname: 'Anna', nachname: 'Schmidt', geburtstag: '1985-12-15' }),
  createPatient({ id: '3', vorname: 'Peter', nachname: 'Müller', geburtstag: '1978-03-22' }),
  createPatient({ id: '4', vorname: 'Maria', nachname: 'Weber', geburtstag: null }),
]

describe('searchPatienten', () => {
  describe('Leerer Query', () => {
    it('gibt alle Patienten zurück bei leerem Query', () => {
      expect(searchPatienten(mockPatienten, '')).toHaveLength(4)
    })

    it('gibt alle Patienten zurück bei Whitespace-Query', () => {
      expect(searchPatienten(mockPatienten, '   ')).toHaveLength(4)
    })

    it('respektiert das Limit bei leerem Query', () => {
      expect(searchPatienten(mockPatienten, '', 2)).toHaveLength(2)
    })
  })

  describe('Namenssuche', () => {
    it('findet Patient nach Vorname', () => {
      const result = searchPatienten(mockPatienten, 'max')
      expect(result).toHaveLength(1)
      expect(result[0].vorname).toBe('Max')
    })

    it('findet Patient nach Nachname', () => {
      const result = searchPatienten(mockPatienten, 'müller')
      expect(result).toHaveLength(2)
    })

    it('findet Patient nach "Vorname Nachname"', () => {
      const result = searchPatienten(mockPatienten, 'Max Müller')
      expect(result).toHaveLength(1)
      expect(result[0].id).toBe('1')
    })

    it('findet Patient nach "Nachname Vorname"', () => {
      const result = searchPatienten(mockPatienten, 'Müller Max')
      expect(result).toHaveLength(1)
      expect(result[0].id).toBe('1')
    })

    it('findet Patient nach partiellem Namen', () => {
      const result = searchPatienten(mockPatienten, 'mül')
      expect(result).toHaveLength(2)
    })

    it('ist case-insensitive', () => {
      const result = searchPatienten(mockPatienten, 'MAX MÜLLER')
      expect(result).toHaveLength(1)
    })
  })

  describe('Geburtsdatum-Suche', () => {
    it('findet Patient nach Geburtsdatum dd.MM.yyyy', () => {
      const result = searchPatienten(mockPatienten, '01.05.1990')
      expect(result).toHaveLength(1)
      expect(result[0].vorname).toBe('Max')
    })

    it('findet Patient nach Geburtsdatum d.M.yyyy', () => {
      const result = searchPatienten(mockPatienten, '1.5.1990')
      expect(result).toHaveLength(1)
      expect(result[0].vorname).toBe('Max')
    })

    it('findet Patient nach Geburtsdatum dd.MM.yy', () => {
      const result = searchPatienten(mockPatienten, '01.05.90')
      expect(result).toHaveLength(1)
      expect(result[0].vorname).toBe('Max')
    })

    it('findet Patient nach Geburtsdatum d.M.yy', () => {
      const result = searchPatienten(mockPatienten, '1.5.90')
      expect(result).toHaveLength(1)
      expect(result[0].vorname).toBe('Max')
    })

    it('findet Patient nach partiellem Datum', () => {
      const result = searchPatienten(mockPatienten, '1990')
      expect(result).toHaveLength(1)
      expect(result[0].vorname).toBe('Max')
    })
  })

  describe('Kombinierte Suche', () => {
    it('findet Patient mit Name und Datum kombiniert', () => {
      const result = searchPatienten(mockPatienten, 'müller 1990')
      expect(result).toHaveLength(1)
      expect(result[0].vorname).toBe('Max')
    })
  })

  describe('Keine Treffer', () => {
    it('gibt leeres Array bei keinem Match', () => {
      expect(searchPatienten(mockPatienten, 'xyz123')).toHaveLength(0)
    })

    it('gibt leeres Array wenn alle Teile nicht matchen', () => {
      expect(searchPatienten(mockPatienten, 'Max Weber')).toHaveLength(0)
    })
  })

  describe('Limit', () => {
    it('limitiert Ergebnisse', () => {
      const manyPatients = Array(100)
        .fill(null)
        .map((_, i) => createPatient({ id: String(i), vorname: 'Test', nachname: `Patient${i}` }))

      expect(searchPatienten(manyPatients, 'test', 20)).toHaveLength(20)
    })
  })
})

describe('formatGeburtstag', () => {
  it('formatiert ISO-Datum zu deutschem Format', () => {
    expect(formatGeburtstag('1990-05-01')).toBe('01.05.1990')
  })

  it('formatiert einstellige Tage/Monate mit führender Null', () => {
    expect(formatGeburtstag('1985-01-05')).toBe('05.01.1985')
  })

  it('parst ISO-Datum timezone-unabhängig (ohne new Date())', () => {
    // Dieser Test stellt sicher, dass z.B. "1990-05-01" nicht als
    // 30.04.1990 interpretiert wird, was bei new Date() in manchen
    // Zeitzonen passieren kann
    expect(formatGeburtstag('1990-01-01')).toBe('01.01.1990')
    expect(formatGeburtstag('2000-12-31')).toBe('31.12.2000')
  })
})

describe('formatPatientForDisplay', () => {
  it('formatiert Patient als "Vorname Nachname"', () => {
    const patient = createPatient({ vorname: 'Max', nachname: 'Müller' })
    expect(formatPatientForDisplay(patient)).toBe('Max Müller')
  })
})
