import { test, expect } from '@playwright/test'

test.describe('DateInput Komponente', () => {
  test.beforeEach(async ({ page }) => {
    // Navigiere zum Kalender und aktiviere Planungsmodus
    await page.goto('/kalender')
    await page.waitForLoadState('networkidle')
    await expect(page.getByRole('heading', { name: 'Kalender' })).toBeVisible()

    // Klick in Kalender um Planungsmodus zu aktivieren
    const kalenderSpalte = page.locator('[class*="border-l cursor-pointer"]').first()
    await kalenderSpalte.click({ position: { x: 50, y: 400 } })

    // Sidebar erscheint
    await expect(page.getByRole('heading', { name: 'Termine planen' })).toBeVisible()

    // 1 Termin generieren um DateInput in der Liste zu haben
    const anzahlInput = page.getByRole('spinbutton').nth(1)
    await anzahlInput.fill('1')
    await page.getByRole('button', { name: /\d+ Termine generieren/ }).click()
    await expect(page.getByText('Termine (1)')).toBeVisible()
  })

  test('zeigt Datum im deutschen Format dd.MM.yyyy', async ({ page }) => {
    // DateInput in der Termine-Liste finden (über Placeholder)
    const dateInput = page.getByPlaceholder('TT.MM.JJJJ').first()

    // Prüfe Format: dd.MM.yyyy (z.B. "15.12.2025")
    const dateValue = await dateInput.inputValue()
    expect(dateValue).toMatch(/^\d{2}\.\d{2}\.\d{4}$/)
  })

  test('Datum kann direkt eingetippt werden', async ({ page }) => {
    const dateInput = page.getByPlaceholder('TT.MM.JJJJ').first()

    // Datum löschen und neues eingeben
    await dateInput.fill('25.12.2025')

    // Wert prüfen
    await expect(dateInput).toHaveValue('25.12.2025')
  })

  test('Klick auf Kalender-Icon öffnet Popover', async ({ page }) => {
    // Kalender-Icon-Button finden
    const calendarButton = page.getByRole('button', { name: 'Kalender öffnen' }).first()
    await calendarButton.click()

    // Kalender-Popover sollte erscheinen
    const calendarPopover = page.locator('[data-slot="calendar"]')
    await expect(calendarPopover).toBeVisible()
  })

  test('Kalender hat Monat/Jahr-Dropdown-Navigation', async ({ page }) => {
    // Kalender öffnen
    const calendarButton = page.getByRole('button', { name: 'Kalender öffnen' }).first()
    await calendarButton.click()

    // Warte auf Kalender
    const calendarPopover = page.locator('[data-slot="calendar"]')
    await expect(calendarPopover).toBeVisible()

    // Dropdown-Selects für Monat und Jahr sollten sichtbar sein
    const monthDropdown = page.getByRole('combobox', { name: 'Choose the Month' })
    const yearDropdown = page.getByRole('combobox', { name: 'Choose the Year' })
    await expect(monthDropdown).toBeVisible()
    await expect(yearDropdown).toBeVisible()
  })

  test('Datum auswählen aktualisiert Input und schließt Popover', async ({ page }) => {
    const dateInput = page.getByPlaceholder('TT.MM.JJJJ').first()

    // Kalender öffnen
    const calendarButton = page.getByRole('button', { name: 'Kalender öffnen' }).first()
    await calendarButton.click()

    // Warte auf Kalender
    const calendarPopover = page.locator('[data-slot="calendar"]')
    await expect(calendarPopover).toBeVisible()

    // Einen beliebigen Tag im Kalender-Grid auswählen
    // Klicke via JavaScript, da avoidCollisions={false} das Popover außerhalb des Viewports platzieren kann
    const dayButton = page.getByRole('gridcell', { name: /10\./ }).getByRole('button')
    await dayButton.evaluate((el) => (el as HTMLButtonElement).click())

    // Popover sollte geschlossen sein
    await expect(calendarPopover).not.toBeVisible()

    // Datum sollte ein gültiges Datum im deutschen Format sein
    const newDate = await dateInput.inputValue()
    expect(newDate).toMatch(/^\d{2}\.\d{2}\.\d{4}$/)
  })

  test('ArrowDown öffnet Kalender', async ({ page }) => {
    const dateInput = page.getByPlaceholder('TT.MM.JJJJ').first()

    // Fokussiere Input und drücke ArrowDown
    await dateInput.focus()
    await page.keyboard.press('ArrowDown')

    // Kalender-Popover sollte erscheinen
    const calendarPopover = page.locator('[data-slot="calendar"]')
    await expect(calendarPopover).toBeVisible()
  })

  test('Ungültiges Datum wird beim Blur korrigiert', async ({ page }) => {
    const dateInput = page.getByPlaceholder('TT.MM.JJJJ').first()

    // Ursprüngliches Datum merken
    const originalDate = await dateInput.inputValue()

    // Ungültiges Datum eingeben
    await dateInput.fill('invalid')

    // Fokus verlieren (blur) - klicke woanders
    await page.getByRole('heading', { name: 'Termine planen' }).click()

    // Datum sollte auf vorherigen gültigen Wert zurückgesetzt sein
    const currentValue = await dateInput.inputValue()
    expect(currentValue).toBe(originalDate)
  })

  test('Monat kann über Dropdown gewechselt werden', async ({ page }) => {
    // Kalender öffnen
    const calendarButton = page.getByRole('button', { name: 'Kalender öffnen' }).first()
    await calendarButton.click()

    // Warte auf Kalender
    const calendarPopover = page.locator('[data-slot="calendar"]')
    await expect(calendarPopover).toBeVisible()

    // Monats-Dropdown finden und Januar auswählen
    const monthDropdown = page.getByRole('combobox', { name: 'Choose the Month' })
    await monthDropdown.selectOption({ label: 'Jan' })

    // Status sollte Januar zeigen
    await expect(page.getByRole('status')).toContainText('Januar')
  })

  test('Jahr kann über Dropdown gewechselt werden', async ({ page }) => {
    // Kalender öffnen
    const calendarButton = page.getByRole('button', { name: 'Kalender öffnen' }).first()
    await calendarButton.click()

    // Warte auf Kalender
    const calendarPopover = page.locator('[data-slot="calendar"]')
    await expect(calendarPopover).toBeVisible()

    // Jahr-Dropdown finden und 2024 auswählen
    const yearDropdown = page.getByRole('combobox', { name: 'Choose the Year' })
    await yearDropdown.selectOption({ label: '2024' })

    // Status sollte 2024 zeigen
    await expect(page.getByRole('status')).toContainText('2024')
  })
})
