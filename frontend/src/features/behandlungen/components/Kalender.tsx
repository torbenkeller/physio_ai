import { useState, useMemo, useRef, useEffect, useCallback } from 'react'
import { useNavigate } from 'react-router-dom'
import { toast } from 'sonner'
import {
  useGetWeeklyCalendarQuery,
  useCreateBehandlungenBatchMutation,
  useCheckConflictsMutation,
} from '../api/behandlungenApi'
import {
  useGetPatientenQuery,
  useCreatePatientMutation,
} from '@/features/patienten/api/patientenApi'
import { useGetBehandlungsartenQuery } from '@/features/rezepte/api/rezepteApi'
import { useGetProfileQuery } from '@/features/profil/api/profileApi'
import { useMultiTerminSelection } from '../hooks/useMultiTerminSelection'
import { useKalenderSettings } from '../hooks/useKalenderSettings'
import { useIsMobile } from '@/shared/hooks/useIsMobile'
import { KalenderSettingsDialog } from './KalenderSettingsDialog'
import { BehandlungDetailPopover } from './BehandlungDetailPopover'
import { PageHeader } from '@/shared/components/PageHeader'
import { Button } from '@/shared/components/ui/button'
import { Card } from '@/shared/components/ui/card'
import { ChevronLeft, ChevronRight } from 'lucide-react'
import { cn } from '@/shared/utils'
import { PlanungsSidebar, NEW_PATIENT_ID, type NewPatientForm } from './PlanungsSidebar'
import {
  HOUR_HEIGHT,
  TOTAL_HOURS,
  TOTAL_HEIGHT,
  DEFAULT_SCROLL_HOUR,
  formatWeekday,
  getWeekStart,
  formatDateForApi,
  getWeekDays,
  getTerminStyle,
  getTimeFromPosition,
  formatTimeInput,
  formatTime,
  isToday,
  getCurrentTimePosition,
  isCurrentWeek,
  formatWeekRange,
  getSlotStyle,
  formatDateTimeForApi,
  PATTERN_COLORS,
  SLOT_COLORS,
  CONFLICT_COLORS,
  WEEKDAY_NAMES_SHORT,
  addMinutesToTime,
} from '../utils/kalenderUtils'
import type {
  BehandlungKalenderDto,
  SelectedTimeSlot,
  SeriesConfig,
  DayTimeConfig,
} from '../types/behandlung.types'

// Snapping-Konstante: 15 Minuten = 15px bei HOUR_HEIGHT=60
const SNAP_MINUTES = 15
const SNAP_HEIGHT = (SNAP_MINUTES / 60) * HOUR_HEIGHT

interface DragState {
  type: 'slot' | 'pattern'
  slotId?: string // Für konkrete Slots
  dayIndex?: number // Für Muster-Previews
  offsetY: number // Offset vom Element-Top zur Maus-Start-Position
  originalDayIndex: number
}

const INITIAL_NEW_PATIENT_FORM: NewPatientForm = {
  vorname: '',
  nachname: '',
  telMobil: '',
}

export const Kalender = () => {
  const navigate = useNavigate()
  const isMobile = useIsMobile()

  const [currentWeekStart, setCurrentWeekStart] = useState(() => getWeekStart(new Date()))
  const [planungsModus, setPlanungsModus] = useState(false)
  const [selectedSlotId, setSelectedSlotId] = useState<string | null>(null)
  const [selectedPatientId, setSelectedPatientId] = useState(NEW_PATIENT_ID)
  const [selectedBehandlungsartId, setSelectedBehandlungsartId] = useState('')
  const [newPatientForm, setNewPatientForm] = useState<NewPatientForm>(INITIAL_NEW_PATIENT_FORM)
  const [duration, setDuration] = useState(90) // Termin-Dauer in Minuten

  // Termin-Detail-Popover State
  const [selectedTermin, setSelectedTermin] = useState<BehandlungKalenderDto | null>(null)
  const [terminAnchorEl, setTerminAnchorEl] = useState<HTMLElement | null>(null)

  // Muster-Definition für Zwei-Phasen-Planung
  const [dayTimeConfigs, setDayTimeConfigs] = useState<DayTimeConfig[]>([])
  const [patternWeekStart, setPatternWeekStart] = useState<Date | null>(null)
  const [isSeriesOpen, setIsSeriesOpen] = useState(false)
  const scrollContainerRef = useRef<HTMLDivElement>(null)

  // Drag & Drop State
  const [dragState, setDragState] = useState<DragState | null>(null)
  const [dragPreview, setDragPreview] = useState<{ dayIndex: number; top: number } | null>(null)
  const columnRefsRef = useRef<(HTMLDivElement | null)[]>([])
  const prevSelectedSlotIdRef = useRef<string | null>(null)
  const dragJustEndedRef = useRef(false)

  const dateStr = formatDateForApi(currentWeekStart)
  const { data: calendarData, isLoading, refetch } = useGetWeeklyCalendarQuery(dateStr)
  const { data: patienten } = useGetPatientenQuery()
  const { data: behandlungsarten } = useGetBehandlungsartenQuery()
  const { data: profile } = useGetProfileQuery()
  const [createBatch, { isLoading: isCreating }] = useCreateBehandlungenBatchMutation()
  const [createPatient, { isLoading: isCreatingPatient }] = useCreatePatientMutation()
  const [checkConflicts] = useCheckConflictsMutation()

  const {
    slots,
    addSlot,
    removeSlot,
    updateSlot,
    clearSlots,
    generateSeriesFlexible,
    conflictCount,
    markConflicts,
  } = useMultiTerminSelection()

  // Kalender-Einstellungen (Wochenende ein/aus)
  const { settings, setShowWeekend } = useKalenderSettings()

  const weekDays = useMemo(
    () => getWeekDays(currentWeekStart, settings.showWeekend),
    [currentWeekStart, settings.showWeekend]
  )

  // Default count from patient or profile
  const selectedPatientData = patienten?.find((p) => p.id === selectedPatientId)
  const defaultCount =
    selectedPatientData?.behandlungenProRezept ?? profile?.defaultBehandlungenProRezept ?? 8

  // Scroll zu 8 Uhr beim ersten Laden
  useEffect(() => {
    if (scrollContainerRef.current && !isLoading) {
      scrollContainerRef.current.scrollTop = DEFAULT_SCROLL_HOUR * HOUR_HEIGHT
    }
  }, [isLoading])

  // Handler für Wochentag-Toggle (Muster-Phase)
  // Slots werden NICHT gelöscht - nur "Generieren" ersetzt die Slots
  const handleDayToggle = useCallback((dayIndex: number) => {
    setDayTimeConfigs((prev) => {
      const exists = prev.find((c) => c.dayIndex === dayIndex)
      if (exists) {
        // Letzter Tag darf nicht abgewählt werden
        if (prev.length === 1) return prev
        return prev.filter((c) => c.dayIndex !== dayIndex)
      } else {
        const defaultTime = prev[0]?.startZeit ?? '09:00'
        return [...prev, { dayIndex, startZeit: defaultTime }].sort(
          (a, b) => a.dayIndex - b.dayIndex
        )
      }
    })
  }, [])

  // Handler für Zeit-Änderung eines Tages (via Drag oder Sidebar-Input)
  // Slots werden NICHT gelöscht - nur "Generieren" ersetzt die Slots
  const handleDayTimeChange = useCallback((dayIndex: number, startZeit: string) => {
    setDayTimeConfigs((prev) =>
      prev.map((c) => (c.dayIndex === dayIndex ? { ...c, startZeit } : c))
    )
  }, [])

  // Konflikte prüfen wenn Slots sich ändern
  useEffect(() => {
    const checkForConflicts = async () => {
      if (slots.length === 0) return

      const slotsToCheck = slots.map((slot) => ({
        startZeit: formatDateTimeForApi(slot.date, slot.startZeit),
        endZeit: formatDateTimeForApi(slot.date, slot.endZeit),
      }))

      try {
        const conflicts = await checkConflicts({ slots: slotsToCheck }).unwrap()
        markConflicts(conflicts)
      } catch {
        // Ignore conflict check errors
      }
    }

    const debounce = setTimeout(checkForConflicts, 300)
    return () => clearTimeout(debounce)
  }, [slots, checkConflicts, markConflicts])

  // Zur Woche eines Slots springen (nur bei Auswahl-Änderung, nicht bei Navigation)
  useEffect(() => {
    // Nur springen wenn sich selectedSlotId tatsächlich geändert hat
    if (selectedSlotId !== prevSelectedSlotIdRef.current) {
      prevSelectedSlotIdRef.current = selectedSlotId

      if (selectedSlotId && planungsModus) {
        const selectedSlot = slots.find((s) => s.id === selectedSlotId)
        if (selectedSlot) {
          const slotWeekStart = getWeekStart(selectedSlot.date)
          if (slotWeekStart.getTime() !== currentWeekStart.getTime()) {
            setCurrentWeekStart(slotWeekStart)
          }
        }
      }
    }
  }, [selectedSlotId, slots, planungsModus, currentWeekStart])

  // Pattern aktualisieren wenn Serie-Akkordeon geöffnet wird und Slots existieren
  useEffect(() => {
    if (isSeriesOpen && slots.length > 0) {
      // Ersten Slot nach Datum sortiert finden
      const sortedSlots = [...slots].sort((a, b) => a.date.getTime() - b.date.getTime())
      const firstSlot = sortedSlots[0]
      const dayOfWeek = (firstSlot.date.getDay() + 6) % 7 // 0=Mo, 1=Di, etc.

      setDayTimeConfigs([{ dayIndex: dayOfWeek, startZeit: firstSlot.startZeit }])
      setPatternWeekStart(getWeekStart(firstSlot.date))
    }
  }, [isSeriesOpen, slots])

  const goToPreviousWeek = () => {
    const newWeekStart = new Date(currentWeekStart)
    newWeekStart.setDate(newWeekStart.getDate() - 7)
    setCurrentWeekStart(newWeekStart)
  }

  const goToNextWeek = () => {
    const newWeekStart = new Date(currentWeekStart)
    newWeekStart.setDate(newWeekStart.getDate() + 7)
    setCurrentWeekStart(newWeekStart)
  }

  const goToToday = () => {
    setCurrentWeekStart(getWeekStart(new Date()))
  }

  const handleColumnClick = (e: React.MouseEvent<HTMLDivElement>, dayIndex: number) => {
    // Ignorieren während Drag oder direkt nach Drag-Ende
    if (dragState || dragJustEndedRef.current) return

    const rect = e.currentTarget.getBoundingClientRect()
    const y = e.clientY - rect.top
    const date = weekDays[dayIndex]
    const { start, end } = getTimeFromPosition(y, date, duration)

    const startZeit = formatTimeInput(start)
    const endZeit = formatTimeInput(end)

    // Immer Slot direkt erstellen (grün)
    addSlot(date, startZeit, endZeit)

    // Bei erstem Slot: Pattern initialisieren + Sidebar öffnen
    if (slots.length === 0) {
      const dayOfWeek = (date.getDay() + 6) % 7
      setDayTimeConfigs([{ dayIndex: dayOfWeek, startZeit }])
      setPatternWeekStart(getWeekStart(date))
      setPlanungsModus(true)
    }
  }

  const handleCancelPlanung = () => {
    setPlanungsModus(false)
    setSelectedSlotId(null)
    setSelectedPatientId('')
    setSelectedBehandlungsartId('')
    setNewPatientForm(INITIAL_NEW_PATIENT_FORM)
    setDayTimeConfigs([])
    setPatternWeekStart(null)
    setIsSeriesOpen(false)
    clearSlots()
  }

  const handleCreateTermine = async (force: boolean) => {
    if (!selectedPatientId || slots.length === 0) return

    if (conflictCount > 0 && !force) {
      return
    }

    try {
      let patientId = selectedPatientId

      // Wenn "Neuer Patient" ausgewählt, erst Patient anlegen
      if (selectedPatientId === NEW_PATIENT_ID) {
        const newPatient = await createPatient({
          vorname: newPatientForm.vorname.trim(),
          nachname: newPatientForm.nachname.trim(),
          telMobil: newPatientForm.telMobil.trim() || null,
        }).unwrap()
        patientId = newPatient.id
        toast.success(`Patient "${newPatientForm.vorname} ${newPatientForm.nachname}" angelegt`)
      }

      const behandlungen = slots.map((slot) => ({
        patientId,
        startZeit: formatDateTimeForApi(slot.date, slot.startZeit),
        endZeit: formatDateTimeForApi(slot.date, slot.endZeit),
        behandlungsartId: selectedBehandlungsartId || null,
      }))

      await createBatch(behandlungen).unwrap()
      toast.success(`${slots.length} Termine erfolgreich erstellt`)
      handleCancelPlanung()
      refetch()
    } catch {
      toast.error('Fehler beim Erstellen der Termine')
    }
  }

  const handleGenerateSeriesFlexible = useCallback(
    (firstSlotData: SelectedTimeSlot, config: SeriesConfig, count: number) => {
      generateSeriesFlexible(firstSlotData, config, count)
    },
    [generateSeriesFlexible]
  )

  const getTermineForDay = (date: Date): BehandlungKalenderDto[] => {
    if (!calendarData) return []
    const dateKey = formatDateForApi(date)
    return calendarData[dateKey] || []
  }

  // Geplante Slots für einen bestimmten Tag
  const getSlotsForDay = (date: Date): SelectedTimeSlot[] => {
    return slots.filter((slot) => formatDateForApi(slot.date) === formatDateForApi(date))
  }

  // Snapping-Hilfsfunktion: Y-Position auf 15-Minuten-Intervalle runden
  const snapToGrid = useCallback((y: number): number => {
    const snapped = Math.round(y / SNAP_HEIGHT) * SNAP_HEIGHT
    return Math.max(0, Math.min(snapped, TOTAL_HEIGHT - SNAP_HEIGHT))
  }, [])

  // Day-Index aus X-Position ermitteln
  const getDayIndexFromX = useCallback((clientX: number): number => {
    for (let i = 0; i < columnRefsRef.current.length; i++) {
      const col = columnRefsRef.current[i]
      if (col) {
        const rect = col.getBoundingClientRect()
        if (clientX >= rect.left && clientX <= rect.right) {
          return i
        }
      }
    }
    return -1
  }, [])

  // Zeit aus Y-Position berechnen (in Minuten ab Mitternacht)
  const getMinutesFromY = useCallback((y: number): number => {
    return Math.round((y / HOUR_HEIGHT) * 60)
  }, [])

  // Zeit als HH:mm String formatieren
  const formatMinutesToTime = useCallback((minutes: number): string => {
    const hours = Math.floor(minutes / 60)
    const mins = minutes % 60
    return `${String(hours).padStart(2, '0')}:${String(mins).padStart(2, '0')}`
  }, [])

  // Drag für konkrete Slots starten
  const handleSlotMouseDown = useCallback(
    (e: React.MouseEvent, slotId: string, dayIndex: number) => {
      e.preventDefault()
      e.stopPropagation()

      const slot = slots.find((s) => s.id === slotId)
      if (!slot) return

      // Element-Top-Position berechnen
      const col = columnRefsRef.current[dayIndex]
      if (!col) return

      const colRect = col.getBoundingClientRect()
      const slotStyle = getSlotStyle(slot.date, slot.startZeit, slot.endZeit)
      const elementTop = slotStyle.top
      const mouseY = e.clientY - colRect.top + (scrollContainerRef.current?.scrollTop || 0)

      setDragState({
        type: 'slot',
        slotId,
        offsetY: mouseY - elementTop,
        originalDayIndex: dayIndex,
      })

      // Initial Preview setzen
      setDragPreview({
        dayIndex,
        top: snapToGrid(elementTop),
      })
    },
    [slots, snapToGrid]
  )

  // Drag für Muster-Previews starten
  const handlePatternMouseDown = useCallback(
    (e: React.MouseEvent, patternDayIndex: number) => {
      e.preventDefault()
      e.stopPropagation()

      const config = dayTimeConfigs.find((c) => c.dayIndex === patternDayIndex)
      if (!config) return

      const col = columnRefsRef.current[patternDayIndex]
      if (!col) return

      const colRect = col.getBoundingClientRect()
      const endZeit = addMinutesToTime(config.startZeit, duration)
      const style = getSlotStyle(weekDays[patternDayIndex], config.startZeit, endZeit)
      const scrollTop = scrollContainerRef.current?.scrollTop || 0
      const mouseY = e.clientY - colRect.top + scrollTop

      setDragState({
        type: 'pattern',
        dayIndex: patternDayIndex,
        offsetY: mouseY - style.top,
        originalDayIndex: patternDayIndex,
      })

      setDragPreview({
        dayIndex: patternDayIndex,
        top: snapToGrid(style.top),
      })
    },
    [dayTimeConfigs, duration, weekDays, snapToGrid]
  )

  // Global Mouse Events für Drag (Slot und Pattern)
  useEffect(() => {
    if (!dragState) return

    const handleGlobalMouseMove = (e: MouseEvent) => {
      // Bei Pattern-Drag: Nur innerhalb derselben Spalte erlauben
      if (dragState.type === 'pattern') {
        const col = columnRefsRef.current[dragState.dayIndex!]
        if (!col) return

        const colRect = col.getBoundingClientRect()
        const scrollTop = scrollContainerRef.current?.scrollTop || 0
        const mouseY = e.clientY - colRect.top + scrollTop
        const newTop = snapToGrid(mouseY - dragState.offsetY)

        setDragPreview({
          dayIndex: dragState.dayIndex!,
          top: newTop,
        })
      } else {
        // Slot-Drag: Kann zwischen Spalten wechseln
        const dayIndex = getDayIndexFromX(e.clientX)
        if (dayIndex === -1) return

        const col = columnRefsRef.current[dayIndex]
        if (!col) return

        const colRect = col.getBoundingClientRect()
        const scrollTop = scrollContainerRef.current?.scrollTop || 0
        const mouseY = e.clientY - colRect.top + scrollTop
        const newTop = snapToGrid(mouseY - dragState.offsetY)

        setDragPreview({
          dayIndex,
          top: newTop,
        })
      }
    }

    const handleGlobalMouseUp = () => {
      if (!dragState || !dragPreview) {
        setDragState(null)
        setDragPreview(null)
        return
      }

      if (dragState.type === 'pattern') {
        // Pattern-Drag: dayTimeConfig aktualisieren
        const newStartMinutes = getMinutesFromY(dragPreview.top)
        const newStartZeit = formatMinutesToTime(newStartMinutes)
        handleDayTimeChange(dragState.dayIndex!, newStartZeit)
      } else {
        // Slot-Drag: Slot aktualisieren
        const slot = slots.find((s) => s.id === dragState.slotId)
        if (!slot) {
          setDragState(null)
          setDragPreview(null)
          return
        }

        const [startH, startM] = slot.startZeit.split(':').map(Number)
        const [endH, endM] = slot.endZeit.split(':').map(Number)
        const slotDuration = endH * 60 + endM - (startH * 60 + startM)

        const newStartMinutes = getMinutesFromY(dragPreview.top)
        const newEndMinutes = newStartMinutes + slotDuration

        const newDate = weekDays[dragPreview.dayIndex]

        updateSlot(dragState.slotId!, {
          date: newDate,
          startZeit: formatMinutesToTime(newStartMinutes),
          endZeit: formatMinutesToTime(newEndMinutes),
        })
      }

      // Drag beendet - kurzzeitig merken um Click-Event zu ignorieren
      dragJustEndedRef.current = true
      setTimeout(() => {
        dragJustEndedRef.current = false
      }, 50)

      setDragState(null)
      setDragPreview(null)
    }

    document.addEventListener('mousemove', handleGlobalMouseMove)
    document.addEventListener('mouseup', handleGlobalMouseUp)

    return () => {
      document.removeEventListener('mousemove', handleGlobalMouseMove)
      document.removeEventListener('mouseup', handleGlobalMouseUp)
    }
  }, [
    dragState,
    dragPreview,
    slots,
    weekDays,
    updateSlot,
    getDayIndexFromX,
    snapToGrid,
    getMinutesFromY,
    formatMinutesToTime,
    handleDayTimeChange,
  ])

  if (isLoading) {
    return (
      <div className="flex h-64 items-center justify-center">
        <div className="text-muted-foreground">Laden...</div>
      </div>
    )
  }

  return (
    <div className="flex flex-col h-full">
      <PageHeader
        title="Kalender"
        description="Verwalten Sie Ihre Behandlungstermine"
        actions={
          <div className="flex items-center gap-2">
            <KalenderSettingsDialog
              showWeekend={settings.showWeekend}
              onShowWeekendChange={setShowWeekend}
            />
            <Button variant="outline" onClick={goToToday}>
              Heute
            </Button>
            <Button variant="outline" size="icon" onClick={goToPreviousWeek}>
              <ChevronLeft className="h-4 w-4" />
            </Button>
            <span className="min-w-[200px] text-center font-medium">
              {formatWeekRange(currentWeekStart, settings.showWeekend)}
            </span>
            <Button variant="outline" size="icon" onClick={goToNextWeek}>
              <ChevronRight className="h-4 w-4" />
            </Button>
          </div>
        }
      />

      <div className="flex-1 flex overflow-hidden">
        {/* Planungs-Sidebar mit Animation */}
        <div
          className={cn(
            'overflow-hidden transition-all duration-300 ease-in-out',
            planungsModus ? 'w-80 opacity-100' : 'w-0 opacity-0'
          )}
        >
          <PlanungsSidebar
            slots={slots}
            selectedSlotId={selectedSlotId}
            onSlotSelect={setSelectedSlotId}
            onSlotUpdate={updateSlot}
            onSlotRemove={removeSlot}
            onGenerateSeriesFlexible={handleGenerateSeriesFlexible}
            onCancel={handleCancelPlanung}
            onSubmit={handleCreateTermine}
            isLoading={isCreating || isCreatingPatient}
            conflictCount={conflictCount}
            patienten={patienten}
            selectedPatientId={selectedPatientId}
            onPatientChange={setSelectedPatientId}
            defaultCount={defaultCount}
            duration={duration}
            onDurationChange={setDuration}
            behandlungsarten={behandlungsarten}
            selectedBehandlungsartId={selectedBehandlungsartId}
            onBehandlungsartChange={setSelectedBehandlungsartId}
            newPatientForm={newPatientForm}
            onNewPatientFormChange={setNewPatientForm}
            // Neue Props für Zwei-Phasen-Planung
            dayTimeConfigs={dayTimeConfigs}
            onDayToggle={handleDayToggle}
            onDayTimeChange={handleDayTimeChange}
            patternWeekStart={patternWeekStart}
            isSeriesOpen={isSeriesOpen}
            onSeriesOpenChange={setIsSeriesOpen}
            clearSlots={clearSlots}
            showWeekend={settings.showWeekend}
          />
        </div>

        {/* Kalender */}
        <Card
          className={cn(
            '@container flex-1 flex flex-col overflow-hidden transition-all duration-300',
            planungsModus && 'rounded-l-none border-l-0'
          )}
        >
          {/* Header mit Wochentagen - fixiert */}
          <div
            className={cn(
              'grid border-b flex-shrink-0',
              settings.showWeekend
                ? 'grid-cols-[60px_repeat(7,1fr)]'
                : 'grid-cols-[60px_repeat(5,1fr)]'
            )}
          >
            <div className="p-2 bg-muted/50" />
            {weekDays.map((date, i) => (
              <div
                key={i}
                className={cn(
                  'p-2 text-center border-l bg-muted/50',
                  isToday(date) && 'bg-primary/10'
                )}
              >
                <div className="text-sm font-medium">
                  {settings.showWeekend ? (
                    <>
                      <span className="hidden @3xl:inline">{formatWeekday(date, 'long')}</span>
                      <span className="@3xl:hidden">{formatWeekday(date, 'short')}</span>
                    </>
                  ) : (
                    <>
                      <span className="hidden @lg:inline">{formatWeekday(date, 'long')}</span>
                      <span className="@lg:hidden">{formatWeekday(date, 'short')}</span>
                    </>
                  )}
                </div>
                <div className={cn('text-2xl font-bold', isToday(date) && 'text-primary')}>
                  {date.getDate()}
                </div>
              </div>
            ))}
          </div>

          {/* Kalender-Body - scrollbar */}
          <div ref={scrollContainerRef} className="flex-1 overflow-y-auto overflow-x-hidden">
            <div
              className={cn(
                'grid',
                settings.showWeekend
                  ? 'grid-cols-[60px_repeat(7,1fr)]'
                  : 'grid-cols-[60px_repeat(5,1fr)]'
              )}
            >
              {/* Zeitspalte */}
              <div className="relative" style={{ height: TOTAL_HEIGHT }}>
                {Array.from({ length: TOTAL_HOURS }, (_, i) => (
                  <div
                    key={i}
                    className="absolute right-2 text-xs text-muted-foreground"
                    style={{ top: i * HOUR_HEIGHT + 4 }}
                  >
                    {String(i).padStart(2, '0')}:00
                  </div>
                ))}
              </div>

              {/* Tages-Spalten */}
              {weekDays.map((date, dayIndex) => {
                const termine = getTermineForDay(date)
                const daySlots = getSlotsForDay(date)
                return (
                  <div
                    key={dayIndex}
                    ref={(el) => {
                      columnRefsRef.current[dayIndex] = el
                    }}
                    className={cn(
                      'relative border-l',
                      isToday(date) && 'bg-primary/5',
                      dragState ? 'cursor-grabbing' : 'cursor-pointer'
                    )}
                    style={{ height: TOTAL_HEIGHT }}
                    onClick={(e) => !dragState && handleColumnClick(e, dayIndex)}
                  >
                    {/* Stunden-Linien (dezent) */}
                    {Array.from({ length: TOTAL_HOURS }, (_, i) => (
                      <div
                        key={i}
                        className="absolute left-0 right-0 border-t border-dashed border-border/50"
                        style={{ top: i * HOUR_HEIGHT }}
                      />
                    ))}

                    {/* Aktuelle Zeit-Linie */}
                    {isToday(date) && isCurrentWeek(currentWeekStart) && (
                      <div
                        className="absolute left-0 right-0 border-t-2 border-red-500 z-10"
                        style={{ top: getCurrentTimePosition() }}
                      >
                        <div className="absolute -left-1 -top-1.5 w-3 h-3 bg-red-500 rounded-full" />
                      </div>
                    )}

                    {/* Bestehende Termine */}
                    {termine.map((termin) => {
                      const style = getTerminStyle(termin.startZeit, termin.endZeit)
                      return (
                        <div
                          key={termin.id}
                          className="absolute left-1 right-1 rounded-md bg-primary text-primary-foreground p-2 overflow-hidden shadow-sm hover:shadow-md transition-shadow cursor-pointer"
                          style={{ top: style.top, height: style.height - 4 }}
                          onClick={(e) => {
                            e.stopPropagation()
                            if (isMobile) {
                              navigate(`/kalender/termin/${termin.id}`)
                            } else {
                              setSelectedTermin(termin)
                              setTerminAnchorEl(e.currentTarget as HTMLElement)
                            }
                          }}
                        >
                          <div className="font-medium text-sm truncate">{termin.patient.name}</div>
                          <div className="text-xs opacity-80">
                            {formatTime(termin.startZeit)} - {formatTime(termin.endZeit)}
                          </div>
                        </div>
                      )
                    })}

                    {/* Muster-Previews (nur wenn Serie-Akkordeon geöffnet) */}
                    {planungsModus &&
                      isSeriesOpen &&
                      dayTimeConfigs.length > 0 &&
                      dayTimeConfigs.map((config) => {
                        // Nur Mo-Fr anzeigen (dayIndex 0-4)
                        if (config.dayIndex > 4) return null
                        if (config.dayIndex !== dayIndex) return null

                        const endZeit = addMinutesToTime(config.startZeit, duration)
                        const style = getSlotStyle(weekDays[dayIndex], config.startZeit, endZeit)
                        const isBeingDragged =
                          dragState?.type === 'pattern' && dragState.dayIndex === config.dayIndex

                        return (
                          <div
                            key={`pattern-${config.dayIndex}`}
                            onMouseDown={(e) => handlePatternMouseDown(e, config.dayIndex)}
                            className={cn(
                              'absolute left-1 right-1 rounded-md p-2 shadow-sm border-2 border-dashed cursor-grab select-none',
                              PATTERN_COLORS.bg,
                              PATTERN_COLORS.border,
                              PATTERN_COLORS.text,
                              isBeingDragged && 'opacity-50 cursor-grabbing'
                            )}
                            style={{ top: style.top, height: style.height - 4 }}
                            onClick={(e) => e.stopPropagation()}
                          >
                            <div className="font-medium text-xs">
                              {WEEKDAY_NAMES_SHORT[config.dayIndex]}
                            </div>
                            <div className="text-xs opacity-90">
                              {config.startZeit} - {endZeit}
                            </div>
                          </div>
                        )
                      })}

                    {/* Geplante Slots im Planungsmodus (nur wenn Akkordeon geschlossen) */}
                    {planungsModus &&
                      !isSeriesOpen &&
                      slots.length > 0 &&
                      daySlots.map((slot) => {
                        const style = getSlotStyle(slot.date, slot.startZeit, slot.endZeit)
                        const isDragging =
                          dragState?.type === 'slot' && dragState.slotId === slot.id
                        const colors = slot.hasConflict ? CONFLICT_COLORS : SLOT_COLORS
                        return (
                          <div
                            key={slot.id}
                            onMouseDown={(e) => handleSlotMouseDown(e, slot.id, dayIndex)}
                            className={cn(
                              'absolute left-1 right-1 rounded-md p-2 overflow-hidden shadow-sm border-2 select-none',
                              colors.bg,
                              colors.border,
                              colors.text,
                              isDragging ? 'cursor-grabbing opacity-50' : 'cursor-grab',
                              selectedSlotId === slot.id &&
                                !isDragging &&
                                'ring-2 ring-offset-1 ring-primary'
                            )}
                            style={{ top: style.top, height: style.height - 4 }}
                            onClick={(e) => {
                              e.stopPropagation()
                              if (!dragState) {
                                setSelectedSlotId(selectedSlotId === slot.id ? null : slot.id)
                              }
                            }}
                          >
                            <div className="font-medium text-sm truncate">
                              {slot.hasConflict ? 'Konflikt!' : 'Termin'}
                            </div>
                            <div className="text-xs opacity-80">
                              {slot.startZeit} - {slot.endZeit}
                            </div>
                          </div>
                        )
                      })}

                    {/* Drag Preview Ghost Element für Slots */}
                    {dragState?.type === 'slot' &&
                      dragPreview &&
                      dragPreview.dayIndex === dayIndex &&
                      (() => {
                        const draggingSlot = slots.find((s) => s.id === dragState.slotId)
                        if (!draggingSlot) return null
                        const style = getSlotStyle(
                          draggingSlot.date,
                          draggingSlot.startZeit,
                          draggingSlot.endZeit
                        )
                        return (
                          <div
                            className="absolute left-1 right-1 rounded-md p-2 overflow-hidden shadow-lg border-2 border-primary bg-primary/20 pointer-events-none z-20"
                            style={{ top: dragPreview.top, height: style.height }}
                          >
                            <div className="font-medium text-sm truncate text-primary">Termin</div>
                            <div className="text-xs text-primary/80">
                              {formatMinutesToTime(getMinutesFromY(dragPreview.top))} -{' '}
                              {formatMinutesToTime(
                                getMinutesFromY(dragPreview.top) +
                                  (parseInt(draggingSlot.endZeit.split(':')[0]) * 60 +
                                    parseInt(draggingSlot.endZeit.split(':')[1]) -
                                    (parseInt(draggingSlot.startZeit.split(':')[0]) * 60 +
                                      parseInt(draggingSlot.startZeit.split(':')[1])))
                              )}
                            </div>
                          </div>
                        )
                      })()}

                    {/* Drag Preview Ghost Element für Muster */}
                    {dragState?.type === 'pattern' &&
                      dragPreview &&
                      dragPreview.dayIndex === dayIndex &&
                      (() => {
                        const config = dayTimeConfigs.find((c) => c.dayIndex === dragState.dayIndex)
                        if (!config) return null
                        const endZeit = addMinutesToTime(config.startZeit, duration)
                        const style = getSlotStyle(weekDays[dayIndex], config.startZeit, endZeit)
                        return (
                          <div
                            className={cn(
                              'absolute left-1 right-1 rounded-md p-2 overflow-hidden shadow-lg border-2 pointer-events-none z-20',
                              'bg-blue-500/30 border-blue-500'
                            )}
                            style={{ top: dragPreview.top, height: style.height }}
                          >
                            <div className="font-medium text-xs text-blue-600">
                              {WEEKDAY_NAMES_SHORT[config.dayIndex]}
                            </div>
                            <div className="text-xs text-blue-500">
                              {formatMinutesToTime(getMinutesFromY(dragPreview.top))} -{' '}
                              {formatMinutesToTime(getMinutesFromY(dragPreview.top) + duration)}
                            </div>
                          </div>
                        )
                      })()}
                  </div>
                )
              })}
            </div>
          </div>
        </Card>
      </div>

      {/* Termin-Detail-Popover (nur Desktop) */}
      {selectedTermin && !isMobile && (
        <BehandlungDetailPopover
          behandlung={selectedTermin}
          behandlungsarten={behandlungsarten}
          open={!!selectedTermin}
          onOpenChange={(open) => {
            if (!open) {
              setSelectedTermin(null)
              setTerminAnchorEl(null)
            }
          }}
          anchorEl={terminAnchorEl}
        />
      )}
    </div>
  )
}
