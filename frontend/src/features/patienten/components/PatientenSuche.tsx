import { useState, useMemo } from 'react'
import { Check, ChevronsUpDown, UserPlus } from 'lucide-react'
import { cn } from '@/shared/utils'
import { Button } from '@/shared/components/ui/button'
import {
  Command,
  CommandEmpty,
  CommandGroup,
  CommandInput,
  CommandItem,
  CommandList,
  CommandSeparator,
} from '@/shared/components/ui/command'
import { Popover, PopoverContent, PopoverTrigger } from '@/shared/components/ui/popover'
import type { PatientDto } from '../types/patient.types'
import {
  searchPatienten,
  formatPatientForDisplay,
  formatGeburtstag,
} from '../utils/patientenSearch'

export const NEW_PATIENT_ID = '__new__'

interface PatientenSucheProps {
  patienten: PatientDto[] | undefined
  selectedPatientId: string
  onPatientChange: (patientId: string) => void
  showNewPatientOption?: boolean
  disabled?: boolean
}

export const PatientenSuche = ({
  patienten,
  selectedPatientId,
  onPatientChange,
  showNewPatientOption = true,
  disabled = false,
}: PatientenSucheProps) => {
  const [open, setOpen] = useState(false)
  const [searchQuery, setSearchQuery] = useState('')

  const filteredPatienten = useMemo(() => {
    if (!patienten) return []
    return searchPatienten(patienten, searchQuery)
  }, [patienten, searchQuery])

  const selectedPatient = patienten?.find((p) => p.id === selectedPatientId)

  const displayValue = useMemo(() => {
    if (selectedPatientId === NEW_PATIENT_ID) {
      return '+ Neuer Patient'
    }
    if (selectedPatient) {
      return formatPatientForDisplay(selectedPatient)
    }
    return 'Patient suchen...'
  }, [selectedPatientId, selectedPatient])

  const handleSelect = (patientId: string) => {
    onPatientChange(patientId)
    setOpen(false)
    setSearchQuery('')
  }

  return (
    <Popover open={open} onOpenChange={setOpen}>
      <PopoverTrigger asChild>
        <Button
          variant="outline"
          role="combobox"
          aria-expanded={open}
          className="w-full justify-between"
          disabled={disabled}
        >
          <span className="truncate">{displayValue}</span>
          <ChevronsUpDown className="ml-2 h-4 w-4 shrink-0 opacity-50" />
        </Button>
      </PopoverTrigger>
      <PopoverContent className="!w-[--radix-popover-trigger-width] p-0" align="start">
        <Command shouldFilter={false}>
          <CommandInput
            placeholder="Name oder Geburtsdatum suchen..."
            value={searchQuery}
            onValueChange={setSearchQuery}
          />
          <CommandList>
            <CommandEmpty>Kein Patient gefunden</CommandEmpty>

            {showNewPatientOption && (
              <>
                <CommandGroup>
                  <CommandItem value={NEW_PATIENT_ID} onSelect={() => handleSelect(NEW_PATIENT_ID)}>
                    <UserPlus className="mr-2 h-4 w-4" />
                    <span className="font-medium">+ Neuer Patient</span>
                    <Check
                      className={cn(
                        'ml-auto h-4 w-4',
                        selectedPatientId === NEW_PATIENT_ID ? 'opacity-100' : 'opacity-0',
                      )}
                    />
                  </CommandItem>
                </CommandGroup>
                <CommandSeparator />
              </>
            )}

            <CommandGroup heading="Patienten">
              {filteredPatienten.map((patient) => (
                <CommandItem
                  key={patient.id}
                  value={patient.id}
                  onSelect={() => handleSelect(patient.id)}
                >
                  <div className="flex flex-col">
                    <span>
                      {patient.vorname} {patient.nachname}
                    </span>
                    {patient.geburtstag && (
                      <span className="text-xs text-muted-foreground">
                        {formatGeburtstag(patient.geburtstag)}
                      </span>
                    )}
                  </div>
                  <Check
                    className={cn(
                      'ml-auto h-4 w-4',
                      selectedPatientId === patient.id ? 'opacity-100' : 'opacity-0',
                    )}
                  />
                </CommandItem>
              ))}
            </CommandGroup>
          </CommandList>
        </Command>
      </PopoverContent>
    </Popover>
  )
}
