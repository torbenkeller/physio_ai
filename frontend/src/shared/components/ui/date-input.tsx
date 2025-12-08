"use client"

import * as React from "react"
import { addYears, subYears } from "date-fns"
import { de } from "date-fns/locale"
import { CalendarIcon } from "lucide-react"

import { cn } from "@/shared/utils"
import { Button } from "@/shared/components/ui/button"
import { Calendar } from "@/shared/components/ui/calendar"
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from "@/shared/components/ui/popover"

interface DateInputProps {
  value: Date
  onChange: (date: Date) => void
  className?: string
  disabled?: boolean
}

/**
 * Segment-basierte Datumseingabe mit 3 separaten Feldern (TT.MM.JJJJ)
 *
 * Features:
 * - Nur Zahlen erlaubt (inputMode="numeric" für Mobile)
 * - Pfeiltasten zum Inkrementieren/Dekrementieren
 * - Kalender-Popup als alternative Eingabemethode
 * - ARIA Labels für Screen-Reader
 *
 * Basiert auf GOV.UK Date Input Pattern Best Practices
 */
export function DateInput({ value, onChange, className, disabled }: DateInputProps) {
  const [open, setOpen] = React.useState(false)
  const [month, setMonth] = React.useState<Date>(value)

  // Separate state für Tag, Monat, Jahr
  const [day, setDay] = React.useState(() => String(value.getDate()).padStart(2, '0'))
  const [monthValue, setMonthValue] = React.useState(() => String(value.getMonth() + 1).padStart(2, '0'))
  const [year, setYear] = React.useState(() => String(value.getFullYear()))

  // Date range für Kalender
  const dateRange = React.useMemo(() => {
    const now = new Date()
    return {
      start: subYears(now, 5),
      end: addYears(now, 5)
    }
  }, [])

  // Sync wenn value sich von außen ändert
  // Aber nur wenn der externe Wert wirklich anders ist als unser lokaler State
  // (verhindert Überschreiben während User tippt)
  const valueTime = value.getTime()
  React.useEffect(() => {
    const localDay = parseInt(day, 10) || 0
    const localMonth = parseInt(monthValue, 10) || 0
    const localYear = parseInt(year, 10) || 0

    const externalDay = value.getDate()
    const externalMonth = value.getMonth() + 1
    const externalYear = value.getFullYear()

    // Nur updaten wenn sich das Datum wirklich geändert hat
    if (localDay !== externalDay || localMonth !== externalMonth || localYear !== externalYear) {
      setDay(String(externalDay).padStart(2, '0'))
      setMonthValue(String(externalMonth).padStart(2, '0'))
      setYear(String(externalYear))
      setMonth(value)
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [valueTime])

  // Helper: Erstelle neues Date und rufe onChange auf
  const updateDate = React.useCallback((newDay: number, newMonth: number, newYear: number) => {
    // Validiere Ranges
    const validMonth = Math.max(1, Math.min(12, newMonth))
    const maxDay = new Date(newYear, validMonth, 0).getDate() // Letzter Tag des Monats
    const validDay = Math.max(1, Math.min(maxDay, newDay))

    const newDate = new Date(newYear, validMonth - 1, validDay)
    if (!isNaN(newDate.getTime())) {
      onChange(newDate)
    }
  }, [onChange])

  // Filter: Nur Zahlen durchlassen
  const filterNumeric = (value: string): string => {
    return value.replace(/\D/g, '')
  }

  // Handler für Tag
  const handleDayChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const filtered = filterNumeric(e.target.value)
    if (filtered.length <= 2) {
      setDay(filtered)
      const numDay = parseInt(filtered, 10)
      if (!isNaN(numDay) && filtered.length > 0) {
        updateDate(numDay, parseInt(monthValue, 10) || 1, parseInt(year, 10) || new Date().getFullYear())
      }
    }
  }

  const handleDayBlur = () => {
    const numDay = parseInt(day, 10) || 1
    const maxDay = new Date(parseInt(year, 10) || new Date().getFullYear(), parseInt(monthValue, 10) || 1, 0).getDate()
    const validDay = Math.max(1, Math.min(maxDay, numDay))
    setDay(String(validDay).padStart(2, '0'))
    updateDate(validDay, parseInt(monthValue, 10) || 1, parseInt(year, 10) || new Date().getFullYear())
  }

  // Handler für Monat
  const handleMonthChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const filtered = filterNumeric(e.target.value)
    if (filtered.length <= 2) {
      setMonthValue(filtered)
      const numMonth = parseInt(filtered, 10)
      if (!isNaN(numMonth) && filtered.length > 0) {
        updateDate(parseInt(day, 10) || 1, numMonth, parseInt(year, 10) || new Date().getFullYear())
      }
    }
  }

  const handleMonthBlur = () => {
    const numMonth = parseInt(monthValue, 10) || 1
    const validMonth = Math.max(1, Math.min(12, numMonth))
    setMonthValue(String(validMonth).padStart(2, '0'))
    updateDate(parseInt(day, 10) || 1, validMonth, parseInt(year, 10) || new Date().getFullYear())
  }

  // Handler für Jahr
  const handleYearChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const filtered = filterNumeric(e.target.value)
    if (filtered.length <= 4) {
      setYear(filtered)
      const numYear = parseInt(filtered, 10)
      if (!isNaN(numYear) && filtered.length === 4) {
        updateDate(parseInt(day, 10) || 1, parseInt(monthValue, 10) || 1, numYear)
      }
    }
  }

  const handleYearBlur = () => {
    let numYear = parseInt(year, 10)
    if (isNaN(numYear) || year.length < 4) {
      numYear = new Date().getFullYear()
    }
    setYear(String(numYear))
    updateDate(parseInt(day, 10) || 1, parseInt(monthValue, 10) || 1, numYear)
  }

  // Focus Handler: Text selektieren für schnelles Überschreiben
  const handleFocus = (e: React.FocusEvent<HTMLInputElement>) => {
    e.target.select()
  }

  // KeyDown Handler für Pfeiltasten (wie TimeInput)
  const handleKeyDown = (
    e: React.KeyboardEvent<HTMLInputElement>,
    type: 'day' | 'month' | 'year'
  ) => {
    if (e.key === 'ArrowUp' || e.key === 'ArrowDown') {
      e.preventDefault()
      const delta = e.key === 'ArrowUp' ? 1 : -1

      if (type === 'day') {
        const currentDay = parseInt(day, 10) || 1
        const maxDay = new Date(parseInt(year, 10) || new Date().getFullYear(), parseInt(monthValue, 10) || 1, 0).getDate()
        let newDay = currentDay + delta
        if (newDay > maxDay) newDay = 1
        if (newDay < 1) newDay = maxDay
        setDay(String(newDay).padStart(2, '0'))
        updateDate(newDay, parseInt(monthValue, 10) || 1, parseInt(year, 10) || new Date().getFullYear())
      } else if (type === 'month') {
        const currentMonth = parseInt(monthValue, 10) || 1
        let newMonth = currentMonth + delta
        if (newMonth > 12) newMonth = 1
        if (newMonth < 1) newMonth = 12
        setMonthValue(String(newMonth).padStart(2, '0'))
        updateDate(parseInt(day, 10) || 1, newMonth, parseInt(year, 10) || new Date().getFullYear())
      } else {
        const currentYear = parseInt(year, 10) || new Date().getFullYear()
        const newYear = currentYear + delta
        setYear(String(newYear))
        updateDate(parseInt(day, 10) || 1, parseInt(monthValue, 10) || 1, newYear)
      }
    }
  }

  // Kalender-Auswahl
  const handleSelect = React.useCallback((date: Date | undefined) => {
    if (date) {
      onChange(date)
      setDay(String(date.getDate()).padStart(2, '0'))
      setMonthValue(String(date.getMonth() + 1).padStart(2, '0'))
      setYear(String(date.getFullYear()))
      setOpen(false)
    }
  }, [onChange])

  return (
    <div
      className={cn(
        'flex h-9 items-center rounded-md border border-input bg-background px-2 text-sm shadow-sm ring-offset-background',
        'focus-within:outline-none focus-within:ring-2 focus-within:ring-ring focus-within:ring-offset-2',
        disabled && 'cursor-not-allowed opacity-50',
        className
      )}
    >
      {/* Tag */}
      <input
        type="text"
        inputMode="numeric"
        maxLength={2}
        value={day}
        onChange={handleDayChange}
        onBlur={handleDayBlur}
        onFocus={handleFocus}
        onKeyDown={(e) => handleKeyDown(e, 'day')}
        className="w-5 bg-transparent text-center outline-none"
        aria-label="Tag"
        disabled={disabled}
        placeholder="TT"
      />
      <span className="text-muted-foreground text-xs">.</span>

      {/* Monat */}
      <input
        type="text"
        inputMode="numeric"
        maxLength={2}
        value={monthValue}
        onChange={handleMonthChange}
        onBlur={handleMonthBlur}
        onFocus={handleFocus}
        onKeyDown={(e) => handleKeyDown(e, 'month')}
        className="w-5 bg-transparent text-center outline-none"
        aria-label="Monat"
        disabled={disabled}
        placeholder="MM"
      />
      <span className="text-muted-foreground text-xs">.</span>

      {/* Jahr */}
      <input
        type="text"
        inputMode="numeric"
        maxLength={4}
        value={year}
        onChange={handleYearChange}
        onBlur={handleYearBlur}
        onFocus={handleFocus}
        onKeyDown={(e) => handleKeyDown(e, 'year')}
        className="w-8 bg-transparent text-center outline-none"
        aria-label="Jahr"
        disabled={disabled}
        placeholder="JJJJ"
      />

      {/* Kalender-Button - am Ende des Containers */}
      <Popover open={open} onOpenChange={setOpen}>
        <PopoverTrigger asChild>
          <Button
            variant="ghost"
            size="icon"
            className="ml-auto h-6 w-6 flex-shrink-0"
            disabled={disabled}
          >
            <CalendarIcon className="h-3.5 w-3.5" />
            <span className="sr-only">Kalender öffnen</span>
          </Button>
        </PopoverTrigger>
        <PopoverContent className="w-auto p-0 overflow-hidden" align="end" side="bottom" avoidCollisions={false}>
          <Calendar
            mode="single"
            selected={value}
            onSelect={handleSelect}
            locale={de}
            weekStartsOn={1}
            month={month}
            onMonthChange={setMonth}
            captionLayout="dropdown"
            startMonth={dateRange.start}
            endMonth={dateRange.end}
          />
        </PopoverContent>
      </Popover>
    </div>
  )
}
