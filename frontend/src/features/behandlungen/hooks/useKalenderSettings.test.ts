import { describe, it, expect, beforeEach } from 'vitest'
import { renderHook, act } from '@testing-library/react'
import { useKalenderSettings } from './useKalenderSettings'

describe('useKalenderSettings', () => {
  beforeEach(() => {
    localStorage.clear()
  })

  it('gibt Default-Werte zurück wenn localStorage leer ist', () => {
    const { result } = renderHook(() => useKalenderSettings())

    expect(result.current.settings.showWeekend).toBe(false)
    expect(result.current.dayCount).toBe(5)
  })

  it('lädt gespeicherte Einstellungen aus localStorage', () => {
    localStorage.setItem('kalender-settings', JSON.stringify({ showWeekend: true }))

    const { result } = renderHook(() => useKalenderSettings())

    expect(result.current.settings.showWeekend).toBe(true)
    expect(result.current.dayCount).toBe(7)
  })

  it('speichert Änderungen in localStorage', () => {
    const { result } = renderHook(() => useKalenderSettings())

    act(() => {
      result.current.setShowWeekend(true)
    })

    expect(localStorage.getItem('kalender-settings')).toBe(
      JSON.stringify({ showWeekend: true })
    )
  })

  it('aktualisiert dayCount wenn showWeekend geändert wird', () => {
    const { result } = renderHook(() => useKalenderSettings())

    expect(result.current.dayCount).toBe(5)

    act(() => {
      result.current.setShowWeekend(true)
    })

    expect(result.current.dayCount).toBe(7)
  })

  it('behandelt korrupte localStorage-Daten graceful', () => {
    localStorage.setItem('kalender-settings', 'invalid-json')

    const { result } = renderHook(() => useKalenderSettings())

    expect(result.current.settings.showWeekend).toBe(false)
  })

  it('merged partielle Settings mit Defaults', () => {
    localStorage.setItem('kalender-settings', JSON.stringify({}))

    const { result } = renderHook(() => useKalenderSettings())

    expect(result.current.settings.showWeekend).toBe(false)
  })
})
