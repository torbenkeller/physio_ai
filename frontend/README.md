# PhysioAI Frontend

React-based frontend for the PhysioAI physiotherapy practice management system.

## Tech Stack

- **React 19.2** with TypeScript (strict mode)
- **Vite 7** (Rolldown) - Build tool
- **Redux Toolkit** - State management
- **RTK Query** - API communication
- **React Router v7** - Routing
- **shadcn/ui** - UI components
- **Tailwind CSS** - Styling
- **React Hook Form** - Forms
- **Vitest** - Unit/Integration testing
- **Playwright** - E2E testing

## Architecture

See `CLAUDE.md` for detailed architecture documentation.

**Project Structure:**
- `src/app/` - App-wide setup (store, router, API)
- `src/features/` - Feature modules (patienten, behandlungen, rezepte, rechnungen)
- `src/shared/` - Shared components, hooks, and utilities

## Getting Started

### Prerequisites

- Node.js 18+ (recommended: Node.js 22)
- npm

### Installation

```bash
npm install
```

### Development

```bash
# Start dev server (http://localhost:5173)
npm run dev

# Run with custom port
npm run dev -- --port 3000
```

The dev server includes:
- Hot Module Replacement (HMR)
- API proxy to backend (`/api` → `http://localhost:8080`)

### Building

```bash
# Type check + build for production
npm run build

# Preview production build
npm run preview
```

### Code Quality

```bash
# Run ESLint
npm run lint

# TypeScript type checking
npm run type-check
```

### Testing

```bash
# Unit tests (watch mode)
npm run test

# Unit tests (single run)
npm run test:watch

# Coverage report
npm run test:coverage

# E2E tests
npm run test:e2e

# E2E tests with UI
npm run test:e2e:ui
```

## Environment Variables

Create `.env.local` for local configuration:

```bash
VITE_API_BASE_URL=http://localhost:8080/api
```

See `.env.example` for all available variables.

## Adding Features

1. Create feature folder in `src/features/[feature-name]/`
2. Add RTK Query API endpoints in `api/`
3. Define TypeScript types in `types/`
4. Create components in `components/`
5. Export public API in `index.ts`
6. Add route in `src/app/router.tsx`

## Adding UI Components

```bash
# Add shadcn/ui component
npx shadcn-ui@latest add [component-name]

# Example: Add button component
npx shadcn-ui@latest add button
```

Components are added to `src/shared/components/ui/`.

## Documentation

- **Architecture & Guidelines**: See `CLAUDE.md`
- **Product Vision**: `../docs/Product/Product-Vision.md` (or [Wiki](https://github.com/torbenkeller/physio_ai/wiki/Product-Vision))
- **Glossary**: `../docs/Architektur/12-Glossar.md` (or [Wiki](https://github.com/torbenkeller/physio_ai/wiki/Architektur/12-Glossar))
- **Backend API**: `../backend/CLAUDE.md`
- **Issues & Backlog**: [GitHub Issues](https://github.com/torbenkeller/physio_ai/issues)

## License

Private project - All rights reserved
