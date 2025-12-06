import { useState, useCallback, useMemo } from 'react'
import type { SelectedTimeSlot, SeriesPattern, SeriesConfig, ConflictResult } from '../types/behandlung.types'

interface UseMultiTerminSelectionReturn {
  slots: SelectedTimeSlot[]
  addSlot: (date: Date, startZeit: string, endZeit: string) => void
  removeSlot: (id: string) => void
  updateSlot: (id: string, updates: Partial<Omit<SelectedTimeSlot, 'id'>>) => void
  clearSlots: () => void
  generateSeries: (firstSlot: SelectedTimeSlot, pattern: SeriesPattern, count: number) => void
  generateSeriesFlexible: (firstSlot: SelectedTimeSlot, config: SeriesConfig, count: number) => void
  setSlots: React.Dispatch<React.SetStateAction<SelectedTimeSlot[]>>
  // Konflikt-Funktionen
  conflictCount: number
  markConflicts: (conflicts: ConflictResult[]) => void
  clearConflictMarkers: () => void
}

export const useMultiTerminSelection = (): UseMultiTerminSelectionReturn => {
  const [slots, setSlots] = useState<SelectedTimeSlot[]>([])

  const generateId = () => crypto.randomUUID()

  const addSlot = useCallback((date: Date, startZeit: string, endZeit: string) => {
    const newSlot: SelectedTimeSlot = {
      id: generateId(),
      date,
      startZeit,
      endZeit,
    }
    setSlots((prev) => [...prev, newSlot])
  }, [])

  const removeSlot = useCallback((id: string) => {
    setSlots((prev) => prev.filter((slot) => slot.id !== id))
  }, [])

  const updateSlot = useCallback((id: string, updates: Partial<Omit<SelectedTimeSlot, 'id'>>) => {
    setSlots((prev) =>
      prev.map((slot) => (slot.id === id ? { ...slot, ...updates } : slot))
    )
  }, [])

  const clearSlots = useCallback(() => {
    setSlots([])
  }, [])

  const generateSeries = useCallback(
    (firstSlot: SelectedTimeSlot, pattern: SeriesPattern, count: number) => {
      const newSlots: SelectedTimeSlot[] = []

      for (let i = 0; i < count; i++) {
        const newDate = new Date(firstSlot.date)

        switch (pattern) {
          case 'weekly':
            newDate.setDate(newDate.getDate() + i * 7)
            break
          case 'biweekly':
            newDate.setDate(newDate.getDate() + i * 14)
            break
          case 'monthly':
            // Gleicher Wochentag, 4 Wochen später
            newDate.setDate(newDate.getDate() + i * 28)
            break
          case 'twice-weekly':
            // Erster Termin an Tag X, zweiter 3 Tage später, dann wieder von vorn
            if (i % 2 === 0) {
              newDate.setDate(newDate.getDate() + Math.floor(i / 2) * 7)
            } else {
              newDate.setDate(newDate.getDate() + Math.floor(i / 2) * 7 + 3)
            }
            break
        }

        newSlots.push({
          id: generateId(),
          date: newDate,
          startZeit: firstSlot.startZeit,
          endZeit: firstSlot.endZeit,
        })
      }

      setSlots(newSlots)
    },
    []
  )

  // Hilfsfunktion: Dauer in Minuten berechnen
  const calculateDurationMinutes = (start: string, end: string): number => {
    const [sh, sm] = start.split(':').map(Number)
    const [eh, em] = end.split(':').map(Number)
    return (eh * 60 + em) - (sh * 60 + sm)
  }

  // Hilfsfunktion: Minuten zu Zeit addieren
  const addMinutesToTime = (time: string, minutes: number): string => {
    const [h, m] = time.split(':').map(Number)
    const total = h * 60 + m + minutes
    const newH = Math.floor(total / 60) % 24
    const newM = total % 60
    return `${String(newH).padStart(2, '0')}:${String(newM).padStart(2, '0')}`
  }

  // Flexible Serien-Generierung mit Wochentag-Auswahl und Wochen-Intervall
  const generateSeriesFlexible = useCallback(
    (firstSlot: SelectedTimeSlot, config: SeriesConfig, count: number) => {
      const { repeatEveryWeeks, dayTimeConfigs } = config

      // Fallback: Wenn keine dayTimeConfigs, aus selectedDays konvertieren
      const configs = dayTimeConfigs && dayTimeConfigs.length > 0
        ? dayTimeConfigs
        : config.selectedDays.map(d => ({ dayIndex: d, startZeit: firstSlot.startZeit }))

      if (configs.length === 0) {
        // Fallback: Wenn keine Tage ausgewählt, nehme den Tag des ersten Slots
        const dayOfWeek = (firstSlot.date.getDay() + 6) % 7 // JavaScript: 0=So, konvertiere zu 0=Mo
        configs.push({ dayIndex: dayOfWeek, startZeit: firstSlot.startZeit })
      }

      const newSlots: SelectedTimeSlot[] = []
      const sortedConfigs = [...configs].sort((a, b) => a.dayIndex - b.dayIndex)

      // Berechne Dauer aus dem ersten Slot
      const durationMinutes = calculateDurationMinutes(firstSlot.startZeit, firstSlot.endZeit)

      // Berechne den Wochenstart des ersten Slots (Montag)
      const firstDate = new Date(firstSlot.date)
      const firstDayOfWeek = (firstDate.getDay() + 6) % 7 // 0=Mo, 6=So
      const weekStart = new Date(firstDate)
      weekStart.setDate(weekStart.getDate() - firstDayOfWeek)
      weekStart.setHours(0, 0, 0, 0)

      let currentWeekStart = new Date(weekStart)
      let slotsGenerated = 0
      let isFirstWeek = true

      while (slotsGenerated < count) {
        for (const { dayIndex, startZeit } of sortedConfigs) {
          if (slotsGenerated >= count) break

          const slotDate = new Date(currentWeekStart)
          slotDate.setDate(slotDate.getDate() + dayIndex)

          // In der ersten Woche: Überspringe Tage vor dem ersten Slot
          if (isFirstWeek && slotDate < firstDate) {
            continue
          }

          // Endzeit aus Startzeit + Duration berechnen
          const endZeit = addMinutesToTime(startZeit, durationMinutes)

          newSlots.push({
            id: generateId(),
            date: slotDate,
            startZeit: startZeit,  // Individuelle Startzeit pro Tag
            endZeit: endZeit,      // Berechnete Endzeit
          })
          slotsGenerated++
        }

        // Zur nächsten relevanten Woche springen
        currentWeekStart.setDate(currentWeekStart.getDate() + 7 * repeatEveryWeeks)
        isFirstWeek = false
      }

      setSlots(newSlots)
    },
    []
  )

  // Anzahl der Konflikte berechnen
  const conflictCount = useMemo(() => {
    return slots.filter((slot) => slot.hasConflict).length
  }, [slots])

  // Konflikte auf Slots markieren - nur wenn sich tatsächlich etwas ändert
  const markConflicts = useCallback((conflicts: ConflictResult[]) => {
    setSlots((prev) => {
      let hasChanges = false
      const newSlots = prev.map((slot, index) => {
        const conflict = conflicts.find((c) => c.slotIndex === index)
        const newHasConflict = conflict?.hasConflict ?? false
        const newConflictingWith = conflict?.conflictingBehandlungen

        // Prüfe ob sich tatsächlich etwas geändert hat
        const conflictingWithChanged =
          JSON.stringify(slot.conflictingWith) !== JSON.stringify(newConflictingWith)

        if (slot.hasConflict === newHasConflict && !conflictingWithChanged) {
          // Keine Änderung - gib dieselbe Referenz zurück
          return slot
        }

        hasChanges = true
        return {
          ...slot,
          hasConflict: newHasConflict,
          conflictingWith: newConflictingWith,
        }
      })

      // Wenn keine Änderungen, gib das originale Array zurück
      return hasChanges ? newSlots : prev
    })
  }, [])

  // Konflikt-Marker entfernen - nur wenn nötig
  const clearConflictMarkers = useCallback(() => {
    setSlots((prev) => {
      // Prüfe ob überhaupt Konflikte markiert sind
      const hasAnyConflicts = prev.some(
        (slot) => slot.hasConflict !== undefined || slot.conflictingWith !== undefined
      )

      if (!hasAnyConflicts) {
        return prev // Keine Änderung nötig
      }

      return prev.map((slot) => {
        if (slot.hasConflict === undefined && slot.conflictingWith === undefined) {
          return slot // Schon clean
        }
        return {
          ...slot,
          hasConflict: undefined,
          conflictingWith: undefined,
        }
      })
    })
  }, [])

  return {
    slots,
    addSlot,
    removeSlot,
    updateSlot,
    clearSlots,
    generateSeries,
    generateSeriesFlexible,
    setSlots,
    conflictCount,
    markConflicts,
    clearConflictMarkers,
  }
}
