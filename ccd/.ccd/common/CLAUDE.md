# Development Guidelines

## Core Principles

**Research First, Implement Second**
- When uncertain about implementation details, always research using web search to find official documentation
- If no documentation exists, create and run test scripts in `/tmp` or current working directory to verify assumptions
- Never implement anything you are unsure of without proper verification
- Avoid mock/test/quick fixes - always implement the actual required changes

**Code Quality Standards**
- Never use emoji in code
- Use descriptive variable names that clearly communicate purpose and intent
- Follow the principle of least surprise - code should behave as expected
- Prefer explicit over implicit behavior
- Write self-documenting code that minimizes the need for comments

## TypeScript Standards

**Absolute Type Safety**
- Follow the strictest TypeScript rules regardless of ESLint/tsconfig configuration
- **Zero tolerance for 'any' type** - never use 'any' implicitly or explicitly
- For external API responses (fetch/axios) or JSON.parse that resolve to 'any':
  ```typescript
  const response = await fetch('/api/data');
  const data: unknown = await response.json();
  // Validate and narrow type from here
  ```

**Type System Best Practices**
- Always handle null/undefined cases explicitly with strict null checks
- Verify array/object access safety - no unchecked index access
- Prefer type inference over explicit type declarations
- When referencing return types of other functions, use `ReturnType<typeof functionName>` or `Awaited<ReturnType<typeof asyncFunction>>`
- Use proper generic constraints to ensure compile-time safety
- Prefer `type` over `interface` for type definitions
- Prefer arrow functions over function declarations

## React Development

**Component Architecture**
- **One component per file** - each file contains exactly one component
- Export component Props type and variants (when using cva) from the same file
- Isolate client-side interactions to minimize client components

**Hook Dependencies**
- Ensure useEffect/useMemo/useCallback dependency arrays are complete and accurate
- Never ignore ESLint warnings about missing dependencies

**State Management & Performance**
- **Minimize state usage** - keep state to absolute minimum necessary
- For forms, prefer using form values directly after submission instead of local state
- Only use state for absolute necessities like validation on input change
- Prefer state over document.querySelector unless there's heavy performance impact
- Choose appropriate state patterns: useState for local, useReducer for complex, Context for shared
- Use React.memo, useMemo, and useCallback judiciously, not by default
- Implement proper error boundaries for component trees

**Component Naming**
- Use PascalCase for both filename and component name (e.g., `UserProfile.tsx` with `UserProfile` component)

## Next.js Architecture

**Server-First Approach**
- **Always prefer Server Components** unless client interaction is absolutely required
- **Entry files must be Server Components** - page.tsx and layout.tsx should always be Server Components
- When client interaction is needed:
  - Create separate client components and import them into Server Components
  - Mark only the interactive component as 'use client'
  - Keep parent and sibling components as Server Components

**File Naming & Structure**
- Route files: use hyphens (e.g., `app/hello-world/page.tsx`)
- Component names: use PascalCase with descriptive suffixes (e.g., `HelloWorldPage`)
- Component files: use PascalCase matching the component name

**Styling & Performance**
- Use global CSS + Tailwind CSS exclusively
- **Never create CSS module files**
- Leverage Next.js built-in optimizations (Image, Link, Script components)
- Follow App Router conventions and file-based routing patterns

**Data Handling**
- Use Server Components for data fetching when possible
- Implement proper loading and error states
- Cache data appropriately using Next.js caching strategies

## Security Requirements

- Never expose sensitive data in client-side code
- Use environment variables for all configuration secrets
- Validate all inputs on both client and server sides
- Sanitize data before database operations
- Never commit secrets, API keys, or credentials to version control

## Go Development

**Package & Project Structure**
- Follow standard Go project layout: `/cmd`, `/pkg`, `/internal`, `/api`, `/web`, `/configs`, `/scripts`
- Use lowercase package names with no underscores or hyphens
- Package names should be short, concise, and descriptive
- Avoid stuttering in package.function names (e.g., `http.Server` not `http.HTTPServer`)

**Naming Conventions**
- **Files**: Use lowercase with underscores for separation (e.g., `user_service.go`, `http_handler.go`)
- **Variables/Functions**: Use camelCase for unexported, PascalCase for exported
- **Constants**: Use UPPER_SNAKE_CASE for package-level constants
- **Interfaces**: Use `-er` suffix when possible (e.g., `Reader`, `Writer`, `Handler`)
- **URLs & Routes**: Always use hyphens (e.g., `/api/user-profile`, `/health-check`)
- **Query Parameters**: Use hyphens (e.g., `?user-id=123&created-at=2024`)

**Error Handling**
- Always handle errors explicitly - never ignore them
- Use `errors.New()` or `fmt.Errorf()` for simple errors
- Implement custom error types for complex error handling
- Wrap errors with context using `fmt.Errorf("operation failed: %w", err)`
- Return errors as the last return value

**Type Safety & Performance**
- Prefer composition over inheritance
- Use interfaces to define behavior, structs to define data
- Keep interfaces small and focused (interface segregation)
- Use pointer receivers for methods that modify the receiver or for large structs
- Use value receivers for small structs and methods that don't modify the receiver

**Concurrency**
- Use channels for communication between goroutines
- Prefer `sync.WaitGroup` for waiting on multiple goroutines
- Use `context.Context` for cancellation and timeouts
- Always handle context cancellation in long-running operations
- Avoid shared mutable state - use channels or mutexes when necessary

**HTTP & API Development**
- Use standard library `net/http` or proven frameworks like Gin/Echo
- Implement proper middleware for logging, auth, CORS
- Use structured logging (e.g., `slog` package)
- Validate all input data with proper error responses
- Use proper HTTP status codes and consistent error response format

**Testing**
- Write table-driven tests using `testing.T`
- Use `testify/assert` or `testify/require` for assertions when needed
- Create test helpers in `_test.go` files
- Use `httptest` package for HTTP handler testing
- Aim for meaningful test names that describe the scenario

**Code Organization**
- Keep functions small and focused on single responsibility
- Use early returns to reduce nesting
- Group related functionality in the same package
- Separate business logic from HTTP handlers
- Use dependency injection for better testability

## URL & Parameter Naming

**Consistent Hyphen Usage**
- **All file names**: Use hyphens instead of camelCase (e.g., `user-profile.tsx`, `api-client.go`)
- **Next.js routes**: Use hyphens (e.g., `app/user-profile/page.tsx`, `pages/api/user-data.ts`)
- **API endpoints**: Use hyphens (e.g., `/api/user-profile`, `/health-check`)
- **Query parameters**: Use hyphens (e.g., `?user-id=123`, `?created-at=2024-01-01`)
- **URL paths**: Use hyphens for multi-word segments (e.g., `/user-settings`, `/admin-panel`)

## Code Review Checklist

Before considering any implementation complete:

**TypeScript/React/Next.js:**
- [ ] All TypeScript types avoid 'any' (prefer inference when possible)
- [ ] External API responses are properly typed from 'unknown'
- [ ] React hooks have correct dependency arrays
- [ ] Server Components are used where possible (entry files are Server Components)
- [ ] No CSS modules or additional stylesheets created
- [ ] State usage is minimized (forms use direct values when possible)
- [ ] All inputs are validated
- [ ] No secrets exposed in client code
- [ ] File and component naming follows PascalCase/hyphen conventions

**Go:**
- [ ] All errors are handled explicitly
- [ ] Package structure follows Go conventions
- [ ] Interfaces are small and focused
- [ ] Proper use of pointers vs values for receivers
- [ ] Context is used for cancellation/timeouts in long operations
- [ ] HTTP handlers are properly tested
- [ ] No shared mutable state without proper synchronization

**Universal:**
- [ ] URLs and query parameters use hyphens consistently
- [ ] File names use hyphens (no camelCase in file names)
- [ ] Code follows naming conventions and is self-documenting
