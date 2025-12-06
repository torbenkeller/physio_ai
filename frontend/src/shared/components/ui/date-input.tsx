"use client"

import * as React from "react"
import { format, parse, isValid, addYears, subYears } from "date-fns"
import { de } from "date-fns/locale"
import { CalendarIcon } from "lucide-react"

import { cn } from "@/shared/utils"
import { Button } from "@/shared/components/ui/button"
import { Calendar } from "@/shared/components/ui/calendar"
import { Input } from "@/shared/components/ui/input"
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

function formatDate(date: Date): string {
  return format(date, "dd.MM.yyyy", { locale: de })
}

function parseDate(value: string): Date | null {
  const parsed = parse(value, "dd.MM.yyyy", new Date(), { locale: de })
  return isValid(parsed) ? parsed : null
}

export function DateInput({ value, onChange, className, disabled }: DateInputProps) {
  const [open, setOpen] = React.useState(false)
  const [month, setMonth] = React.useState<Date>(value)
  const [inputValue, setInputValue] = React.useState(formatDate(value))

  // Memoize date range to prevent re-renders
  const dateRange = React.useMemo(() => {
    const now = new Date()
    return {
      start: subYears(now, 5),
      end: addYears(now, 5)
    }
  }, [])

  // Sync inputValue und month wenn value sich von außen ändert
  // Verwende getTime() um nur bei tatsächlicher Datumsänderung zu triggern
  const valueTime = value.getTime()
  React.useEffect(() => {
    setInputValue(formatDate(value))
    setMonth(value)
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [valueTime])

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const newValue = e.target.value
    setInputValue(newValue)

    const parsed = parseDate(newValue)
    if (parsed) {
      onChange(parsed)
      setMonth(parsed)
    }
  }

  const handleInputBlur = () => {
    // Bei ungültigem Datum auf vorherigen Wert zurücksetzen
    const parsed = parseDate(inputValue)
    if (!parsed) {
      setInputValue(formatDate(value))
    }
  }

  const handleKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === "ArrowDown") {
      e.preventDefault()
      setOpen(true)
    }
  }

  const handleSelect = React.useCallback((date: Date | undefined) => {
    if (date) {
      onChange(date)
      setInputValue(formatDate(date))
      setOpen(false)
    }
  }, [onChange])

  return (
    <div className={cn("relative flex items-center", className)}>
      <Input
        value={inputValue}
        placeholder="TT.MM.JJJJ"
        className="bg-background pr-8 flex-1"
        onChange={handleInputChange}
        onBlur={handleInputBlur}
        onKeyDown={handleKeyDown}
        disabled={disabled}
      />
      <Popover open={open} onOpenChange={setOpen}>
        <PopoverTrigger asChild>
          <Button
            variant="ghost"
            size="icon"
            className="absolute right-1 h-6 w-6"
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
