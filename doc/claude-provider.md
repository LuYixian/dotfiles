# Claude Code Provider Tools

Manage Claude Code API providers with multi-account support and FZF integration.

## Overview

| Tool            | Purpose                        | Alias |
| --------------- | ------------------------------ | ----- |
| `claude-with`   | Launch with temporary provider | `ccw` |
| `claude-manage` | Manage provider configuration  | `ccm` |
| `claude-token`  | Internal token fetcher         | -     |

## claude-with

Wrapper script that launches Claude Code with a specified provider via environment variables.

```bash
# FZF interactive picker
claude-with

# Launch with specific provider
claude-with deepseek
claude-with kimi@work

# Pass arguments to claude
claude-with deepseek -- --resume

# List available providers
claude-with --list
```

## claude-manage

Manage default provider configuration, accounts, and API keys.

```bash
# FZF interactive manager
claude-manage

# List accounts
claude-manage list
claude-manage list deepseek

# Get/set default provider
claude-manage default           # Show current
claude-manage default kimi@work # Set default

# Add new account (must not exist)
claude-manage add
claude-manage add deepseek@work

# Update existing account API key
claude-manage update
claude-manage update kimi@work

# Delete account
claude-manage delete
claude-manage delete kimi@work

# Test connectivity
claude-manage test
claude-manage test kimi
```

## claude-token

Internal tool for fetching API tokens. Primarily called by `apiKeyHelper` and other tools.

```bash
# Get current provider token (for apiKeyHelper)
claude-token

# Get token for specific provider
claude-token deepseek@work

# Check if token exists (exit code only)
claude-token --check kimi

# Get provider config as JSON
claude-token --config deepseek
```

## Provider Configuration

Providers are defined in `.chezmoidata/claude.yaml`:

```yaml
claude:
  providers:
    # Native Anthropic (OAuth, no API key needed)
    anthropic:
      model: claude-sonnet-4-5-20250929
    opus:
      model: claude-opus-4-5-20251101
    haiku:
      model: claude-haiku-4-5-20251001

    # Third-party (API key required)
    deepseek:
      base_url: https://api.deepseek.com/anthropic
      model: deepseek-chat
    kimi:
      base_url: https://api.kimi.com/coding
      model: kimi-k2.5
    # ... more providers
```

## Multi-Account Support

Use `provider@account` format to manage multiple accounts:

```bash
# Add different accounts
claude-manage add deepseek@work
claude-manage add deepseek@personal

# Use specific account
claude-with deepseek@work
claude-manage default deepseek@personal
```

API keys are stored in gopass:

```text
claude-code/providers/{provider}/{account}/api_key
```

## VS Code Integration

Use `claude-with` as a command wrapper in VS Code settings:

```json
{
  "claude.codebase.commandWrapper": ["claude-with", "deepseek@work", "--"]
}
```

## Workflow Examples

### Daily Development

```bash
# Default to anthropic (official)
claude

# Temporarily switch to DeepSeek for testing
claude-with deepseek

# Need Kimi frequently? Set as default
claude-manage default kimi
```

### New Machine Setup

```bash
# 1. Add API key
claude-manage add deepseek

# 2. Test connectivity
claude-manage test deepseek

# 3. Set as default (optional)
claude-manage default deepseek
```

### Multi-Project Switching

```bash
# Project A uses company account
claude-with deepseek@work

# Project B uses personal account
claude-with deepseek@personal
```
