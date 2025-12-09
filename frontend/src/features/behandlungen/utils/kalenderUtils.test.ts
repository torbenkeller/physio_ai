import { describe, it, expect } from 'vitest'
import type { BehandlungKalenderDto } from '../types/behandlung.types'
import {
  calculateTerminLayouts,
  getTerminStyleWithLayout,
  type TerminLayoutInfo,
} from './kalenderUtils'

// Test-Hilfsfunktionen
const createTermin = (id: string, startZeit: string, endZeit: string): BehandlungKalenderDto => ({
  id,
  startZeit,
  endZeit,
  rezeptId: null,
  behandlungsartId: null,
  bemerkung: null,
  patient: { id: 'patient-1', name: 'Max Mustermann', birthday: null, behandlungenProRezept: null },
})

// Termine für einen bestimmten Tag erstellen (ISO Format)
const createTerminForDay = (
  id: string,
  date: string,
  startTime: string,
  endTime: string
): BehandlungKalenderDto => createTermin(id, `${date}T${startTime}:00`, `${date}T${endTime}:00`)

describe('calculateTerminLayouts', () => {
  const testDate = '2025-12-09'

  describe('Leere und einzelne Termine', () => {
    it('gibt leere Map für leere Eingabe zurück', () => {
      const result = calculateTerminLayouts([])
      expect(result.size).toBe(0)
    })

    it('gibt columnIndex 0 und totalColumns 1 für einzelnen Termin zurück', () => {
      const termine = [createTerminForDay('t1', testDate, '09:00', '10:00')]

      const result = calculateTerminLayouts(termine)

      expect(result.size).toBe(1)
      expect(result.get('t1')).toEqual({ columnIndex: 0, totalColumns: 1 })
    })
  })

  describe('Nicht-überlappende Termine', () => {
    it('weist jedem nicht-überlappenden Termin columnIndex 0 und totalColumns 1 zu', () => {
      const termine = [
        createTerminForDay('t1', testDate, '09:00', '10:00'),
        createTerminForDay('t2', testDate, '11:00', '12:00'),
        createTerminForDay('t3', testDate, '14:00', '15:00'),
      ]

      const result = calculateTerminLayouts(termine)

      expect(result.size).toBe(3)
      expect(result.get('t1')).toEqual({ columnIndex: 0, totalColumns: 1 })
      expect(result.get('t2')).toEqual({ columnIndex: 0, totalColumns: 1 })
      expect(result.get('t3')).toEqual({ columnIndex: 0, totalColumns: 1 })
    })

    it('behandelt exakt angrenzende Termine als nicht-überlappend', () => {
      // 09:00-10:00 und 10:00-11:00 grenzen aneinander, überlappen aber nicht
      const termine = [
        createTerminForDay('t1', testDate, '09:00', '10:00'),
        createTerminForDay('t2', testDate, '10:00', '11:00'),
      ]

      const result = calculateTerminLayouts(termine)

      expect(result.get('t1')).toEqual({ columnIndex: 0, totalColumns: 1 })
      expect(result.get('t2')).toEqual({ columnIndex: 0, totalColumns: 1 })
    })
  })

  describe('Überlappende Termine', () => {
    it('weist zwei überlappenden Terminen unterschiedliche Spalten zu', () => {
      // 09:00-10:00 und 09:30-10:30 überlappen
      const termine = [
        createTerminForDay('t1', testDate, '09:00', '10:00'),
        createTerminForDay('t2', testDate, '09:30', '10:30'),
      ]

      const result = calculateTerminLayouts(termine)

      expect(result.size).toBe(2)
      // Beide sollten totalColumns = 2 haben
      expect(result.get('t1')?.totalColumns).toBe(2)
      expect(result.get('t2')?.totalColumns).toBe(2)
      // Spaltenindizes sollten unterschiedlich sein
      expect(result.get('t1')?.columnIndex).not.toBe(result.get('t2')?.columnIndex)
    })

    it('behandelt vollständig überlappende Termine korrekt', () => {
      // Beide Termine haben exakt die gleiche Zeit
      const termine = [
        createTerminForDay('t1', testDate, '09:00', '10:00'),
        createTerminForDay('t2', testDate, '09:00', '10:00'),
      ]

      const result = calculateTerminLayouts(termine)

      expect(result.get('t1')?.totalColumns).toBe(2)
      expect(result.get('t2')?.totalColumns).toBe(2)
      expect(result.get('t1')?.columnIndex).not.toBe(result.get('t2')?.columnIndex)
    })

    it('behandelt einen Termin der einen anderen enthält', () => {
      // 09:00-12:00 enthält 10:00-11:00
      const termine = [
        createTerminForDay('t1', testDate, '09:00', '12:00'),
        createTerminForDay('t2', testDate, '10:00', '11:00'),
      ]

      const result = calculateTerminLayouts(termine)

      expect(result.get('t1')?.totalColumns).toBe(2)
      expect(result.get('t2')?.totalColumns).toBe(2)
    })

    it('weist drei überlappenden Terminen drei Spalten zu', () => {
      // Alle drei überlappen sich gegenseitig
      const termine = [
        createTerminForDay('t1', testDate, '09:00', '11:00'),
        createTerminForDay('t2', testDate, '09:30', '11:30'),
        createTerminForDay('t3', testDate, '10:00', '12:00'),
      ]

      const result = calculateTerminLayouts(termine)

      expect(result.get('t1')?.totalColumns).toBe(3)
      expect(result.get('t2')?.totalColumns).toBe(3)
      expect(result.get('t3')?.totalColumns).toBe(3)

      // Alle sollten unterschiedliche Spalten haben
      const columns = new Set([
        result.get('t1')?.columnIndex,
        result.get('t2')?.columnIndex,
        result.get('t3')?.columnIndex,
      ])
      expect(columns.size).toBe(3)
    })
  })

  describe('Spalten-Wiederverwendung', () => {
    it('verwendet Spalten wieder wenn Termine nicht mehr überlappen', () => {
      // t1 (09:00-10:00) und t2 (09:30-10:30) überlappen → 2 Spalten
      // t3 (11:00-12:00) überlappt mit keinem → kann Spalte 0 wiederverwenden
      const termine = [
        createTerminForDay('t1', testDate, '09:00', '10:00'),
        createTerminForDay('t2', testDate, '09:30', '10:30'),
        createTerminForDay('t3', testDate, '11:00', '12:00'),
      ]

      const result = calculateTerminLayouts(termine)

      // t1 und t2 bilden eine Gruppe mit 2 Spalten
      expect(result.get('t1')?.totalColumns).toBe(2)
      expect(result.get('t2')?.totalColumns).toBe(2)

      // t3 ist alleine → 1 Spalte, volle Breite
      expect(result.get('t3')).toEqual({ columnIndex: 0, totalColumns: 1 })
    })
  })

  describe('Ketten-Überlappung (transitive Verbindung)', () => {
    it('gruppiert transitiv verbundene Termine zusammen', () => {
      // t1 (09:00-10:00) überlappt mit t2 (09:30-10:30)
      // t2 überlappt mit t3 (10:00-11:00)
      // t1 überlappt NICHT mit t3, aber alle gehören zur gleichen Gruppe
      const termine = [
        createTerminForDay('t1', testDate, '09:00', '10:00'),
        createTerminForDay('t2', testDate, '09:30', '10:30'),
        createTerminForDay('t3', testDate, '10:00', '11:00'),
      ]

      const result = calculateTerminLayouts(termine)

      // Alle sollten in derselben Gruppe sein
      expect(result.get('t1')?.totalColumns).toBe(result.get('t2')?.totalColumns)
      expect(result.get('t2')?.totalColumns).toBe(result.get('t3')?.totalColumns)
    })
  })

  describe('Mehrere separate Kollisionsgruppen', () => {
    it('behandelt zwei separate Gruppen unabhängig', () => {
      // Gruppe 1: 09:00-10:00 und 09:30-10:30
      // Gruppe 2: 14:00-15:00 und 14:30-15:30
      const termine = [
        createTerminForDay('t1', testDate, '09:00', '10:00'),
        createTerminForDay('t2', testDate, '09:30', '10:30'),
        createTerminForDay('t3', testDate, '14:00', '15:00'),
        createTerminForDay('t4', testDate, '14:30', '15:30'),
      ]

      const result = calculateTerminLayouts(termine)

      // Gruppe 1
      expect(result.get('t1')?.totalColumns).toBe(2)
      expect(result.get('t2')?.totalColumns).toBe(2)

      // Gruppe 2
      expect(result.get('t3')?.totalColumns).toBe(2)
      expect(result.get('t4')?.totalColumns).toBe(2)
    })
  })
})

describe('getTerminStyleWithLayout', () => {
  const testDate = '2025-12-09'
  const HOUR_HEIGHT = 60 // Muss mit kalenderUtils übereinstimmen

  describe('Vertikale Positionierung (top/height)', () => {
    it('berechnet korrekte top-Position für 09:00', () => {
      const layout: TerminLayoutInfo = { columnIndex: 0, totalColumns: 1 }
      const result = getTerminStyleWithLayout(
        `${testDate}T09:00:00`,
        `${testDate}T10:00:00`,
        layout
      )

      expect(result.top).toBe(9 * HOUR_HEIGHT) // 9 Stunden × 60px
    })

    it('berechnet korrekte Höhe für 1-stündigen Termin', () => {
      const layout: TerminLayoutInfo = { columnIndex: 0, totalColumns: 1 }
      const result = getTerminStyleWithLayout(
        `${testDate}T09:00:00`,
        `${testDate}T10:00:00`,
        layout
      )

      expect(result.height).toBe(HOUR_HEIGHT)
    })

    it('berechnet korrekte Höhe für 90-Minuten-Termin', () => {
      const layout: TerminLayoutInfo = { columnIndex: 0, totalColumns: 1 }
      const result = getTerminStyleWithLayout(
        `${testDate}T09:00:00`,
        `${testDate}T10:30:00`,
        layout
      )

      expect(result.height).toBe(1.5 * HOUR_HEIGHT)
    })
  })

  describe('Horizontale Positionierung (left/width)', () => {
    it('gibt volle Breite für einzelnen Termin zurück', () => {
      const layout: TerminLayoutInfo = { columnIndex: 0, totalColumns: 1 }
      const result = getTerminStyleWithLayout(
        `${testDate}T09:00:00`,
        `${testDate}T10:00:00`,
        layout
      )

      expect(result.left).toBe('0%')
      expect(result.width).toBe('100%')
    })

    it('gibt halbe Breite für zwei überlappende Termine zurück (erste Spalte)', () => {
      const layout: TerminLayoutInfo = { columnIndex: 0, totalColumns: 2 }
      const result = getTerminStyleWithLayout(
        `${testDate}T09:00:00`,
        `${testDate}T10:00:00`,
        layout
      )

      expect(result.left).toBe('0%')
      expect(result.width).toBe('50%')
    })

    it('gibt halbe Breite für zwei überlappende Termine zurück (zweite Spalte)', () => {
      const layout: TerminLayoutInfo = { columnIndex: 1, totalColumns: 2 }
      const result = getTerminStyleWithLayout(
        `${testDate}T09:00:00`,
        `${testDate}T10:00:00`,
        layout
      )

      expect(result.left).toBe('50%')
      expect(result.width).toBe('50%')
    })

    it('gibt Drittel-Breite für drei überlappende Termine zurück', () => {
      const layout0: TerminLayoutInfo = { columnIndex: 0, totalColumns: 3 }
      const layout1: TerminLayoutInfo = { columnIndex: 1, totalColumns: 3 }
      const layout2: TerminLayoutInfo = { columnIndex: 2, totalColumns: 3 }

      const result0 = getTerminStyleWithLayout(
        `${testDate}T09:00:00`,
        `${testDate}T10:00:00`,
        layout0
      )
      const result1 = getTerminStyleWithLayout(
        `${testDate}T09:00:00`,
        `${testDate}T10:00:00`,
        layout1
      )
      const result2 = getTerminStyleWithLayout(
        `${testDate}T09:00:00`,
        `${testDate}T10:00:00`,
        layout2
      )

      // Erste Spalte
      expect(result0.left).toBe('0%')
      expect(parseFloat(result0.width)).toBeCloseTo(33.33, 1)

      // Zweite Spalte
      expect(parseFloat(result1.left)).toBeCloseTo(33.33, 1)
      expect(parseFloat(result1.width)).toBeCloseTo(33.33, 1)

      // Dritte Spalte
      expect(parseFloat(result2.left)).toBeCloseTo(66.67, 1)
      expect(parseFloat(result2.width)).toBeCloseTo(33.33, 1)
    })
  })
})
