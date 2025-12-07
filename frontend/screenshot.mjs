import { chromium } from '@playwright/test'
import dotenv from 'dotenv'
import path from 'path'
import { fileURLToPath } from 'url'

const __dirname = path.dirname(fileURLToPath(import.meta.url))
dotenv.config({ path: path.resolve(__dirname, '..', '.env') })

const frontendPort = process.env.PHYSIO_FRONTEND_PORT || '5173'
const baseURL = `http://localhost:${frontendPort}`

;(async () => {
  const browser = await chromium.launch()
  const page = await browser.newPage()
  await page.setViewportSize({ width: 1920, height: 1080 })

  // Dashboard
  await page.goto(`${baseURL}/`)
  await page.waitForLoadState('networkidle')
  await page.screenshot({ path: 'screenshot-dashboard.png', fullPage: true })
  console.log('Dashboard screenshot saved')

  // Kalender
  await page.goto(`${baseURL}/kalender`)
  await page.waitForLoadState('networkidle')
  await page.screenshot({ path: 'screenshot-kalender.png', fullPage: true })
  console.log('Kalender screenshot saved')

  // Patienten
  await page.goto(`${baseURL}/patienten`)
  await page.waitForLoadState('networkidle')
  await page.screenshot({ path: 'screenshot-patienten.png', fullPage: true })
  console.log('Patienten screenshot saved')

  // Abrechnung
  await page.goto(`${baseURL}/abrechnung`)
  await page.waitForLoadState('networkidle')
  await page.screenshot({ path: 'screenshot-abrechnung.png', fullPage: true })
  console.log('Abrechnung screenshot saved')

  // Einstellungen
  await page.goto(`${baseURL}/einstellungen`)
  await page.waitForLoadState('networkidle')
  await page.screenshot({ path: 'screenshot-einstellungen.png', fullPage: true })
  console.log('Einstellungen screenshot saved')

  await browser.close()
})()
