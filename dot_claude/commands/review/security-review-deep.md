# /security-review-deep - Deep Security Analysis

Perform a thorough security-focused code review with false-positive filtering.

## Usage

```
/security-review-deep
/security-review-deep --pr <number>
```

## Objective

Identify HIGH-CONFIDENCE security vulnerabilities with real exploitation potential.

**Key Principles:**

- Only flag issues with >80% confidence of actual exploitability
- Skip theoretical issues, style concerns, or low-impact findings
- Focus on vulnerabilities leading to unauthorized access, data breaches, or system compromise

## Workflow

### Step 1: Gather Context

```bash
git status
git diff --name-only origin/HEAD...
git log --no-decorate origin/HEAD...
git diff --merge-base origin/HEAD
```

### Step 2: Three-Phase Analysis

#### Phase 1: Repository Context Research

- Identify existing security frameworks and libraries
- Look for established secure coding patterns
- Examine existing sanitization and validation patterns
- Understand the project's security model

#### Phase 2: Comparative Analysis

- Compare new code against existing security patterns
- Identify deviations from established secure practices
- Look for inconsistent security implementations
- Flag code introducing new attack surfaces

#### Phase 3: Vulnerability Assessment

- Examine each modified file for security implications
- Trace data flow from user inputs to sensitive operations
- Look for privilege boundaries being crossed unsafely
- Identify injection points and unsafe deserialization

---

## Security Categories

### Input Validation Vulnerabilities

- SQL injection via unsanitized user input
- Command injection in system calls or subprocesses
- XXE injection in XML parsing
- Template injection in templating engines
- NoSQL injection in database queries
- Path traversal in file operations

### Authentication & Authorization

- Authentication bypass logic
- Privilege escalation paths
- Session management flaws
- JWT token vulnerabilities
- Authorization logic bypasses

### Crypto & Secrets Management

- Hardcoded API keys, passwords, or tokens
- Weak cryptographic algorithms
- Improper key storage or management
- Cryptographic randomness issues
- Certificate validation bypasses

### Injection & Code Execution

- Remote code execution via deserialization
- Pickle injection in Python
- YAML deserialization vulnerabilities
- Eval injection in dynamic code execution
- XSS vulnerabilities (reflected, stored, DOM-based)

### Data Exposure

- Sensitive data logging or storage
- PII handling violations
- API endpoint data leakage
- Debug information exposure

---

## Hard Exclusions (DO NOT Report)

1. Denial of Service (DOS) vulnerabilities
2. Secrets stored on disk (handled separately)
3. Rate limiting or resource exhaustion issues
4. Memory consumption or CPU exhaustion
5. Lack of input validation on non-security-critical fields
6. GitHub Action workflow issues without clear untrusted input
7. Lack of hardening measures (only flag concrete vulnerabilities)
8. Theoretical race conditions or timing attacks
9. Outdated third-party library vulnerabilities (managed separately)
10. Memory safety issues in Rust or memory-safe languages
11. Unit test files
12. Log spoofing concerns
13. SSRF that only controls path (not host/protocol)
14. User content in AI prompts
15. Regex injection
16. Documentation files
17. Lack of audit logs

---

## Precedents

1. Logging URLs is safe; logging secrets is a vulnerability
2. UUIDs are unguessable - no validation needed
3. Environment variables and CLI flags are trusted values
4. Resource management issues (memory/file descriptor leaks) are not valid
5. Subtle web vulnerabilities (tabnabbing, XS-Leaks, prototype pollution) - skip unless extremely high confidence
6. React/Angular are generally XSS-safe unless using `dangerouslySetInnerHTML` or similar
7. GitHub Action vulnerabilities need very specific attack paths
8. Client-side permission checks are not vulnerabilities (server handles this)
9. Shell script command injection needs concrete untrusted input path
10. Jupyter notebook vulnerabilities need specific attack paths

---

## Severity Guidelines

| Severity   | Description                                         |
| ---------- | --------------------------------------------------- |
| **HIGH**   | Directly exploitable: RCE, data breach, auth bypass |
| **MEDIUM** | Requires specific conditions but significant impact |
| **LOW**    | Defense-in-depth or lower-impact                    |

## Confidence Scoring

| Score   | Description                                         |
| ------- | --------------------------------------------------- |
| 0.9-1.0 | Certain exploit path identified                     |
| 0.8-0.9 | Clear vulnerability with known exploitation methods |
| 0.7-0.8 | Suspicious pattern requiring specific conditions    |
| < 0.7   | Don't report (too speculative)                      |

---

## Output Format

```markdown
# Security Review Report

## Summary

[Number of findings by severity]

## Findings

### Vuln 1: [Type]: `file.py:42`

- **Severity:** High
- **Confidence:** 0.9
- **Description:** [What the vulnerability is]
- **Exploit Scenario:** [How it could be exploited]
- **Recommendation:** [How to fix]

---

_Only findings with confidence >= 0.8 are included_
```
