# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Engineers Hub is a monorepo platform for engineer growth support, consisting of three integrated services:
- **Tech Road**: Skill roadmap management
- **Tech Library**: Learning content management  
- **Tech Log**: Learning/development history tracking

## Architecture

### Service Structure
Each service follows a `web/api` structure:
```
services/
├── tech-road/
│   ├── web/    # SvelteKit frontend
│   └── api/    # Rust/Axum backend
├── tech-library/
└── tech-log/
```

### Backend Architecture
- **Language**: Rust with Axum framework
- **Database**: PostgreSQL with schema separation (tech_road.*, tech_library.*, tech_log.*)
- **API Style**: RESTful with `/api/v1/` prefix
- **Layers**: Presentation → Application → Domain → Infrastructure

### Frontend Architecture
- **Framework**: SvelteKit with Vite
- **Structure**: Routes → Components → Services → Stores

## Common Commands

```bash
# Development
make dev          # Start Docker development environment
make install      # Install dependencies
make test         # Run all tests
make build        # Build all services
make clean        # Clean build artifacts

# Docker
make docker-up    # Start containers
make docker-down  # Stop containers

# Service-specific commands (run from service directory)
cd services/tech-road/api && cargo build    # Build Rust API
cd services/tech-road/web && pnpm dev       # Run SvelteKit dev server
```

## Development Guidelines

### API Development
- All APIs follow RESTful conventions with consistent response format
- JWT authentication with Bearer tokens
- Response format: `{ "success": bool, "data": {...} }` or `{ "success": false, "error": {...} }`
- Error codes defined in docs/api/tech-road-api-spec.md

### Database Schema
- User data in `public` schema (shared)
- Service-specific data in respective schemas
- Migrations will be in `services/{service}/api/migrations/`

### Docker Development
- PostgreSQL on port 5432
- Redis on port 6379
- Tech Road API on port 8001
- Tech Library API on port 8002  
- Tech Log API on port 8003
- Web apps on port 3000

### Testing Strategy
- Unit tests alongside code
- Integration tests in `tests/` directories
- Run specific Rust tests: `cargo test {test_name}`
- Run specific SvelteKit tests: `pnpm test {test_name}`

## Key Implementation Notes

### Domain Models
Core domain entities are defined in docs/architecture/domain-model.md:
- User (shared entity)
- Roadmap, RoadmapNode, UserProgress (Tech Road)
- Content, ContentRating, LearningPath (Tech Library)
- LearningLog, ProjectLog, SkillSnapshot (Tech Log)

### Authentication Flow
1. Register/Login returns access_token + refresh_token
2. Use Bearer token in Authorization header
3. Refresh token when access_token expires

### Service Communication
- Phase 1: Direct REST API calls between services
- Phase 2: Consider gRPC for internal service communication

## Current Development Phase

The project is in Phase 0 (Foundation). Next steps:
1. Implement Tech Road API (Rust/Axum)
2. Implement Tech Road Web (SvelteKit)
3. Set up GitHub Actions CI/CD
4. Complete Docker development environment

Refer to docs/planning/development-phases.md for the complete roadmap.