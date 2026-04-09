# API Service Code Standards

## Naming
- **Files**: kebab-case (`user-service.ts`, `auth-middleware.ts`)
- **Functions**: camelCase (`getUser`, `validateToken`)
- **Classes**: PascalCase (`UserService`, `AuthMiddleware`)
- **Constants**: UPPER_SNAKE_CASE (`MAX_RETRIES`, `DB_POOL_SIZE`)

## Architecture
- Controller/Service/Repository pattern
- Middleware for cross-cutting concerns (auth, logging, rate limiting)
- DTOs for request/response validation
- Error handling via centralized error middleware
- Health check endpoint at `/health`

## API Design
- Use consistent status codes
- Return structured error responses
- Version APIs via URL prefix (`/v1/`)
- Paginate list endpoints
- Rate limit public endpoints
