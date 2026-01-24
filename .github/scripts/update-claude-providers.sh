#!/bin/bash
# update-claude-providers.sh - Update Claude Code provider configs from official docs
# Usage:
#   ./update-claude-providers.sh prompt [provider]  # Generate Gemini prompt
#   ./update-claude-providers.sh apply              # Apply AI response (reads stdin)

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
CLAUDE_YAML="$REPO_ROOT/.chezmoidata/claude.yaml"

# Provider documentation URLs
declare -A PROVIDER_DOCS=(
    ["deepseek"]="https://api-docs.deepseek.com/guides/anthropic_api"
    ["kimi"]="https://platform.moonshot.cn/docs"
    ["glm"]="https://docs.bigmodel.cn/cn/coding-plan/tool/claude"
    ["qwen"]="https://help.aliyun.com/zh/model-studio/claude-code"
    ["minimax"]="https://platform.minimax.io/docs/coding-plan/claude-code"
    ["doubao"]="https://www.volcengine.com/docs/82379/1928261"
)

# Generate prompt for Gemini
generate_prompt() {
    local provider="${1:-all}"
    local providers=()

    if [[ "$provider" == "all" ]]; then
        providers=("${!PROVIDER_DOCS[@]}")
    else
        providers=("$provider")
    fi

    cat <<'HEADER'
You are a configuration extraction assistant. Your task is to extract Claude Code provider configuration from official documentation.

For each provider, extract these fields (if available):
- base_url: The API endpoint URL for Claude Code
- model: The recommended model ID
- small_model: The smaller/faster model ID (or same as model)
- timeout_ms: API timeout in milliseconds (if specified)
- disable_nonessential_traffic: true if documentation recommends this
- haiku_model: Model mapping for Haiku tier (optional)
- sonnet_model: Model mapping for Sonnet tier (optional)
- opus_model: Model mapping for Opus tier (optional)

IMPORTANT:
- Only include fields that are explicitly documented
- Use exact model IDs as shown in the documentation
- Return ONLY valid JSON, no markdown or explanation

Output format (JSON array):
```json
[
  {
    "provider": "provider_name",
    "config": {
      "base_url": "...",
      "model": "...",
      "small_model": "...",
      "timeout_ms": "...",
      "disable_nonessential_traffic": true
    }
  }
]
```

Extract configuration for the following providers:

HEADER

    for p in "${providers[@]}"; do
        local url="${PROVIDER_DOCS[$p]:-}"
        if [[ -n "$url" ]]; then
            echo "## $p"
            echo "Documentation: $url"
            echo ""
        fi
    done
}

# Apply AI response to claude.yaml
apply_response() {
    local response
    response=$(cat)

    # Extract JSON from response (handles markdown code blocks)
    local json
    json=$(echo "$response" | sed -n '/^\[/,/^\]/p' | head -1)
    if [[ -z "$json" ]]; then
        # Try extracting from code block
        json=$(echo "$response" | sed -n '/```json/,/```/p' | grep -v '```')
    fi
    if [[ -z "$json" ]]; then
        json=$(echo "$response" | sed -n '/```/,/```/p' | grep -v '```')
    fi

    # Validate JSON
    if ! echo "$json" | jq -e '.' >/dev/null 2>&1; then
        echo "Error: Invalid JSON in AI response" >&2
        echo "Response was:" >&2
        echo "$response" >&2
        exit 1
    fi

    # Apply each provider config
    echo "$json" | jq -c '.[]' | while read -r item; do
        local provider config
        provider=$(echo "$item" | jq -r '.provider')
        config=$(echo "$item" | jq -c '.config')

        echo "Updating: $provider"

        # Update each field if present
        for field in base_url model small_model timeout_ms haiku_model sonnet_model opus_model; do
            local value
            value=$(echo "$config" | jq -r ".$field // empty")
            if [[ -n "$value" ]]; then
                yq -i ".claude.providers.$provider.$field = \"$value\"" "$CLAUDE_YAML"
            fi
        done

        # Handle boolean field
        local disable
        disable=$(echo "$config" | jq -r '.disable_nonessential_traffic // empty')
        if [[ "$disable" == "true" ]]; then
            yq -i ".claude.providers.$provider.disable_nonessential_traffic = true" "$CLAUDE_YAML"
        fi
    done

    echo "Updated: $CLAUDE_YAML"
}

# Main
case "${1:-}" in
prompt)
    generate_prompt "${2:-all}"
    ;;
apply)
    apply_response
    ;;
*)
    echo "Usage: $0 prompt [provider|all]" >&2
    echo "       $0 apply < response.json" >&2
    exit 1
    ;;
esac
