# /code-review-pragmatic - Pragmatic Code Review

Conduct a comprehensive code review using the "Pragmatic Quality" framework.

## Usage

```
/code-review-pragmatic
/code-review-pragmatic --pr <number>
```

## Philosophy

**Net Positive > Perfection**: Change is good if it improves overall code health.

## Workflow

### Step 1: Gather Context

```bash
# Current state
git status

# Files modified
git diff --name-only origin/HEAD...

# Commits
git log --no-decorate origin/HEAD...

# Full diff
git diff --merge-base origin/HEAD
```

### Step 2: Review Framework

Use the hierarchical review checklist below to analyze changes.

---

## Hierarchical Review Framework

### 1. Architectural Design & Integrity (Critical)

- [ ] Design aligns with existing architectural patterns
- [ ] Modularity and Single Responsibility Principle
- [ ] No unnecessary complexity - simpler solution possible?
- [ ] Change is atomic (single, cohesive purpose)
- [ ] Appropriate abstraction levels and separation of concerns

### 2. Functionality & Correctness (Critical)

- [ ] Code correctly implements intended business logic
- [ ] Edge cases, error conditions, unexpected inputs handled
- [ ] No logical flaws, race conditions, or concurrency issues
- [ ] State management and data flow correct
- [ ] Idempotency where appropriate

### 3. Security (Non-Negotiable)

- [ ] All user input validated, sanitized, and escaped
- [ ] Authentication and authorization checks on protected resources
- [ ] No hardcoded secrets, API keys, or credentials
- [ ] No data exposure in logs, error messages, or API responses
- [ ] CORS, CSP, and security headers where applicable
- [ ] Standard library for cryptographic implementations

### 4. Maintainability & Readability (High Priority)

- [ ] Code clarity for future developers
- [ ] Descriptive and consistent naming conventions
- [ ] Reasonable control flow complexity and nesting depth
- [ ] Comments explain 'why' (intent/trade-offs) not 'what' (mechanics)
- [ ] Error messages aid debugging
- [ ] No code duplication that should be refactored

### 5. Testing Strategy & Robustness (High Priority)

- [ ] Test coverage relative to code complexity and criticality
- [ ] Tests cover failure modes, security edge cases, error paths
- [ ] Tests maintainable and clear
- [ ] Appropriate test isolation and mock usage
- [ ] Integration or E2E tests for critical paths

### 6. Performance & Scalability (Important)

- [ ] **Backend:** No N+1 queries, missing indexes, inefficient algorithms
- [ ] **Frontend:** Bundle size impact, rendering performance, Core Web Vitals
- [ ] **API Design:** Consistency, backwards compatibility, pagination
- [ ] Caching strategies and invalidation logic
- [ ] No potential memory leaks or resource exhaustion

### 7. Dependencies & Documentation (Important)

- [ ] New third-party dependencies justified
- [ ] Dependency security, maintenance status, license compatibility
- [ ] API documentation updated for contract changes
- [ ] Configuration or deployment documentation updated

---

## Output Format

```markdown
### Code Review Summary

[Overall assessment and high-level observations]

### Findings

#### Critical Issues

- [File:Line]: [Description and why it's critical, grounded in engineering principles]

#### Suggested Improvements

- [File:Line]: [Suggestion and rationale]

#### Nitpicks

- Nit: [File:Line]: [Minor detail]
```

## Severity Levels

| Level                | When to Use                                                |
| -------------------- | ---------------------------------------------------------- |
| `[Critical/Blocker]` | Must fix before merge (security, architectural regression) |
| `[Improvement]`      | Strong recommendation for better implementation            |
| `[Nit]`              | Minor polish, optional                                     |

## Principles

- **Focus on Substance**: Assume CI passed, focus on architecture/design/logic
- **Grounded in Principles**: Use SOLID, DRY, KISS, YAGNI
- **Signal Intent**: Prefix minor suggestions with "Nit:"
- **Be Constructive**: Maintain objectivity, assume good intent
