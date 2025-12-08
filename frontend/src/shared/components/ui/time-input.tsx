import * as React from 'react'
import { cn } from '@/shared/utils'

export interface TimeInputProps
  extends Omit<React.InputHTMLAttributes<HTMLInputElement>, 'value' | 'onChange'> {
  value: string // HH:mm format
  onChange: (value: string) => void
}

/**
 * 24-Stunden Zeit-Input Komponente.
 * Zeigt immer im 24h-Format an, unabhängig von Browser-Locale.
 */
const TimeInput = React.forwardRef<HTMLInputElement, TimeInputProps>(
  ({ className, value, onChange, ...props }, ref) => {
    // Parse value into hours and minutes
    const [hours, minutes] = (value || '00:00').split(':').map((v) => v || '00')

    const handleHoursChange = (e: React.ChangeEvent<HTMLInputElement>) => {
      let h = parseInt(e.target.value, 10)
      if (isNaN(h)) h = 0
      if (h > 23) h = 23
      if (h < 0) h = 0
      onChange(`${String(h).padStart(2, '0')}:${minutes}`)
    }

    const handleMinutesChange = (e: React.ChangeEvent<HTMLInputElement>) => {
      let m = parseInt(e.target.value, 10)
      if (isNaN(m)) m = 0
      if (m > 59) m = 59
      if (m < 0) m = 0
      onChange(`${hours}:${String(m).padStart(2, '0')}`)
    }

    const handleHoursBlur = (e: React.FocusEvent<HTMLInputElement>) => {
      // Ensure proper formatting on blur
      const h = parseInt(e.target.value, 10) || 0
      onChange(`${String(Math.min(23, Math.max(0, h))).padStart(2, '0')}:${minutes}`)
    }

    const handleMinutesBlur = (e: React.FocusEvent<HTMLInputElement>) => {
      // Ensure proper formatting on blur
      const m = parseInt(e.target.value, 10) || 0
      onChange(`${hours}:${String(Math.min(59, Math.max(0, m))).padStart(2, '0')}`)
    }

    // Focus Handler: Text selektieren für schnelles Überschreiben
    const handleFocus = (e: React.FocusEvent<HTMLInputElement>) => {
      e.target.select()
    }

    const handleKeyDown = (
      e: React.KeyboardEvent<HTMLInputElement>,
      type: 'hours' | 'minutes'
    ) => {
      const input = e.currentTarget
      const currentValue = parseInt(input.value, 10) || 0
      const max = type === 'hours' ? 23 : 59

      if (e.key === 'ArrowUp') {
        e.preventDefault()
        const newValue = currentValue >= max ? 0 : currentValue + 1
        if (type === 'hours') {
          onChange(`${String(newValue).padStart(2, '0')}:${minutes}`)
        } else {
          onChange(`${hours}:${String(newValue).padStart(2, '0')}`)
        }
      } else if (e.key === 'ArrowDown') {
        e.preventDefault()
        const newValue = currentValue <= 0 ? max : currentValue - 1
        if (type === 'hours') {
          onChange(`${String(newValue).padStart(2, '0')}:${minutes}`)
        } else {
          onChange(`${hours}:${String(newValue).padStart(2, '0')}`)
        }
      }
    }

    return (
      <div
        className={cn(
          'flex h-9 items-center rounded-md border border-input bg-background px-2 text-sm shadow-sm ring-offset-background',
          'focus-within:outline-none focus-within:ring-2 focus-within:ring-ring focus-within:ring-offset-2',
          props.disabled && 'cursor-not-allowed opacity-50',
          className
        )}
      >
        <input
          ref={ref}
          type="text"
          inputMode="numeric"
          maxLength={2}
          value={hours}
          onChange={handleHoursChange}
          onBlur={handleHoursBlur}
          onFocus={handleFocus}
          onKeyDown={(e) => handleKeyDown(e, 'hours')}
          className="w-6 bg-transparent text-center outline-none"
          aria-label={props['aria-label'] ? `${props['aria-label']} Stunden` : 'Stunden'}
          disabled={props.disabled}
        />
        <span className="text-muted-foreground">:</span>
        <input
          type="text"
          inputMode="numeric"
          maxLength={2}
          value={minutes}
          onChange={handleMinutesChange}
          onBlur={handleMinutesBlur}
          onFocus={handleFocus}
          onKeyDown={(e) => handleKeyDown(e, 'minutes')}
          className="w-6 bg-transparent text-center outline-none"
          aria-label={props['aria-label'] ? `${props['aria-label']} Minuten` : 'Minuten'}
          disabled={props.disabled}
        />
      </div>
    )
  }
)
TimeInput.displayName = 'TimeInput'

export { TimeInput }
