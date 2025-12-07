import { test, expect } from '@playwright/test'

test.describe('Kalender Einstellungen', () => {
  test.beforeEach(async ({ page }) => {
    // localStorage zurücksetzen für konsistente Tests
    await page.goto('/kalender')
    await page.evaluate(() => localStorage.removeItem('kalender-settings'))
    await page.reload()
    await page.waitForLoadState('networkidle')
  })

  test('Settings-Button ist in der Navigationsleiste sichtbar', async ({ page }) => {
    await expect(page.getByRole('heading', { name: 'Kalender' })).toBeVisible()

    const settingsButton = page.getByRole('button', { name: 'Kalender-Einstellungen' })
    await expect(settingsButton).toBeVisible()
  })

  test('Settings-Dialog öffnet sich bei Klick', async ({ page }) => {
    await expect(page.getByRole('heading', { name: 'Kalender' })).toBeVisible()

    await page.getByRole('button', { name: 'Kalender-Einstellungen' }).click()

    await expect(page.getByRole('dialog')).toBeVisible()
    await expect(
      page.getByRole('heading', { name: 'Kalender-Einstellungen' })
    ).toBeVisible()
    await expect(page.getByText('Wochenende anzeigen')).toBeVisible()
  })

  test('Wochenende-Switch ist standardmäßig deaktiviert', async ({ page }) => {
    await expect(page.getByRole('heading', { name: 'Kalender' })).toBeVisible()

    await page.getByRole('button', { name: 'Kalender-Einstellungen' }).click()

    const switchElement = page.getByRole('switch', { name: 'Wochenende anzeigen' })
    await expect(switchElement).toBeVisible()
    await expect(switchElement).not.toBeChecked()
  })

  test('Kalender zeigt standardmäßig 5 Tage (Mo-Fr)', async ({ page }) => {
    await expect(page.getByRole('heading', { name: 'Kalender' })).toBeVisible()

    // Samstag/Sonntag sollten nicht in den Spalten-Headers sichtbar sein
    await expect(page.getByText('Sa.').first()).not.toBeVisible()
    await expect(page.getByText('So.').first()).not.toBeVisible()
  })

  test('Aktivierung zeigt Samstag und Sonntag an', async ({ page }) => {
    await expect(page.getByRole('heading', { name: 'Kalender' })).toBeVisible()

    // Settings öffnen und Wochenende aktivieren
    await page.getByRole('button', { name: 'Kalender-Einstellungen' }).click()
    await page.getByRole('switch', { name: 'Wochenende anzeigen' }).click()

    // Dialog schließen (Click außerhalb oder Escape)
    await page.keyboard.press('Escape')

    // Samstag und Sonntag sollten jetzt sichtbar sein (Datum 6 und 7)
    await expect(page.getByText('6', { exact: true }).first()).toBeVisible()
    await expect(page.getByText('7', { exact: true }).first()).toBeVisible()
  })

  test('Einstellung wird nach Seiten-Reload gespeichert', async ({ page }) => {
    await expect(page.getByRole('heading', { name: 'Kalender' })).toBeVisible()

    // Wochenende aktivieren
    await page.getByRole('button', { name: 'Kalender-Einstellungen' }).click()
    await page.getByRole('switch', { name: 'Wochenende anzeigen' }).click()
    await page.keyboard.press('Escape')

    // Verifizieren dass Sa/So sichtbar sind (prüfen über Datum)
    await expect(page.getByText('6', { exact: true }).first()).toBeVisible()

    // Seite neu laden
    await page.reload()
    await page.waitForLoadState('networkidle')

    // Sa/So sollten immer noch sichtbar sein (Datum 6 und 7)
    await expect(page.getByText('6', { exact: true }).first()).toBeVisible()
    await expect(page.getByText('7', { exact: true }).first()).toBeVisible()

    // Switch sollte aktiviert sein
    await page.getByRole('button', { name: 'Kalender-Einstellungen' }).click()
    const switchElement = page.getByRole('switch', { name: 'Wochenende anzeigen' })
    await expect(switchElement).toBeChecked()
  })

  test('Wochenbereich zeigt Kalenderwoche und Monat an', async ({ page }) => {
    await expect(page.getByRole('heading', { name: 'Kalender' })).toBeVisible()

    // Wochenbereich-Text Element finden und Format prüfen (KW X · Monat Jahr)
    const weekRangeElement = page.locator('.min-w-\\[200px\\].text-center')
    const rangeText = await weekRangeElement.textContent()

    // Format sollte "KW X · Monat Jahr" sein
    expect(rangeText).toMatch(/KW \d+ · \w+ \d{4}/)
  })
})

test.describe('Kalender Einstellungen - PlanungsSidebar Integration', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/kalender')
    await page.evaluate(() => localStorage.removeItem('kalender-settings'))
    await page.reload()
    await page.waitForLoadState('networkidle')
  })

  test('PlanungsSidebar zeigt nur Mo-Fr wenn Wochenende deaktiviert', async ({ page }) => {
    await expect(page.getByRole('heading', { name: 'Kalender' })).toBeVisible()

    // Planungsmodus aktivieren durch Klick in Kalender
    const kalenderSpalte = page.locator('[class*="border-l"][class*="cursor-pointer"]').first()
    await kalenderSpalte.click({ position: { x: 50, y: 400 } })

    // Sidebar erscheint
    await expect(page.getByRole('heading', { name: 'Termine planen' })).toBeVisible()

    // Serie erstellen Sektion öffnen
    await page.getByText('Serie erstellen').click()

    // Sa und So sollten nicht als Wochentag-Buttons vorhanden sein
    await expect(page.getByRole('button', { name: 'Sa', exact: true })).not.toBeVisible()
    await expect(page.getByRole('button', { name: 'So', exact: true })).not.toBeVisible()
  })

  test('PlanungsSidebar zeigt Sa/So wenn Wochenende aktiviert', async ({ page }) => {
    await expect(page.getByRole('heading', { name: 'Kalender' })).toBeVisible()

    // Wochenende aktivieren
    await page.getByRole('button', { name: 'Kalender-Einstellungen' }).click()
    await page.getByRole('switch', { name: 'Wochenende anzeigen' }).click()
    await page.keyboard.press('Escape')

    // Planungsmodus aktivieren
    const kalenderSpalte = page.locator('[class*="border-l"][class*="cursor-pointer"]').first()
    await kalenderSpalte.click({ position: { x: 50, y: 400 } })

    // Sidebar erscheint
    await expect(page.getByRole('heading', { name: 'Termine planen' })).toBeVisible()

    // Serie erstellen Sektion öffnen
    await page.getByText('Serie erstellen').click()

    // Sa und So sollten jetzt als Wochentag-Buttons vorhanden sein
    await expect(page.getByRole('button', { name: 'Sa', exact: true })).toBeVisible()
    await expect(page.getByRole('button', { name: 'So', exact: true })).toBeVisible()
  })
})
