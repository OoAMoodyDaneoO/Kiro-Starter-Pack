---
name: scaffold-microservice
description: "Scaffold a new microservice with standard project structure, boilerplate code, build configuration, and documentation. Use when bootstrapping a new backend service."
---

## Description

Scaffolds a complete microservice project with an opinionated directory structure, language-specific boilerplate, build configuration, and a starter README. The generated service follows team conventions for layout, naming, and tooling so every new service starts from a consistent baseline.

When invoked, you'll need: the service name (used for the root directory and package name), the programming language (e.g., `typescript`, `python`, `java`, `go`), the web framework (e.g., `express`, `fastapi`, `spring-boot`, `gin`), and optionally a port number (default: `3000`) and a short description of what the service does.

## Steps

1. **Create directory structure** — Generate the root directory `<service_name>/` with standard subdirectories:
   - `src/` — application source code
   - `src/routes/` — route or controller definitions
   - `src/services/` — business logic layer
   - `src/models/` — data models and schemas
   - `src/config/` — configuration loaders and constants
   - `tests/` — unit and integration test files
   - `docs/` — additional documentation

2. **Add boilerplate source code** — Generate starter files appropriate for the chosen language and framework:
   - Entry point file (e.g., `src/index.ts`, `src/main.py`, `src/Application.java`)
   - Health-check endpoint at `GET /health` returning `{ "status": "ok" }`
   - Example route with a placeholder CRUD handler
   - Configuration loader that reads from environment variables
   - Error handling middleware with structured JSON error responses

3. **Configure build and tooling** — Generate build and development configuration files:
   - Package manifest (e.g., `package.json`, `pyproject.toml`, `pom.xml`, `go.mod`)
   - Linter configuration (e.g., `.eslintrc`, `ruff.toml`, `checkstyle.xml`)
   - Formatter configuration (e.g., `.prettierrc`, `black` settings)
   - Dockerfile with a multi-stage build for production
   - `.env.example` listing required environment variables with placeholder values
   - `.gitignore` tailored to the chosen language

4. **Generate test scaffolding** — Create starter test files:
   - A sample unit test for the health-check endpoint
   - Test configuration file (e.g., `jest.config.ts`, `pytest.ini`)
   - Test helper or fixture file with common setup utilities

5. **Add README** — Generate a `README.md` inside the service directory containing:
   - Service name and description
   - Prerequisites and setup instructions
   - How to run locally (with and without Docker)
   - Available scripts and commands
   - Environment variable reference table
   - API endpoint summary

## Expected Output

A fully scaffolded microservice directory at `<service_name>/` containing source code, tests, build configuration, a Dockerfile, and a README. The service compiles, starts, and responds to a health-check request out of the box with no additional setup beyond installing dependencies.

## Notes

- The generated structure is a starting point — add or remove subdirectories to match your team's conventions.
- Framework-specific middleware (auth, logging, CORS) is not included by default; add it after scaffolding.
- The Dockerfile assumes a single-service build. For monorepo setups, adjust the build context and copy paths.
- If your organization uses a private package registry, update the generated package manifest to point to it.
- The health-check endpoint is intentionally simple. Extend it to include dependency checks (database, cache) for production readiness.