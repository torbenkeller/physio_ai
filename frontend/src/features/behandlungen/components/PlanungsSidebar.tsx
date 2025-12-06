import { useState, useEffect } from 'react'
import { X, Calendar, Trash2, Plus, MousePointer, AlertTriangle } from 'lucide-react'
import { Button } from '@/shared/components/ui/button'
import { Input } from '@/shared/components/ui/input'
import { TimeInput } from '@/shared/components/ui/time-input'
import { Label } from '@/shared/components/ui/label'
import { Separator } from '@/shared/components/ui/separator'
import { ScrollArea } from '@/shared/components/ui/scroll-area'
import { PlanungSlotCard } from './PlanungSlotCard'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/shared/components/ui/select'
import { cn } from '@/shared/utils'
import { addMinutesToTime } from '../utils/kalenderUtils'
import type { SelectedTimeSlot, SeriesConfig, DayTimeConfig } from '../types/behandlung.types'
import type { PatientDto } from '@/features/patienten/types/patient.types'
import type { BehandlungsartDto } from '@/features/rezepte/types/rezept.types'

// Spezielle ID für "Neuer Patient" Option
export const NEW_PATIENT_ID = '__new__'

export interface NewPatientForm {
  vorname: string
  nachname: string
  telMobil: string
}

interface PlanungsSidebarProps {
  slots: SelectedTimeSlot[]
  selectedSlotId: string | null
  onSlotSelect: (slotId: string | null) => void
  onSlotUpdate: (slotId: string, updates: Partial<Omit<SelectedTimeSlot, 'id'>>) => void
  onSlotRemove: (slotId: string) => void
  onGenerateSeriesFlexible: (firstSlot: SelectedTimeSlot, config: SeriesConfig, count: number) => void
  onCancel: () => void
  onSubmit: (force: boolean) => void
  isLoading: boolean
  conflictCount: number
  patienten: PatientDto[] | undefined
  selectedPatientId: string
  onPatientChange: (patientId: string) => void
  defaultCount: number
  duration: number
  onDurationChange: (duration: number) => void
  // Behandlungsart
  behandlungsarten: BehandlungsartDto[] | undefined
  selectedBehandlungsartId: string
  onBehandlungsartChange: (id: string) => void
  // Neuer Patient
  newPatientForm: NewPatientForm
  onNewPatientFormChange: (form: NewPatientForm) => void
  // Zwei-Phasen-Planung
  dayTimeConfigs: DayTimeConfig[]
  onDayToggle: (dayIndex: number) => void
  onDayTimeChange: (dayIndex: number, startZeit: string) => void
  patternWeekStart: Date | null
  onAddSingleSlot: () => void
  addingSingleSlot: boolean
  onCancelAddSingleSlot: () => void
  clearSlots: () => void
}

const DURATION_OPTIONS = [
  { value: 30, label: '30 Min' },
  { value: 45, label: '45 Min' },
  { value: 60, label: '60 Min' },
  { value: 90, label: '90 Min' },
  { value: 120, label: '120 Min' },
]

const WEEK_DAYS = [
  { index: 0, short: 'Mo', long: 'Montag' },
  { index: 1, short: 'Di', long: 'Dienstag' },
  { index: 2, short: 'Mi', long: 'Mittwoch' },
  { index: 3, short: 'Do', long: 'Donnerstag' },
  { index: 4, short: 'Fr', long: 'Freitag' },
  { index: 5, short: 'Sa', long: 'Samstag' },
  { index: 6, short: 'So', long: 'Sonntag' },
]

export const PlanungsSidebar = ({
  slots,
  selectedSlotId,
  onSlotSelect,
  onSlotUpdate,
  onSlotRemove,
  onGenerateSeriesFlexible,
  onCancel,
  onSubmit,
  isLoading,
  conflictCount,
  patienten,
  selectedPatientId,
  onPatientChange,
  defaultCount,
  duration,
  onDurationChange,
  behandlungsarten,
  selectedBehandlungsartId,
  onBehandlungsartChange,
  newPatientForm,
  onNewPatientFormChange,
  // Neue Props für Zwei-Phasen-Planung
  dayTimeConfigs,
  onDayToggle,
  onDayTimeChange,
  patternWeekStart,
  onAddSingleSlot,
  addingSingleSlot,
  onCancelAddSingleSlot,
  clearSlots,
}: PlanungsSidebarProps) => {
  const [count, setCount] = useState(defaultCount)
  const [repeatEveryWeeks, setRepeatEveryWeeks] = useState(1)

  // Aktualisiere count wenn defaultCount sich ändert (neuer Patient ausgewählt)
  useEffect(() => {
    setCount(defaultCount)
  }, [defaultCount])

  // Der Wochentag des ersten Musters (kann nicht abgewählt werden)
  const firstDayIndex = dayTimeConfigs[0]?.dayIndex ?? null

  const isDaySelected = (dayIndex: number) =>
    dayTimeConfigs.some(c => c.dayIndex === dayIndex)

  const handleGenerateSeries = () => {
    if (dayTimeConfigs.length === 0 || !patternWeekStart) return

    // Bestehende Slots löschen (Neu-Generierung)
    clearSlots()

    // Ersten Termin aus Muster berechnen
    const firstConfig = dayTimeConfigs[0]
    const firstDate = new Date(patternWeekStart)
    firstDate.setDate(firstDate.getDate() + firstConfig.dayIndex)

    const endZeit = addMinutesToTime(firstConfig.startZeit, duration)

    const slot: SelectedTimeSlot = {
      id: crypto.randomUUID(),
      date: firstDate,
      startZeit: firstConfig.startZeit,
      endZeit,
    }

    const config: SeriesConfig = {
      repeatEveryWeeks,
      selectedDays: dayTimeConfigs.map(c => c.dayIndex),
      dayTimeConfigs,
    }

    onGenerateSeriesFlexible(slot, config, count)
  }

  const selectedPatientData = patienten?.find((p) => p.id === selectedPatientId)

  return (
    <div className="w-80 flex flex-col h-full border-r bg-background">
      {/* Header */}
      <div className="p-4 pt-[17px] border-b flex items-center justify-between">
        <div className="flex items-center gap-2">
          <Calendar className="h-5 w-5" />
          <h2 className="font-semibold">Termine planen</h2>
        </div>
        <Button variant="ghost" size="icon" onClick={onCancel}>
          <X className="h-4 w-4" />
        </Button>
      </div>

      <ScrollArea className="flex-1">
        <div className="p-4 space-y-6">
          {/* Patient Selection */}
          <div className="space-y-2">
            <Label>Patient</Label>
            <Select value={selectedPatientId} onValueChange={onPatientChange}>
              <SelectTrigger>
                <SelectValue placeholder="Patient auswählen..." />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value={NEW_PATIENT_ID}>+ Neuer Patient</SelectItem>
                {patienten?.map((patient) => (
                  <SelectItem key={patient.id} value={patient.id}>
                    {patient.vorname} {patient.nachname}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
            {selectedPatientId === NEW_PATIENT_ID && (
              <div className="space-y-2 pt-2">
                <Input
                  placeholder="Vorname *"
                  value={newPatientForm.vorname}
                  onChange={(e) =>
                    onNewPatientFormChange({ ...newPatientForm, vorname: e.target.value })
                  }
                />
                <Input
                  placeholder="Nachname *"
                  value={newPatientForm.nachname}
                  onChange={(e) =>
                    onNewPatientFormChange({ ...newPatientForm, nachname: e.target.value })
                  }
                />
                <Input
                  placeholder="Telefon (optional)"
                  value={newPatientForm.telMobil}
                  onChange={(e) =>
                    onNewPatientFormChange({ ...newPatientForm, telMobil: e.target.value })
                  }
                />
              </div>
            )}
            {selectedPatientData && selectedPatientData.behandlungenProRezept && (
              <p className="text-xs text-muted-foreground">
                {selectedPatientData.behandlungenProRezept} Termine/Rezept
              </p>
            )}
          </div>

          {/* Behandlungsart Selection */}
          <div className="space-y-2">
            <Label>Behandlungsart</Label>
            <Select value={selectedBehandlungsartId} onValueChange={onBehandlungsartChange}>
              <SelectTrigger>
                <SelectValue placeholder="Behandlungsart auswählen..." />
              </SelectTrigger>
              <SelectContent>
                {behandlungsarten?.map((art) => (
                  <SelectItem key={art.id} value={art.id}>
                    {art.name}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          <Separator />

          {/* Series Creator */}
          <div className="space-y-4">
            <div className="text-sm font-medium">Muster definieren</div>

            {dayTimeConfigs.length > 0 ? (
              <>
                <div className="space-y-1">
                  <Label className="text-xs">Dauer</Label>
                  <Select value={String(duration)} onValueChange={(v) => onDurationChange(parseInt(v))}>
                    <SelectTrigger className="h-8">
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      {DURATION_OPTIONS.map((opt) => (
                        <SelectItem key={opt.value} value={String(opt.value)}>
                          {opt.label}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>

                <div className="space-y-1">
                  <Label className="text-xs">Wiederholen alle</Label>
                  <div className="flex items-center gap-2">
                    <Input
                      type="number"
                      min={1}
                      max={12}
                      value={repeatEveryWeeks}
                      onChange={(e) => setRepeatEveryWeeks(parseInt(e.target.value) || 1)}
                      className="h-8 w-16"
                    />
                    <span className="text-sm text-muted-foreground">Woche(n)</span>
                  </div>
                </div>

                <div className="space-y-1">
                  <Label className="text-xs">An diesen Tagen</Label>
                  <div className="space-y-2">
                    {/* Wochentag-Buttons */}
                    <div className="flex gap-1">
                      {WEEK_DAYS.map((day) => {
                        const isFirstDay = day.index === firstDayIndex
                        const isSelected = isDaySelected(day.index)
                        return (
                          <button
                            key={day.index}
                            type="button"
                            onClick={() => onDayToggle(day.index)}
                            className={cn(
                              'flex-1 h-8 text-xs font-medium rounded-md border transition-colors',
                              isSelected
                                ? 'bg-primary text-primary-foreground border-primary'
                                : 'bg-background hover:bg-muted border-input',
                              isFirstDay && 'cursor-default opacity-90'
                            )}
                            title={isFirstDay ? `${day.long} (Erster Tag)` : day.long}
                          >
                            {day.short}
                          </button>
                        )
                      })}
                    </div>

                    {/* Zeit-Inputs für ausgewählte Tage */}
                    {dayTimeConfigs.length > 0 && (
                      <div className="space-y-1 pt-1">
                        {dayTimeConfigs.map(({ dayIndex, startZeit }) => {
                          const day = WEEK_DAYS.find(d => d.index === dayIndex)!
                          return (
                            <div key={dayIndex} className="flex items-center gap-2">
                              <span className="text-xs text-muted-foreground w-10">
                                {day.short}
                              </span>
                              <TimeInput
                                value={startZeit}
                                onChange={(value) => onDayTimeChange(dayIndex, value)}
                                className="h-8 w-20 text-xs"
                                aria-label={`Startzeit für ${day.long}`}
                              />
                            </div>
                          )
                        })}
                      </div>
                    )}
                  </div>
                </div>

                <div className="space-y-1">
                  <Label className="text-xs">Anzahl Termine</Label>
                  <Input
                    type="number"
                    min={1}
                    max={52}
                    value={count}
                    onChange={(e) => setCount(parseInt(e.target.value) || 1)}
                    className="h-8"
                  />
                </div>

                <Button
                  onClick={handleGenerateSeries}
                  className="w-full"
                  variant="default"
                  size="sm"
                >
                  {count} Termine generieren
                </Button>
              </>
            ) : (
              <div className="text-sm text-muted-foreground text-center py-4">
                Klicke in den Kalender, um das Muster zu definieren
              </div>
            )}
          </div>

          <Separator />

          {/* Slots List */}
          <div className="space-y-3">
            <div className="flex items-center justify-between">
              <div className="text-sm font-medium">
                Termine ({slots.length})
              </div>
              {slots.length > 0 && (
                <Button
                  variant="ghost"
                  size="sm"
                  className="h-7 text-xs"
                  onClick={clearSlots}
                >
                  <Trash2 className="h-3 w-3 mr-1" />
                  Alle löschen
                </Button>
              )}
            </div>

            {/* Hinweis wenn noch keine Termine generiert */}
            {slots.length === 0 && dayTimeConfigs.length > 0 && (
              <div className="text-sm text-muted-foreground text-center py-4">
                Klicke auf "Termine generieren" um die Serie zu erstellen
              </div>
            )}

            {slots.length === 0 && dayTimeConfigs.length === 0 && (
              <div className="text-sm text-muted-foreground text-center py-4">
                Noch keine Termine geplant
              </div>
            )}

            {slots.length > 0 && (
              <div className="space-y-2">
                {slots.map((slot, index) => (
                  <PlanungSlotCard
                    key={slot.id}
                    slot={slot}
                    index={index}
                    isSelected={selectedSlotId === slot.id}
                    onSelect={onSlotSelect}
                    onUpdate={onSlotUpdate}
                    onRemove={onSlotRemove}
                  />
                ))}
              </div>
            )}

            {/* Einzeltermin hinzufügen Button */}
            {slots.length > 0 && (
              addingSingleSlot ? (
                <div className="flex items-center gap-2 p-2 rounded-md bg-emerald-500/10 text-emerald-700 text-sm">
                  <MousePointer className="h-4 w-4" />
                  <span className="flex-1">Klicke in den Kalender...</span>
                  <Button
                    variant="ghost"
                    size="sm"
                    className="h-7"
                    onClick={onCancelAddSingleSlot}
                  >
                    Abbrechen
                  </Button>
                </div>
              ) : (
                <Button
                  variant="outline"
                  size="sm"
                  className="w-full"
                  onClick={onAddSingleSlot}
                >
                  <Plus className="h-4 w-4 mr-1" />
                  Einzeltermin hinzufügen
                </Button>
              )
            )}
          </div>
        </div>
      </ScrollArea>

      {/* Footer with Actions */}
      <div className="p-4 border-t space-y-3">
        {conflictCount > 0 && (
          <div className="flex items-center gap-2 p-2 rounded-md bg-amber-500/10 text-amber-700 text-sm">
            <AlertTriangle className="h-4 w-4" />
            <span>{conflictCount} Konflikt{conflictCount > 1 ? 'e' : ''} gefunden</span>
          </div>
        )}

        <div className="flex gap-2">
          <Button variant="outline" onClick={onCancel} className="flex-1">
            Abbrechen
          </Button>
          {(() => {
            // Validierung: Patient muss ausgewählt sein, und bei "Neuer Patient" müssen Vorname/Nachname ausgefüllt sein
            const isNewPatient = selectedPatientId === NEW_PATIENT_ID
            const newPatientValid = isNewPatient
              ? newPatientForm.vorname.trim() !== '' && newPatientForm.nachname.trim() !== ''
              : true
            const patientValid = selectedPatientId && (isNewPatient ? newPatientValid : true)
            const isDisabled = !patientValid || slots.length === 0 || isLoading

            return conflictCount > 0 ? (
              <Button
                onClick={() => onSubmit(true)}
                disabled={isDisabled}
                variant="destructive"
                className="flex-1"
              >
                {isLoading ? 'Erstellen...' : 'Trotzdem erstellen'}
              </Button>
            ) : (
              <Button
                onClick={() => onSubmit(false)}
                disabled={isDisabled}
                className="flex-1"
              >
                {isLoading
                  ? 'Erstellen...'
                  : `${slots.length} Termine erstellen`}
              </Button>
            )
          })()}
        </div>
      </div>
    </div>
  )
}
