# SaaS Web Code Standards

## Naming
- **Components**: PascalCase (`UserProfile`, `DashboardLayout`)
- **Functions/hooks**: camelCase (`useAuth`, `fetchUsers`)
- **Constants**: UPPER_SNAKE_CASE (`API_BASE_URL`)
- **Files**: kebab-case (`user-profile.tsx`, `auth-service.ts`)

## Architecture
- Server Components by default, Client Components only when needed
- Colocate related files (component + test + styles)
- Use server actions for mutations
- Centralize API calls in service modules
- Type everything — no `any`

## Security
- Validate all user input server-side
- Use parameterized queries (no raw SQL)
- Sanitize output to prevent XSS
- Implement CSRF protection
- Use environment variables for secrets
