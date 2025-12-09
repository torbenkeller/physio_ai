# PhysioAI - Monorepo Instructions

This is a monorepo containing backend, frontend, and documentation for the PhysioAI system.

## Structure

```
physio_ai/
├── backend/  # Spring Boot backend → See backend/CLAUDE.md
├── frontend/ # React frontend → See frontend/CLAUDE.md
└── docs/     # Project documentation (Markdown)
```

## Working with this Monorepo

Each subdirectory contains its own `CLAUDE.md` with specific instructions:

- **Backend tasks**: Navigate to `backend/` and follow `backend/CLAUDE.md`
- **Frontend tasks**: Navigate to `frontend/` and follow `frontend/CLAUDE.md`
- **Documentation**: The `docs/` folder contains project documentation
  - Architecture docs: `docs/Architektur/`
  - Product docs: `docs/Product/`
- **Backlog & Issues**: Managed in GitHub Issues: https://github.com/torbenkeller/physio_ai/issues

## General Guidelines

- ALWAYS use your built-in tools to interact with the file system
- ALWAYS use UTF-8 Encoding
- Follow conventional commit message format
- Keep commits atomic and focused