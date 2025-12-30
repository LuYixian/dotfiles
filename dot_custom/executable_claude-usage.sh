#!/bin/bash
# Display Claude API usage from usage.json cache
# This file is typically updated by Claude Code after each session

USAGE_FILE="${HOME}/.claude/usage.json"

if [[ ! -f "$USAGE_FILE" ]]; then
    exit 0
fi

# Get today's usage
today=$(date +%Y-%m-%d)
usage=$(jq -r --arg date "$today" '.[$date] // empty' "$USAGE_FILE" 2>/dev/null)

if [[ -z "$usage" ]]; then
    exit 0
fi

# Extract token counts
input_tokens=$(echo "$usage" | jq -r '.input_tokens // 0')
output_tokens=$(echo "$usage" | jq -r '.output_tokens // 0')
total_tokens=$((input_tokens + output_tokens))

# Format with K suffix for readability
if [[ $total_tokens -gt 1000000 ]]; then
    formatted=$(printf "%.1fM" $(echo "scale=1; $total_tokens/1000000" | bc))
elif [[ $total_tokens -gt 1000 ]]; then
    formatted=$(printf "%.1fk" $(echo "scale=1; $total_tokens/1000" | bc))
else
    formatted=$total_tokens
fi

echo "$formatted"
