# /security-scan - Security Analysis

Perform security analysis on code changes or entire codebase.

## Quick Scan (Current Changes)

### Step 1: Identify Changed Files

```bash
git diff --name-only HEAD~1  # Or relevant commit range
```

### Step 2: Check for Common Issues

#### Secrets Detection

Look for:

- API keys, tokens, passwords in code
- Hardcoded credentials
- Private keys or certificates
- Connection strings with credentials

```bash
# Pattern search for potential secrets
grep -rn "password\|secret\|api_key\|token\|private_key" --include="*.py" --include="*.js" --include="*.ts"
```

#### Injection Vulnerabilities

- SQL: String concatenation in queries
- Command: User input in shell commands
- XSS: Unescaped user input in HTML
- Path traversal: User input in file paths

#### Authentication/Authorization

- Missing auth checks on endpoints
- Hardcoded credentials
- Weak password requirements
- Session management issues

### Step 3: Dependency Vulnerabilities

```bash
# Python
uv pip audit

# Node.js
npm audit
```

## Full Scan Checklist

### OWASP Top 10 Review

- [ ] **Injection**: SQL, NoSQL, OS, LDAP injection
- [ ] **Broken Auth**: Weak passwords, session issues
- [ ] **Sensitive Data**: Encryption, data exposure
- [ ] **XXE**: XML external entity processing
- [ ] **Broken Access Control**: Missing authorization
- [ ] **Misconfig**: Default credentials, verbose errors
- [ ] **XSS**: Reflected, stored, DOM-based
- [ ] **Insecure Deserialization**: Pickle, eval, exec
- [ ] **Vulnerable Components**: Outdated dependencies
- [ ] **Insufficient Logging**: Missing audit trails

### Python-Specific

- [ ] `eval()`, `exec()`, `compile()` with user input
- [ ] `pickle.loads()` on untrusted data
- [ ] `subprocess` with `shell=True`
- [ ] `os.system()` calls
- [ ] SQL string formatting (use parameterized queries)
- [ ] `yaml.load()` without `Loader=SafeLoader`

### Web-Specific

- [ ] CORS misconfiguration
- [ ] Missing CSRF protection
- [ ] Insecure cookies (missing HttpOnly, Secure)
- [ ] Missing Content-Security-Policy
- [ ] Sensitive data in URLs

## Report Format

```markdown
## Security Scan Report

### Summary

- Critical: X
- High: X
- Medium: X
- Low: X

### Findings

#### [CRITICAL] Finding Title

- **Location**: `file.py:123`
- **Issue**: Description
- **Impact**: What could happen
- **Remediation**: How to fix

[Repeat for each finding]
```

## Automated Tools

```bash
# Python static analysis
bandit -r src/            # Security linter
semgrep --config auto .   # Pattern matching

# Secrets scanning
gitleaks detect           # Git history scan
trufflehog git file://.   # Alternative
```
