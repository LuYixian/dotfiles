#!/bin/bash
# skill-hint.sh - Lightweight skill suggestions based on prompt keywords
# Non-blocking: provides hints without interrupting workflow
# Source: Inspired by claude-code-showcase skill evaluation system

input=$(cat)
prompt=$(echo "$input" | jq -r '.prompt // ""' 2>/dev/null | tr '[:upper:]' '[:lower:]')

# Exit early if no prompt
if [[ -z "$prompt" ]]; then
    exit 0
fi

hints=""

# Keyword-based suggestions (ordered: specific patterns first)
case "$prompt" in
*security* | *vulnerability* | *auth* | *password* | *token* | *secret*)
    hints="Tip: security-review skill activated for security-sensitive code"
    ;;
*unittest* | *pytest* | *"test "* | *" test"* | *tdd*)
    hints="Tip: /test for TDD workflow (Red->Green->Refactor)"
    ;;
*debug* | *bug* | *error* | *fix* | *issue* | *broken*)
    hints="Tip: /debug for systematic debugging (ISOLATE->TRACE->VERIFY)"
    ;;
*"code review"* | *"review code"* | *"check code"*)
    hints="Tip: /review for code review checklist"
    ;;
*refactor* | *clean*up* | *improve*code*)
    hints="Tip: /refactor for safe refactoring with verification"
    ;;
*commit* | *message*)
    hints="Tip: /commit for context-aware commit, or 'aicommit' in terminal for quick commits"
    ;;
*scaffold* | *new*project* | *create*project* | *init*project*)
    hints="Tip: /scaffold for project templates, or 'create_py_project' in terminal for quick Python setup"
    ;;
*context* | *understand* | *explain* | *how*does*)
    hints="Tip: /context for codebase structure analysis"
    ;;
esac

if [ -n "$hints" ]; then
    # Output as JSON message that Claude Code will display
    echo "{\"message\": \"$hints\"}"
fi

exit 0
