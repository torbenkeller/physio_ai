import { useState, useEffect, useCallback } from 'react'

const STORAGE_KEY = 'kalender-settings'

interface KalenderSettings {
  showWeekend: boolean
}

const DEFAULT_SETTINGS: KalenderSettings = {
  showWeekend: false,
}

export const useKalenderSettings = () => {
  const [settings, setSettings] = useState<KalenderSettings>(() => {
    if (typeof window === 'undefined') return DEFAULT_SETTINGS

    const stored = localStorage.getItem(STORAGE_KEY)
    if (stored) {
      try {
        return { ...DEFAULT_SETTINGS, ...JSON.parse(stored) }
      } catch {
        return DEFAULT_SETTINGS
      }
    }
    return DEFAULT_SETTINGS
  })

  // Persist to localStorage when settings change
  useEffect(() => {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(settings))
  }, [settings])

  const setShowWeekend = useCallback((showWeekend: boolean) => {
    setSettings((prev) => ({ ...prev, showWeekend }))
  }, [])

  // Anzahl der Tage basierend auf Einstellung
  const dayCount = settings.showWeekend ? 7 : 5

  return {
    settings,
    setShowWeekend,
    dayCount,
  }
}
