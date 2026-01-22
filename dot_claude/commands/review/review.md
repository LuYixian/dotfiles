# /review - Code Review

Perform a structured code review with security, correctness, and maintainability checks.

## Checklist

### Security (Critical)

- [ ] No hardcoded secrets, API keys, or passwords
- [ ] Input validation (SQL injection, XSS, command injection)
- [ ] Proper authentication/authorization checks
- [ ] Sensitive data handling (encryption, secure storage)
- [ ] No dangerous functions (eval, exec without sanitization)

### Correctness (High)

- [ ] Edge cases handled (null, empty, boundary values)
- [ ] Error handling is complete and appropriate
- [ ] Type safety maintained
- [ ] Logic matches requirements
- [ ] No obvious bugs or typos

### Performance (Medium)

- [ ] No N+1 query problems
- [ ] Appropriate data structures used
- [ ] No unnecessary computations in loops
- [ ] Resources properly released (connections, files)

### Maintainability (Medium)

- [ ] Clear, descriptive naming
- [ ] Functions have single responsibility
- [ ] Appropriate abstraction level
- [ ] No code duplication (DRY)
- [ ] Comments explain WHY, not WHAT

### Testing

- [ ] Tests cover the changes
- [ ] Edge cases tested
- [ ] No flaky tests introduced

## Usage

```
/review                     # Review staged/uncommitted changes
/review path/to/file.py     # Review specific file
/review --security          # Focus on security only
/review --quick             # Quick pass, critical issues only
```

## Output Format

```markdown
## Code Review: [filename]

### Critical Issues

- [line:123] Description of critical issue

### Suggestions

- [line:45] Suggestion for improvement

### Good Practices

- Well-structured error handling
- Clear variable naming

### Summary

[Overall assessment and recommendation]
```

## Severity Levels

| Level      | Meaning                       | Action                |
| ---------- | ----------------------------- | --------------------- |
| Critical   | Security flaw, data loss risk | Must fix before merge |
| Warning    | Potential bug, bad practice   | Should fix            |
| Suggestion | Could be improved             | Nice to have          |
| Info       | Style, minor optimization     | Optional              |

## Common Issues to Watch

### Python

- Mutable default arguments
- Missing `__init__.py`
- Bare `except:` clauses
- String formatting with `%` (use f-strings)

### JavaScript/TypeScript

- Missing null checks
- Async/await without try-catch
- Memory leaks in event listeners
- Implicit type coercion

### General

- TODO/FIXME left in production code
- Commented-out code
- Magic numbers without explanation
- Overly complex conditionals
