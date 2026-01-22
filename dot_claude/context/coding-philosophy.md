# Coding Philosophy

## Core Beliefs

- **Pursue good taste** - Eliminate edge cases to make code logic natural
- **Embrace extreme simplicity** - Complexity is the root of all evil
- **Be pragmatic** - Solve real problems, not hypothetical ones
- **Data structures first** - Good programmers worry about data structures
- **Never break backward compatibility** - Existing functionality is sacred
- **Incremental progress** - Small changes that compile and pass tests
- **Learn from existing code** - Study before implementing
- **Clear intent over clever code** - Be boring and obvious

## Simplicity Means

- Single responsibility per function/class
- Avoid premature abstractions
- No clever tricks - choose the boring solution
- If you need to explain it, it's too complex

## Fix, Don't Hide

**Solve problems, don't silence symptoms:**

❌ `@ts-ignore`, `skip`, `ignore`, empty catch, `as any`, excessive timeouts

✅ Fix the root cause

## Learning the Codebase

Before implementing:

1. Find 3+ similar features/components
2. Identify common patterns and conventions
3. Use same libraries/utilities when possible
4. Follow existing test patterns

## Tooling Rules

- Use project's existing build system
- Use project's test framework
- Use project's formatter/linter settings
- Don't introduce new tools without strong justification

## Content Uniqueness

- Each layer owns its abstraction level
- Reference, don't duplicate
- Maintain perspective at appropriate scale
- Higher layers stay architectural

## Collaboration Boundaries

**AI autonomy zone (proceed without asking):**

- Implementation details within approved direction
- Standard formatting and style choices
- Obvious bug fixes with clear solutions
- Exploratory mode experiments (L1-L2)

**Human decision zone (escalate):**

- Architectural choices with multiple valid approaches
- Trade-offs between competing requirements
- Changes with wide, hard-to-reverse impact
- Novel patterns not established in codebase

## Execution Rules

**ALWAYS:**

- Plan complex tasks before implementation
- Track progress with TodoWrite for L3+ tasks
- Stop after 5 consecutive failures and request guidance
- Report guardrail changes (see `guardrails.md`)

**Edit fallback:** When Edit fails 2+ times → try sed/awk → then Write
