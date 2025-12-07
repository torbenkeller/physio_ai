import '@testing-library/jest-dom'

// Mock ResizeObserver for cmdk and other components that use it
global.ResizeObserver = class ResizeObserver {
  observe() {}
  unobserve() {}
  disconnect() {}
}

// Mock scrollIntoView for cmdk
Element.prototype.scrollIntoView = () => {}

// Mock pointer capture for Radix components
Element.prototype.setPointerCapture = () => {}
Element.prototype.releasePointerCapture = () => {}
Element.prototype.hasPointerCapture = () => false
