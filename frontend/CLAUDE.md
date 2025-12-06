# Frontend

## Technology Stack

- **Framework**: React 19.2 with TypeScript (strict mode)
- **Build Tool**: Vite 7 (Rolldown)
- **State Management**: Redux Toolkit
- **API Communication**: RTK Query (for all backend REST API calls)
- **Routing**: React Router v7
- **UI Library**: shadcn/ui + Tailwind CSS
- **Forms**: React Hook Form
- **Testing**: Vitest (Unit/Integration), Playwright (E2E), Testing Library (Component)
- **Linting**: ESLint 9
- **Language**: German only (no i18n)

## Architecture: Feature-Based Structure

```
src/
├── app/                    # App-wide setup (store, router, base API)
├── features/              # Feature modules (patienten, behandlungen, rezepte, rechnungen)
│   └── [feature]/
│       ├── api/          # RTK Query endpoints
│       ├── components/   # Feature-specific components
│       ├── hooks/        # Feature-specific hooks
│       ├── types/        # TypeScript types
│       └── index.ts      # Public API exports
├── shared/                # Shared across features
│   ├── components/ui/    # shadcn/ui components
│   ├── hooks/
│   ├── utils/
│   └── types/
└── assets/
```

## Core Principles

### State Management Philosophy

- **Server State**: Managed by RTK Query (patienten, behandlungen, rezepte, rechnungen)
- **UI State**: Managed by Redux Toolkit (modals, filters, selections)
- **Form State**: Managed by React Hook Form (local component state)
- **URL State**: Managed by React Router (current page, filters)

**NEVER duplicate server state in Redux slices!** RTK Query is the single source of truth.

### Backend Integration

- **REST API**: Spring Boot backend at `/api/*`
- **All API calls**: Use RTK Query endpoints, never manual fetch/axios
- **Error Handling**: Global error handling via RTK Query middleware
- **Types**: Define DTOs for API requests/responses

### Component Architecture

- **Functional components** with hooks (no class components)
- **Colocate**: Keep components close to where they're used
- **Feature isolation**: Features export only public API via `index.ts`
- **Lazy loading**: Use `React.lazy` for route-based code splitting

## Best Practices

### RTK Query

- Provide types for all endpoints
- Use `providesTags` and `invalidatesTags` for automatic cache invalidation
- Use generated hooks (`useGetPatientsQuery`, `useCreatePatientMutation`)
- NEVER fetch data in `useEffect` - always use RTK Query hooks

### Type Safety

- TypeScript strict mode enabled
- No `any` types (use `unknown` if truly dynamic)
- Always type component props explicitly
- Define separate DTOs for API requests/responses

### Code Style

- Prefer `const` over `let`, never use `var`
- Use arrow functions for component definitions
- Destructure props in function signature
- Use optional chaining (`?.`) and nullish coalescing (`??`)
- Use `React.memo` for expensive components

## Naming Conventions

### Files & Folders
- Components: `PascalCase.tsx` (e.g., `PatientList.tsx`)
- Hooks: `camelCase.ts` with `use` prefix (e.g., `usePatientForm.ts`)
- Types: `camelCase.types.ts` (e.g., `patient.types.ts`)
- API: `camelCase.ts` (e.g., `patientenApi.ts`)

### Code
- Components/Types/Interfaces: `PascalCase`
- Functions/Variables: `camelCase`
- Constants: `UPPER_SNAKE_CASE`

### German Domain Terms

Follow the Glossar (`docs/architektur/12-glossar.md`):
- **Patient** (not "user" for treated persons)
- **Behandlung** (for treatment sessions)
- **Rezept** (for medical prescriptions)
- **Rechnung** (for billing)
- **Termin** (for scheduled appointments)

Use German names for all domain models and business logic. English is OK for technical utilities.

## Testing Strategy

- **Unit Tests**: Components, hooks, utilities in isolation
- **Integration Tests**: Feature flows with mocked API (MSW)
- **E2E Tests**: Complete user flows in real browser
- **Colocate**: Place test files next to tested components

## Commands (run from frontend/ directory)

```bash
# Development
npm run dev              # Start dev server (http://localhost:5173)
npm run build            # Build for production
npm run preview          # Preview production build

# Code Quality
npm run lint             # Run ESLint
npm run type-check       # Run TypeScript compiler check

# Testing
npm run test             # Run unit tests (Vitest)
npm run test:watch       # Run tests in watch mode
npm run test:e2e         # Run E2E tests (Playwright)
```

## Common Tasks

### Adding a New Feature
1. Create folder: `src/features/[feature-name]/`
2. Add API endpoints in `api/[feature-name]Api.ts` using `api.injectEndpoints()`
3. Define types in `types/[feature-name].types.ts`
4. Create components in `components/`
5. Export public API in `index.ts`
6. Add route in `app/router.tsx`

### Adding shadcn/ui Components
```bash
npx shadcn-ui@latest add [component-name]
# Components added to src/shared/components/ui/
```