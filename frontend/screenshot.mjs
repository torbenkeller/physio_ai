import { chromium } from '@playwright/test';

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  await page.setViewportSize({ width: 1920, height: 1080 });

  // Dashboard
  await page.goto('http://localhost:5173/');
  await page.waitForLoadState('networkidle');
  await page.screenshot({ path: 'screenshot-dashboard.png', fullPage: true });
  console.log('✓ Dashboard screenshot saved');

  // Kalender
  await page.goto('http://localhost:5173/kalender');
  await page.waitForLoadState('networkidle');
  await page.screenshot({ path: 'screenshot-kalender.png', fullPage: true });
  console.log('✓ Kalender screenshot saved');

  // Patienten
  await page.goto('http://localhost:5173/patienten');
  await page.waitForLoadState('networkidle');
  await page.screenshot({ path: 'screenshot-patienten.png', fullPage: true });
  console.log('✓ Patienten screenshot saved');

  // Abrechnung
  await page.goto('http://localhost:5173/abrechnung');
  await page.waitForLoadState('networkidle');
  await page.screenshot({ path: 'screenshot-abrechnung.png', fullPage: true });
  console.log('✓ Abrechnung screenshot saved');

  // Einstellungen
  await page.goto('http://localhost:5173/einstellungen');
  await page.waitForLoadState('networkidle');
  await page.screenshot({ path: 'screenshot-einstellungen.png', fullPage: true });
  console.log('✓ Einstellungen screenshot saved');

  await browser.close();
})();
