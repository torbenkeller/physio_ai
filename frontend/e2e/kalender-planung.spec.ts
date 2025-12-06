import { test, expect } from '@playwright/test'

test.describe('Kalender Planungsmodus', () => {
  test.beforeEach(async ({ page }) => {
    // Navigiere zum Kalender
    await page.goto('/kalender')
    await page.waitForLoadState('networkidle')
  })

  test('Klick in Kalender öffnet Planungs-Sidebar', async ({ page }) => {
    // Warte bis Kalender geladen ist
    await expect(page.getByRole('heading', { name: 'Kalender' })).toBeVisible()

    // Finde eine Kalender-Spalte und klicke hinein
    const kalenderSpalte = page.locator('[class*="border-l cursor-pointer"]').first()
    await kalenderSpalte.click({ position: { x: 50, y: 300 } })

    // Planungs-Sidebar sollte erscheinen
    await expect(page.getByRole('heading', { name: 'Termine planen' })).toBeVisible()
    await expect(page.getByText('Patient', { exact: true })).toBeVisible()
    await expect(page.getByText('Serie erstellen')).toBeVisible()
  })

  test('Serie generieren zeigt Termine im Kalender', async ({ page }) => {
    // Kalender laden
    await expect(page.getByRole('heading', { name: 'Kalender' })).toBeVisible()

    // Klick in Kalender um Planungsmodus zu aktivieren
    const kalenderSpalte = page.locator('[class*="border-l cursor-pointer"]').first()
    await kalenderSpalte.click({ position: { x: 50, y: 400 } }) // ca. 10 Uhr

    // Sidebar erscheint
    await expect(page.getByRole('heading', { name: 'Termine planen' })).toBeVisible()

    // Warte bis Serie erstellen Sektion sichtbar ist
    await expect(page.getByText('Serie erstellen')).toBeVisible()

    // Anzahl auf 3 setzen für schnelleren Test
    const anzahlInput = page.getByRole('spinbutton').nth(1)
    await anzahlInput.fill('3')

    // Serie generieren
    await page.getByRole('button', { name: /\d+ Termine generieren/ }).click()

    // Prüfe ob Termine in der Liste erscheinen
    await expect(page.getByText('Termine (3)')).toBeVisible()

    // Prüfe ob Termine im Kalender sichtbar sind (gestrichelte grüne Boxen)
    const geplanteTermine = page.locator('[class*="border-dashed"][class*="bg-emerald"]')
    await expect(geplanteTermine.first()).toBeVisible()
  })

  test('Abbrechen schließt Planungsmodus', async ({ page }) => {
    // Kalender laden und Planungsmodus aktivieren
    await expect(page.getByRole('heading', { name: 'Kalender' })).toBeVisible()

    const kalenderSpalte = page.locator('[class*="border-l cursor-pointer"]').first()
    await kalenderSpalte.click({ position: { x: 50, y: 300 } })

    // Sidebar erscheint
    await expect(page.getByRole('heading', { name: 'Termine planen' })).toBeVisible()

    // Abbrechen klicken
    await page.getByRole('button', { name: 'Abbrechen' }).click()

    // Sidebar sollte verschwinden (mit Animation, längerer Timeout)
    await expect(page.getByRole('heading', { name: 'Termine planen' })).not.toBeVisible({ timeout: 10000 })
  })

  test('Wochen-Navigation funktioniert im Planungsmodus', async ({ page }) => {
    // Kalender laden
    await expect(page.getByRole('heading', { name: 'Kalender' })).toBeVisible()

    // Aktiviere Planungsmodus
    const kalenderSpalte = page.locator('[class*="border-l cursor-pointer"]').first()
    await kalenderSpalte.click({ position: { x: 50, y: 300 } })

    // Sidebar erscheint
    await expect(page.getByRole('heading', { name: 'Termine planen' })).toBeVisible()

    // Aktuelle Woche merken (Wochenanzeige ist nach "Heute" Button)
    const wochenAnzeige = page.getByRole('button', { name: 'Heute' }).locator('..').locator('~ *').first()
    const initialWeek = await wochenAnzeige.textContent()

    // Zur nächsten Woche navigieren (Button nach der Wochenanzeige)
    const navButtons = page.locator('[class*="gap-2"] > button')
    await navButtons.nth(2).click() // Der dritte Button (nach Heute und vor der Wochenanzeige)

    // Kurz warten
    await page.waitForTimeout(200)

    // Woche sollte sich geändert haben
    const newWeek = await wochenAnzeige.textContent()
    expect(newWeek).not.toBe(initialWeek)

    // Sidebar sollte noch offen sein
    await expect(page.getByRole('heading', { name: 'Termine planen' })).toBeVisible()
  })

  test('Termin-Auswahl in Liste funktioniert', async ({ page }) => {
    // Kalender laden und Termine generieren
    await expect(page.getByRole('heading', { name: 'Kalender' })).toBeVisible()

    const kalenderSpalte = page.locator('[class*="border-l cursor-pointer"]').first()
    await kalenderSpalte.click({ position: { x: 50, y: 400 } })

    await expect(page.getByRole('heading', { name: 'Termine planen' })).toBeVisible()

    // 2 Termine generieren
    const anzahlInput = page.getByRole('spinbutton').nth(1)
    await anzahlInput.fill('2')
    await page.getByRole('button', { name: /\d+ Termine generieren/ }).click()

    // Prüfe ob Termine in der Liste erscheinen
    await expect(page.getByText('Termine (2)')).toBeVisible()

    // Klicke auf zweiten Termin in der Liste
    const terminItems = page.locator('[class*="rounded-md border cursor-pointer"]')
    await terminItems.nth(1).click()

    // Der ausgewählte Termin sollte hervorgehoben sein
    await expect(terminItems.nth(1)).toHaveClass(/border-primary/)
  })

  test('Alle löschen entfernt alle Termine', async ({ page }) => {
    // Kalender laden und Termine generieren
    await expect(page.getByRole('heading', { name: 'Kalender' })).toBeVisible()

    const kalenderSpalte = page.locator('[class*="border-l cursor-pointer"]').first()
    await kalenderSpalte.click({ position: { x: 50, y: 400 } })

    await expect(page.getByRole('heading', { name: 'Termine planen' })).toBeVisible()

    // 3 Termine generieren
    const anzahlInput = page.getByRole('spinbutton').nth(1)
    await anzahlInput.fill('3')
    await page.getByRole('button', { name: /\d+ Termine generieren/ }).click()

    await expect(page.getByText('Termine (3)')).toBeVisible()

    // Serie löschen (Button-Name hat sich geändert)
    await page.getByRole('button', { name: 'Serie löschen' }).click()

    // Nur noch 1 Termin (der erste bleibt)
    await expect(page.getByText('Termine (1)')).toBeVisible()
  })

  test('Einzelnen Termin löschen funktioniert', async ({ page }) => {
    // Kalender laden und Termine generieren
    await expect(page.getByRole('heading', { name: 'Kalender' })).toBeVisible()

    const kalenderSpalte = page.locator('[class*="border-l cursor-pointer"]').first()
    await kalenderSpalte.click({ position: { x: 50, y: 400 } })

    await expect(page.getByRole('heading', { name: 'Termine planen' })).toBeVisible()

    // 3 Termine generieren
    const anzahlInput = page.getByRole('spinbutton').nth(1)
    await anzahlInput.fill('3')
    await page.getByRole('button', { name: /\d+ Termine generieren/ }).click()

    await expect(page.getByText('Termine (3)')).toBeVisible()

    // X-Button beim zweiten Termin klicken (erster hat keinen X-Button)
    const terminItems = page.locator('[class*="rounded-md border cursor-pointer"]')
    const secondTermin = terminItems.nth(1)
    const deleteButton = secondTermin.locator('button')
    await deleteButton.click()

    // Nur noch 2 Termine
    await expect(page.getByText('Termine (2)')).toBeVisible()
  })

  test('Zeit-Eingaben in Termin-Liste funktionieren', async ({ page }) => {
    // Kalender laden und Termine generieren
    await expect(page.getByRole('heading', { name: 'Kalender' })).toBeVisible()

    const kalenderSpalte = page.locator('[class*="border-l cursor-pointer"]').first()
    await kalenderSpalte.click({ position: { x: 50, y: 400 } })

    await expect(page.getByRole('heading', { name: 'Termine planen' })).toBeVisible()

    // 1 Termin generieren
    const anzahlInput = page.getByRole('spinbutton').nth(1)
    await anzahlInput.fill('1')
    await page.getByRole('button', { name: /\d+ Termine generieren/ }).click()

    // Zeit-Input für Startzeit finden (24h TimeInput hat separate Stunden/Minuten Felder)
    const terminItem = page.locator('[class*="rounded-md border cursor-pointer"]').first()
    const stundenInput = terminItem.getByRole('textbox', { name: 'Stunden' }).first()
    const minutenInput = terminItem.getByRole('textbox', { name: 'Minuten' }).first()

    // Stunden auf 14 setzen
    await stundenInput.fill('14')
    await minutenInput.fill('30')

    // Zeit sollte sich aktualisiert haben
    await expect(stundenInput).toHaveValue('14')
    await expect(minutenInput).toHaveValue('30')
  })

  test('Heute-Button navigiert zur aktuellen Woche', async ({ page }) => {
    // Kalender laden
    await expect(page.getByRole('heading', { name: 'Kalender' })).toBeVisible()

    // Zur nächsten Woche navigieren (Button nach der Wochenanzeige)
    const navButtons = page.locator('[class*="gap-2"] > button')
    await navButtons.nth(2).click() // ChevronRight
    await page.waitForTimeout(100)
    await navButtons.nth(2).click() // Nochmal

    // Heute-Button klicken
    await page.getByRole('button', { name: 'Heute' }).click()

    // Der aktuelle Tag sollte hervorgehoben sein
    const todayColumn = page.locator('[class*="bg-primary/5"]')
    await expect(todayColumn).toBeVisible()
  })
})

test.describe('Individuelle Startzeiten pro Wochentag', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/kalender')
    await page.waitForLoadState('networkidle')
  })

  test('Zeit-Input erscheint bei Wochentag-Auswahl', async ({ page }) => {
    // Kalender laden
    await expect(page.getByRole('heading', { name: 'Kalender' })).toBeVisible()

    // Klick in Kalender um Planungsmodus zu aktivieren
    const kalenderSpalte = page.locator('[class*="border-l cursor-pointer"]').first()
    await kalenderSpalte.click({ position: { x: 50, y: 400 } })

    // Sidebar erscheint
    await expect(page.getByRole('heading', { name: 'Termine planen' })).toBeVisible()

    // Wochentag-Buttons finden (im Bereich "An diesen Tagen")
    const miButton = page.locator('button').filter({ hasText: /^Mi$/ })

    // Mittwoch auswählen (zusätzlich zum automatisch ausgewählten Tag)
    await miButton.click()

    // Zeit-Input für Mittwoch sollte erscheinen (24h TimeInput)
    const miTimeInput = page.getByRole('textbox', { name: /Startzeit für Mittwoch Stunden/i })
    await expect(miTimeInput).toBeVisible()
  })

  test('Individuelle Zeit pro Tag kann gesetzt werden', async ({ page }) => {
    await expect(page.getByRole('heading', { name: 'Kalender' })).toBeVisible()

    const kalenderSpalte = page.locator('[class*="border-l cursor-pointer"]').first()
    await kalenderSpalte.click({ position: { x: 50, y: 400 } })

    await expect(page.getByRole('heading', { name: 'Termine planen' })).toBeVisible()

    // Zusätzlichen Tag auswählen
    const doButton = page.locator('button').filter({ hasText: /^Do$/ })
    await doButton.click()

    // Zeit für Donnerstag ändern (24h TimeInput hat separate Stunden/Minuten Felder)
    const doStundenInput = page.getByRole('textbox', { name: /Startzeit für Donnerstag Stunden/i })
    const doMinutenInput = page.getByRole('textbox', { name: /Startzeit für Donnerstag Minuten/i })
    await doStundenInput.fill('14')
    await doMinutenInput.fill('00')

    // Wert prüfen
    await expect(doStundenInput).toHaveValue('14')
    await expect(doMinutenInput).toHaveValue('00')
  })

  test('Generierte Serie hat unterschiedliche Zeiten pro Wochentag', async ({ page }) => {
    await expect(page.getByRole('heading', { name: 'Kalender' })).toBeVisible()

    // Klick in Montag-Spalte (erste Spalte) bei ca. 09:00 Uhr
    const kalenderSpalte = page.locator('[class*="border-l cursor-pointer"]').first()
    await kalenderSpalte.click({ position: { x: 50, y: 540 } })

    await expect(page.getByRole('heading', { name: 'Termine planen' })).toBeVisible()

    // Warte bis "An diesen Tagen" sichtbar ist
    await expect(page.getByText('An diesen Tagen')).toBeVisible()

    // Mittwoch auswählen (zusätzlich zu Montag)
    await page.getByRole('button', { name: 'Mi', exact: true }).click()

    // Warte auf Zeit-Input für Mittwoch (24h TimeInput)
    const miStundenInput = page.getByRole('textbox', { name: /Startzeit für Mittwoch Stunden/i })
    await expect(miStundenInput).toBeVisible()

    // Unterschiedliche Zeit für Mittwoch setzen
    await miStundenInput.fill('15')
    await page.getByRole('textbox', { name: /Startzeit für Mittwoch Minuten/i }).fill('00')

    // 4 Termine generieren (2x Mo, 2x Mi)
    const anzahlInput = page.getByRole('spinbutton').nth(1)
    await anzahlInput.fill('4')
    await page.getByRole('button', { name: /\d+ Termine generieren/ }).click()

    // Prüfen ob Termine erstellt wurden
    await expect(page.getByText('Termine (4)')).toBeVisible()

    // Prüfe ob verschiedene Zeiten in der Liste erscheinen (24h TimeInput)
    const stundenInputsInList = page.locator('[class*="rounded-md border cursor-pointer"]').getByRole('textbox', { name: 'Stunden' })
    const hours = await stundenInputsInList.evaluateAll((inputs) =>
      (inputs as HTMLInputElement[]).map((i) => i.value)
    )
    // Mittwoch hat 15:00
    expect(hours).toContain('15')
  })

  test('Default-Zeit wird vom ersten Slot übernommen', async ({ page }) => {
    await expect(page.getByRole('heading', { name: 'Kalender' })).toBeVisible()

    // Klick in Montag-Spalte
    const kalenderSpalte = page.locator('[class*="border-l cursor-pointer"]').first()
    await kalenderSpalte.click({ position: { x: 50, y: 400 } })

    // Warte auf Sidebar
    await expect(page.getByRole('heading', { name: 'Termine planen' })).toBeVisible()

    // Hole die Startzeit des ersten Slots (Montag) - 24h TimeInput
    const moStundenInput = page.getByRole('textbox', { name: /Startzeit für Montag Stunden/i })
    const moMinutenInput = page.getByRole('textbox', { name: /Startzeit für Montag Minuten/i })
    await expect(moStundenInput).toBeVisible()
    const moStunden = await moStundenInput.inputValue()
    const moMinuten = await moMinutenInput.inputValue()

    // Mittwoch auswählen (zusätzlich zu Montag)
    await page.getByRole('button', { name: 'Mi', exact: true }).click()

    // Zeit-Input für Mittwoch sollte die gleiche Default-Zeit haben wie Montag
    const miStundenInput = page.getByRole('textbox', { name: /Startzeit für Mittwoch Stunden/i })
    const miMinutenInput = page.getByRole('textbox', { name: /Startzeit für Mittwoch Minuten/i })
    await expect(miStundenInput).toBeVisible()

    const miStunden = await miStundenInput.inputValue()
    const miMinuten = await miMinutenInput.inputValue()

    // Mittwoch sollte die gleiche Default-Zeit haben wie Montag
    expect(miStunden).toBe(moStunden)
    expect(miMinuten).toBe(moMinuten)
  })

  test('Entfernen eines Tages entfernt auch den Zeit-Input', async ({ page }) => {
    await expect(page.getByRole('heading', { name: 'Kalender' })).toBeVisible()

    const kalenderSpalte = page.locator('[class*="border-l cursor-pointer"]').first()
    await kalenderSpalte.click({ position: { x: 50, y: 400 } })

    await expect(page.getByRole('heading', { name: 'Termine planen' })).toBeVisible()

    // Tag auswählen
    const miButton = page.locator('button').filter({ hasText: /^Mi$/ })
    await miButton.click()

    // Zeit-Input ist sichtbar (24h TimeInput)
    const miTimeInput = page.getByRole('textbox', { name: /Startzeit für Mittwoch Stunden/i })
    await expect(miTimeInput).toBeVisible()

    // Tag wieder abwählen
    await miButton.click()

    // Zeit-Input sollte verschwunden sein
    await expect(miTimeInput).not.toBeVisible()
  })
})
