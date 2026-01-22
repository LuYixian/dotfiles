# /debug - Systematic Debugging

Debug issues using the ISOLATE → TRACE → VERIFY methodology.

## Methodology

### Phase 1: ISOLATE

**Goal:** Narrow down the problem scope

1. **Reproduce the issue**
   - Get exact error message or unexpected behavior
   - Identify minimal reproduction steps

2. **Identify boundaries**
   - Which component/module is affected?
   - When did it last work? (git bisect if needed)
   - What changed recently?

3. **Separate symptoms from cause**
   - The error you see may not be where the bug is
   - Trace the data flow backward

### Phase 2: TRACE

**Goal:** Find the root cause

1. **Follow the execution path**

   ```
   Entry point → Function calls → Error location
   ```

2. **Check data at each step**
   - Input values
   - Intermediate state
   - Output/return values

3. **Add diagnostic logging if needed**
   - Print/log variable values at key points
   - Use language-specific debugger (breakpoints)
   - Check request/response payloads for APIs

4. **Common culprits**
   - Null/undefined values
   - Type mismatches
   - Off-by-one errors
   - Race conditions
   - State mutations

### Phase 3: VERIFY

**Goal:** Confirm the fix works

1. **Propose minimal fix**
   - Change only what's necessary
   - Avoid refactoring while fixing

2. **Test the fix**
   - Does it solve the original issue?
   - Does it introduce regressions?
   - Edge cases covered?

3. **Document if needed**
   - Why the bug occurred
   - Why this fix is correct

## Usage

```
/debug <error message or description>
/debug The API returns 500 when user has no profile
/debug pytest fails on test_auth with AttributeError
```

## Output Format

```markdown
## Problem Analysis

**Symptom:** [What you see]
**Root Cause:** [Why it happens]
**Location:** `file.py:123`

## Fix

[Code change]

## Verification

[How to confirm it works]
```

## Tips

- Read error messages carefully - they often point to the issue
- Check recent git commits: `git log --oneline -10`
- Use `git diff` to see what changed
- Binary search with `git bisect` for regressions
