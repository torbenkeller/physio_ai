import { describe, it, expect, vi } from 'vitest'
import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { PatientenSuche, NEW_PATIENT_ID } from './PatientenSuche'
import type { PatientDto } from '../types/patient.types'

const createPatient = (overrides: Partial<PatientDto> = {}): PatientDto => ({
  id: '1',
  titel: null,
  vorname: 'Max',
  nachname: 'Müller',
  strasse: null,
  hausnummer: null,
  plz: null,
  stadt: null,
  telMobil: null,
  telFestnetz: null,
  email: null,
  geburtstag: '1990-05-01',
  behandlungenProRezept: null,
  ...overrides,
})

const mockPatienten: PatientDto[] = [
  createPatient({ id: '1', vorname: 'Max', nachname: 'Müller', geburtstag: '1990-05-01' }),
  createPatient({ id: '2', vorname: 'Anna', nachname: 'Schmidt', geburtstag: '1985-12-15' }),
  createPatient({ id: '3', vorname: 'Peter', nachname: 'Weber', geburtstag: null }),
]

describe('PatientenSuche', () => {
  it('zeigt "Patient suchen..." wenn kein Patient ausgewählt ist', () => {
    render(
      <PatientenSuche
        patienten={mockPatienten}
        selectedPatientId=""
        onPatientChange={() => {}}
      />,
    )

    expect(screen.getByRole('combobox')).toHaveTextContent('Patient suchen...')
  })

  it('zeigt "+ Neuer Patient" wenn NEW_PATIENT_ID ausgewählt ist', () => {
    render(
      <PatientenSuche
        patienten={mockPatienten}
        selectedPatientId={NEW_PATIENT_ID}
        onPatientChange={() => {}}
      />,
    )

    expect(screen.getByRole('combobox')).toHaveTextContent('+ Neuer Patient')
  })

  it('zeigt ausgewählten Patienten-Namen an', () => {
    render(
      <PatientenSuche
        patienten={mockPatienten}
        selectedPatientId="2"
        onPatientChange={() => {}}
      />,
    )

    expect(screen.getByRole('combobox')).toHaveTextContent('Anna Schmidt')
  })

  it('öffnet Dropdown bei Klick', async () => {
    const user = userEvent.setup()

    render(
      <PatientenSuche
        patienten={mockPatienten}
        selectedPatientId=""
        onPatientChange={() => {}}
      />,
    )

    await user.click(screen.getByRole('combobox'))

    expect(screen.getByPlaceholderText('Name oder Geburtsdatum suchen...')).toBeInTheDocument()
  })

  it('zeigt alle Patienten im Dropdown', async () => {
    const user = userEvent.setup()

    render(
      <PatientenSuche
        patienten={mockPatienten}
        selectedPatientId=""
        onPatientChange={() => {}}
      />,
    )

    await user.click(screen.getByRole('combobox'))

    expect(screen.getByText('Max Müller')).toBeInTheDocument()
    expect(screen.getByText('Anna Schmidt')).toBeInTheDocument()
    expect(screen.getByText('Peter Weber')).toBeInTheDocument()
  })

  it('zeigt Geburtsdatum bei Patienten an', async () => {
    const user = userEvent.setup()

    render(
      <PatientenSuche
        patienten={mockPatienten}
        selectedPatientId=""
        onPatientChange={() => {}}
      />,
    )

    await user.click(screen.getByRole('combobox'))

    expect(screen.getByText('01.05.1990')).toBeInTheDocument()
    expect(screen.getByText('15.12.1985')).toBeInTheDocument()
  })

  it('ruft onPatientChange bei Auswahl auf', async () => {
    const user = userEvent.setup()
    const onPatientChange = vi.fn()

    render(
      <PatientenSuche
        patienten={mockPatienten}
        selectedPatientId=""
        onPatientChange={onPatientChange}
      />,
    )

    await user.click(screen.getByRole('combobox'))
    await user.click(screen.getByText('Anna Schmidt'))

    expect(onPatientChange).toHaveBeenCalledWith('2')
  })

  it('filtert Patienten bei Suche', async () => {
    const user = userEvent.setup()

    render(
      <PatientenSuche
        patienten={mockPatienten}
        selectedPatientId=""
        onPatientChange={() => {}}
      />,
    )

    await user.click(screen.getByRole('combobox'))
    await user.type(screen.getByPlaceholderText('Name oder Geburtsdatum suchen...'), 'Anna')

    expect(screen.getByText('Anna Schmidt')).toBeInTheDocument()
    expect(screen.queryByText('Max Müller')).not.toBeInTheDocument()
    expect(screen.queryByText('Peter Weber')).not.toBeInTheDocument()
  })

  it('zeigt "Neuer Patient" Option wenn showNewPatientOption=true', async () => {
    const user = userEvent.setup()

    render(
      <PatientenSuche
        patienten={mockPatienten}
        selectedPatientId=""
        onPatientChange={() => {}}
        showNewPatientOption={true}
      />,
    )

    await user.click(screen.getByRole('combobox'))

    expect(screen.getByText('+ Neuer Patient')).toBeInTheDocument()
  })

  it('versteckt "Neuer Patient" Option wenn showNewPatientOption=false', async () => {
    const user = userEvent.setup()

    render(
      <PatientenSuche
        patienten={mockPatienten}
        selectedPatientId=""
        onPatientChange={() => {}}
        showNewPatientOption={false}
      />,
    )

    await user.click(screen.getByRole('combobox'))

    expect(screen.queryByText('+ Neuer Patient')).not.toBeInTheDocument()
  })

  it('ist deaktiviert wenn disabled=true', () => {
    render(
      <PatientenSuche
        patienten={mockPatienten}
        selectedPatientId=""
        onPatientChange={() => {}}
        disabled={true}
      />,
    )

    expect(screen.getByRole('combobox')).toBeDisabled()
  })

  it('funktioniert mit leerer Patientenliste', async () => {
    const user = userEvent.setup()

    render(
      <PatientenSuche
        patienten={[]}
        selectedPatientId=""
        onPatientChange={() => {}}
      />,
    )

    await user.click(screen.getByRole('combobox'))

    expect(screen.getByText('Patienten')).toBeInTheDocument()
  })

  it('funktioniert mit undefined Patientenliste', async () => {
    const user = userEvent.setup()

    render(
      <PatientenSuche
        patienten={undefined}
        selectedPatientId=""
        onPatientChange={() => {}}
      />,
    )

    await user.click(screen.getByRole('combobox'))

    expect(screen.getByPlaceholderText('Name oder Geburtsdatum suchen...')).toBeInTheDocument()
  })
})
