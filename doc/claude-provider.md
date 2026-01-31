# Claude Code Provider Tools

Manage Claude Code API providers with multi-account support and FZF integration.

## Overview

| Tool              | Purpose                        | Use Case                           |
| ----------------- | ------------------------------ | ---------------------------------- |
| `claude-with`     | Launch with temporary provider | Quick switch without config change |
| `claude-provider` | Manage default provider config | Set default, manage API keys       |
| `claude-token`    | Internal token fetcher         | Called by other tools              |

## claude-with

Wrapper script that launches Claude Code with a specified provider via environment variables.

### Usage

```bash
# FZF interactive picker
claude-with

# Launch with specific provider
claude-with deepseek
claude-with kimi@work

# Pass arguments to claude
claude-with deepseek -- --resume
```

### FZF Key Bindings

| Key      | Action                                   |
| -------- | ---------------------------------------- |
| `Enter`  | Launch claude with selected provider     |
| `Ctrl-K` | Add/update API key for selected provider |
| `Ctrl-T` | Test connectivity for selected provider  |
| `Ctrl-R` | Refresh provider list                    |

### Examples

```bash
# Temporarily use DeepSeek (no config change)
claude-with deepseek

# Use Kimi with work account
claude-with kimi@work

# Use Kimi and resume previous session
claude-with kimi -- --resume

# Interactive provider selection
claude-with
# → Opens FZF picker, launches after selection
```

## claude-provider

Manage default provider configuration and API keys.

### Usage

```bash
# FZF interactive manager
claude-provider

# List all providers
claude-provider list

# Get/set default provider
claude-provider default           # Show current default
claude-provider default kimi@work # Set default

# Manage API keys
claude-provider add-key deepseek@work
claude-provider add-key  # FZF selection

# Test connectivity
claude-provider test
claude-provider test kimi

# List accounts
claude-provider accounts
claude-provider accounts deepseek
```

### FZF Key Bindings

| Key      | Action             |
| -------- | ------------------ |
| `Enter`  | Set as default     |
| `Ctrl-K` | Add/update API key |
| `Ctrl-T` | Test connectivity  |
| `Ctrl-D` | Delete account     |
| `Ctrl-N` | Create new account |

### Examples

```bash
# Interactive management
claude-provider
# → Opens FZF manager for setting default, adding keys, etc.

# Switch default provider
claude-provider default deepseek
# → Updates chezmoi.toml
# → Runs chezmoi apply
# → Prompts to restart Claude Code

# Add new API key
claude-provider add-key kimi@work
# → Prompts for API key
# → Saves to gopass
# → Optionally tests connectivity
```

## claude-token

Internal tool for fetching API tokens. Primarily called by `apiKeyHelper` and other tools.

### Usage

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
claude-provider add-key deepseek@work
claude-provider add-key deepseek@personal

# Use specific account
claude-with deepseek@work
claude-provider default deepseek@personal
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
claude-provider default kimi
```

### New Machine Setup

```bash
# 1. Add API key
claude-provider add-key deepseek

# 2. Test connectivity
claude-provider test deepseek

# 3. Set as default (optional)
claude-provider default deepseek
```

### Multi-Project Switching

```bash
# Project A uses company account
claude-with deepseek@work

# Project B uses personal account
claude-with deepseek@personal
```
