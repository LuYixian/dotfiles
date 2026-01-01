<div align="center">

![header](https://capsule-render.vercel.app/api?type=waving&color=0:282a36,100:bd93f9&height=200&section=header&text=~/.dotfiles&fontSize=48&fontColor=f8f8f2&fontAlignY=30&desc=One%20command%20%C2%B7%20Full%20environment%20%C2%B7%20Zero%20hassle&descSize=16&descColor=8be9fd&descAlignY=55&animation=fadeIn)

**chezmoi + Nix · Cross-platform dev environment**

[English](README.md) | [中文](README.zh-CN.md) | [日本語](README.ja.md)

[![CI](https://github.com/signalridge/dotfiles/actions/workflows/ci.yaml/badge.svg)](https://github.com/signalridge/dotfiles/actions/workflows/ci.yaml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![macOS](https://img.shields.io/badge/macOS-Sonoma+-000000?logo=apple&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-supported-FCC624?logo=linux&logoColor=black)
[![nix-darwin](https://img.shields.io/badge/nix--darwin-24.11-5277C3)](https://github.com/LnL7/nix-darwin)

![code size](https://img.shields.io/github/languages/code-size/signalridge/dotfiles)
![repo size](https://img.shields.io/github/repo-size/signalridge/dotfiles)
[![last commit](https://img.shields.io/github/last-commit/signalridge/dotfiles)](https://github.com/signalridge/dotfiles/commits/main)
[![zsh](https://img.shields.io/badge/zsh-5.9+-F15A24?logo=zsh&logoColor=white)](https://www.zsh.org/)
[![chezmoi](https://img.shields.io/github/v/tag/twpayne/chezmoi?color=4B91E2&label=chezmoi&sort=semver)](https://github.com/twpayne/chezmoi)

[![starship](https://img.shields.io/github/v/tag/starship/starship?color=DD0B78&label=starship&logo=starship&logoColor=white&sort=semver)](https://github.com/starship/starship)
[![sheldon](https://img.shields.io/github/v/tag/rossmacarthur/sheldon?color=5C5C5C&label=sheldon&sort=semver)](https://github.com/rossmacarthur/sheldon)
[![mise](https://img.shields.io/github/v/tag/jdx/mise?color=5C4EE5&label=mise&sort=semver)](https://github.com/jdx/mise)
[![atuin](https://img.shields.io/github/v/tag/atuinsh/atuin?color=FF6B6B&label=atuin&sort=semver)](https://github.com/atuinsh/atuin)
[![tmux](https://img.shields.io/github/v/tag/tmux/tmux?color=1BB91F&label=tmux&logo=tmux&logoColor=white&sort=semver)](https://github.com/tmux/tmux)

*A modern, reproducible development environment for macOS and Linux*
</div>

This repository provides a fully declarative system configuration that can bootstrap a new machine in minutes, with all packages, settings, and dotfiles automatically applied. The entire setup is built around Rust-based CLI tools for blazing-fast performance, and supports multi-profile configurations to seamlessly switch between work and personal environments.

---

## 📑 Table of Contents

- [📑 Table of Contents](#-table-of-contents)
- [🎯 Motivation](#-motivation)
- [🚀 Quick Start](#-quick-start)
  - [macOS](#macos)
    - [One-Line Installation](#one-line-installation)
    - [Manual Installation](#manual-installation)
  - [Linux](#linux)
- [🧩 Architecture](#-architecture)
  - [macOS Configuration](#macos-configuration)
  - [Linux Configuration](#linux-configuration)
  - [How They Work Together](#how-they-work-together)
- [⚡ Tool Chains](#-tool-chains)
  - [Modern CLI Replacements](#modern-cli-replacements)
  - [Shell Environment](#shell-environment)
  - [Development Tools](#development-tools)
  - [AI Integration](#ai-integration)
  - [Desktop Applications (macOS only)](#desktop-applications-macos-only)
- [🔧 Shell Functions](#-shell-functions)
  - [Project Navigation](#project-navigation)
  - [Git Workflow](#git-workflow)
  - [System Utilities](#system-utilities)
  - [Environment Setup](#environment-setup)
- [📦 Package Management](#-package-management)
- [📁 Directory Structure](#-directory-structure)
- [🔄 Daily Operations](#-daily-operations)
  - [Cross-Platform Commands](#cross-platform-commands)
  - [macOS-Only Commands](#macos-only-commands)
- [👤 Multi-Profile Configuration](#-multi-profile-configuration)
- [⌨️ Keyboard Shortcuts](#️-keyboard-shortcuts)
- [🌙 Theming](#-theming)
- [📈 Stats](#-stats)
- [🙏 Acknowledgements](#-acknowledgements)
- [📝 License](#-license)

---

> [!WARNING]
> **Review before running!** This repository contains scripts that will modify your system configuration.
> Do not blindly execute setup commands without understanding what they do.
> Fork this repository and customize it for your own needs.

---

<a id="motivation"></a>

## 🎯 Motivation

Setting up a new development machine is tedious. You need to install dozens of packages, configure countless tools, and remember all those little tweaks you made over the years. This repository solves that problem by:

- **Declarative Configuration** - Every package, setting, and configuration file is defined in code
- **Reproducibility** - Run one command and get the exact same environment on any machine
- **Cross-Platform** - Works on both macOS and Linux with platform-specific optimizations
- **Version Control** - Track changes to your system configuration over time
- **Multi-Profile Support** - Different package sets for work vs personal machines

---

<a id="quick-start"></a>

## 🚀 Quick Start

### macOS

#### One-Line Installation

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply signalridge
```

#### Manual Installation

```bash
# Step 1: Install Nix using Determinate Systems installer
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Step 2: Install chezmoi and initialize with this repo
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply signalridge

# Step 3: Build and activate nix-darwin configuration
cd ~/.local/share/chezmoi
nix run --extra-experimental-features 'nix-command flakes' nixpkgs#just -- darwin
```

### Linux

```bash
# Step 1: Install Nix using Determinate Systems installer
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Step 2: Install chezmoi and initialize with this repo
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply signalridge

# Packages are automatically installed via flakey-profile on first apply
```

After installation, restart your terminal to enjoy your new environment.

---

<a id="architecture"></a>

## 🧩 Architecture

This dotfiles setup combines powerful tools for cross-platform configuration:

**chezmoi** manages dotfiles across machines. It handles templating, secrets, and ensures your configuration files are always in sync. Files prefixed with `dot_` become dotfiles, and `.tmpl` files are processed as Go templates with platform-specific conditionals.

### macOS Configuration

**nix-darwin** provides declarative macOS system configuration. It manages system packages through Nix, Homebrew formulas and casks, and macOS system preferences. The entire system state is defined in Nix expressions and can be rebuilt atomically.

### Linux Configuration

**flakey-profile** provides declarative package management for Linux. It uses the same Nix flake as macOS but without system-level configuration, focusing on user packages that work across any Linux distribution.

### How They Work Together

| Component | macOS | Linux |
|-----------|-------|-------|
| Dotfiles | chezmoi | chezmoi |
| System Config | nix-darwin | N/A |
| User Packages | flakey-profile | flakey-profile |
| GUI Apps | Homebrew Cask | N/A |
| Mac App Store | mas | N/A |

---

<a id="tool-chains"></a>

## ⚡ Tool Chains

This setup replaces traditional Unix tools with modern, Rust-based alternatives that are faster, more user-friendly, and provide better defaults.

### Modern CLI Replacements

| Classic | Modern                                            | Description                           |
| ------- | ------------------------------------------------- | ------------------------------------- |
| `ls`    | [eza](https://github.com/eza-community/eza)       | Git integration, icons, tree views    |
| `cat`   | [bat](https://github.com/sharkdp/bat)             | Syntax highlighting, git integration  |
| `grep`  | [ripgrep](https://github.com/BurntSushi/ripgrep)  | Lightning-fast regex search           |
| `find`  | [fd](https://github.com/sharkdp/fd)               | Intuitive syntax, respects .gitignore |
| `du`    | [dust](https://github.com/bootandy/dust)          | Visual disk usage analyzer            |
| `df`    | [duf](https://github.com/muesli/duf)              | Beautiful disk free table             |
| `cd`    | [zoxide](https://github.com/ajeetdsouza/zoxide)   | Smart directory jumping               |
| `man`   | [tldr](https://github.com/tldr-pages/tlrc)        | Practical command examples            |
| `time`  | [hyperfine](https://github.com/sharkdp/hyperfine) | Command benchmarking                  |

### Shell Environment

The shell prompt is powered by **Starship**, a minimal and fast prompt written in Rust. It's configured with the Dracula color palette and shows contextual information like git status, current directory, and programming language versions.

**Sheldon** manages zsh plugins efficiently. Unlike oh-my-zsh or zinit, Sheldon is written in Rust and provides fast plugin loading with optional deferred execution for non-critical plugins.

**Atuin** revolutionizes shell history. It stores your command history in a SQLite database and provides fuzzy search across your entire history. Press Ctrl+R and instantly find that complex command you ran three months ago.

**Direnv** automatically loads and unloads environment variables when you enter and leave directories. Combined with the helper functions in this repo, you can quickly set up per-project Python virtualenvs, Nix development shells, or mise environments.

| Tool                                                                            | Role                                              |
| ------------------------------------------------------------------------------- | ------------------------------------------------- |
| [starship](https://github.com/starship/starship)                                | Minimal, blazing-fast prompt with git integration |
| [sheldon](https://github.com/rossmacarthur/sheldon)                             | Fast, configurable zsh plugin manager             |
| [atuin](https://github.com/atuinsh/atuin)                                       | Magical shell history with fuzzy search           |
| [direnv](https://github.com/direnv/direnv)                                      | Per-directory environment variables               |
| [fzf](https://github.com/junegunn/fzf)                                          | Fuzzy finder for files, history, and more         |
| [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)         | Fish-like command suggestions                     |
| [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) | Syntax highlighting for commands                  |

### Development Tools

**mise** (formerly rtx) is a polyglot runtime manager that handles Node.js, Python, Go, Rust, Terraform, and more. It's faster than nvm/pyenv/rbenv and provides a unified interface for all language runtimes.

**lazygit** provides a beautiful terminal UI for git. It makes complex git operations like interactive rebasing, cherry-picking, and conflict resolution much more accessible.

**yazi** is a blazing-fast terminal file manager with image preview support. It's the modern replacement for ranger, written in Rust for maximum performance.

**tmux** configuration includes vim-style keybindings, Dracula theme colors, and popup windows for quick access to lazygit and htop. The prefix key is set to Ctrl+A for easier access.

| Tool                                                | Role                                              |
| --------------------------------------------------- | ------------------------------------------------- |
| [mise](https://github.com/jdx/mise)                 | Polyglot runtime manager (Node, Python, Go, Rust) |
| [lazygit](https://github.com/jesseduffield/lazygit) | Beautiful terminal UI for git                     |
| [yazi](https://github.com/sxyazi/yazi)              | Blazing fast terminal file manager                |
| [tmux](https://github.com/tmux/tmux)                | Terminal multiplexer with popup windows           |
| [ghq](https://github.com/x-motemen/ghq)             | Remote repository management                      |
| [gh](https://github.com/cli/cli)                    | GitHub CLI for issues, PRs, and more              |

### AI Integration

**Claude Code** is integrated directly into the shell environment. The `aicommit` function generates conventional commit messages from staged changes using AI. The Starship prompt can optionally display Claude API usage stats.

### Desktop Applications (macOS only)

GUI applications are managed through Homebrew casks:

| Category       | Applications                      |
| -------------- | --------------------------------- |
| Terminal       | Ghostty, iTerm2                   |
| Editor         | Neovim, VS Code, Cursor           |
| Browser        | Arc (Dia)                         |
| Window Manager | AeroSpace (i3-like tiling)        |
| Productivity   | Notion, Obsidian, Logseq, Raycast |
| Container      | OrbStack (Docker alternative)     |

---

<a id="shell-functions"></a>

## 🔧 Shell Functions

Beyond aliases, this setup provides powerful shell functions for common workflows.

For machine-specific tweaks you don't want to commit, put them in `~/.custom/local.sh` (it will be sourced automatically if present).

### Project Navigation

The `dev` function combines **ghq** and **fzf** for project management. Type `dev`, and you get a fuzzy-searchable list of all your git repositories with a tree preview. Select one and you're instantly there, with tmux session renamed to match.

```bash
dev                 # FZF-powered project selector (with ghq)
mkcd <dir>          # Create directory and cd into it
dotcd               # Jump to chezmoi source
dotfiles            # Open dotfiles in editor
```

### Git Workflow

`fgc` provides fuzzy branch checkout with log preview. `fgl` lets you browse commits with full diff preview. `fga` shows unstaged files and lets you selectively stage them. These functions make complex git operations feel natural.

```bash
fgc                 # Fuzzy git checkout (branches)
fgl                 # Fuzzy git log viewer
fga                 # Fuzzy git add (select files)
aicommit            # Generate commit message with AI
```

### System Utilities

`fkill` provides safe process killing with confirmation prompts - no more accidentally killing critical processes. `port` quickly shows what's using a specific network port. `backup_dev_env` exports your current Brewfile, VS Code extensions, and mise tools for backup.

```bash
fkill               # Fuzzy process killer (with confirmation)
fenv                # Fuzzy environment variable viewer
port <num>          # Show process using port
backup_dev_env      # Backup dev environment configs
```

### Environment Setup

`create_direnv_venv` sets up a Python virtualenv with direnv integration in one command. `create_direnv_nix` does the same for Nix flake development environments.

```bash
create_direnv_venv  # Create Python venv with direnv
create_direnv_nix   # Create Nix flake with direnv
create_direnv_mise  # Create mise environment with direnv
create_py_project   # Quick Python project setup with uv
```

---

<a id="package-management"></a>

## 📦 Package Management

Packages are managed through multiple sources, each with its strengths:

| Source            | Platform      | Description                 | Examples                    |
| ----------------- | ------------- | --------------------------- | --------------------------- |
| Nix packages      | macOS, Linux  | Reproducible, rollback-able | ripgrep, bat, eza, starship |
| Homebrew formulas | macOS only    | macOS-specific tools        | macos-trash, cliclick       |
| Homebrew casks    | macOS only    | GUI applications            | VS Code, Ghostty, Notion    |
| Mac App Store     | macOS only    | App Store exclusives        | Magnet, WeChat, Office      |

All package lists are defined in `.chezmoidata.yaml` with support for shared, work-only, and private-only packages.

---

<a id="directory-structure"></a>

## 📁 Directory Structure

```text
~/.local/share/chezmoi/
├── .chezmoidata.yaml           # Package definitions for all profiles
├── .chezmoi.toml.tmpl          # Chezmoi configuration
├── .chezmoiignore              # Platform-specific file exclusions
├── Justfile.tmpl               # Task runner (cross-platform)
├── .chezmoiscripts/            # Lifecycle scripts
│   ├── run_once_before_*.sh    # Run once before first apply
│   ├── run_onchange_after_*.sh # Run when specific files change
│   └── run_after_*.sh          # Run after every apply
├── dot_custom/                 # Custom shell configuration
│   ├── alias.sh                # Aliases (including global aliases)
│   ├── eval.sh                 # Tool initialization
│   ├── exports.sh              # Environment variables
│   ├── functions.sh            # Shell functions
│   └── utils.sh                # Utility functions library
├── dot_local/bin/              # Custom scripts (~/.local/bin)
│   ├── battery                 # Battery status for tmux/terminal
│   └── wifi                    # WiFi signal strength display
├── nix-config/                 # Nix configuration
│   ├── flake.nix.tmpl          # Flake inputs and outputs (cross-platform)
│   └── modules/
│       ├── profile.nix.tmpl    # User packages (flakey-profile)
│       ├── apps.nix.tmpl       # Package installation (macOS)
│       ├── system.nix.tmpl     # macOS system preferences
│       └── host-users.nix      # User configuration (macOS)
└── private_dot_config/         # XDG config files
    ├── atuin/config.toml       # Shell history settings
    ├── gh-dash/config.yml      # GitHub dashboard TUI
    ├── git/config.tmpl         # Git configuration
    ├── git/ignore              # Global gitignore
    ├── ghostty/config          # Terminal emulator
    ├── lazygit/config.yml      # Git TUI settings
    ├── mise/config.toml        # Runtime manager
    ├── sheldon/plugins.toml    # Zsh plugins
    ├── starship.toml           # Prompt configuration (Dracula theme)
    ├── tmux/tmux.conf          # Terminal multiplexer
    └── yazi/                   # File manager
```

---

<a id="daily-operations"></a>

## 🔄 Daily Operations

All common operations are available through the Justfile (rendered from `Justfile.tmpl` to `~/Justfile`). If you don't have `just` yet, run `nix run --extra-experimental-features 'nix-command flakes' nixpkgs#just -- <task>`:

### Cross-Platform Commands

```bash
# Chezmoi operations
just apply          # Apply dotfile changes
just diff           # Show pending changes
just re-add         # Re-add modified files

# Nix operations
just up             # Update all flake inputs
just switch         # Switch flakey-profile (rebuild packages)
just gc             # Garbage collect unused nix store entries
just optimize       # Optimize nix store (hard-link duplicates)

# Development
just check          # Run pre-commit checks

# All-in-one
just full-upgrade   # Complete system upgrade
just update-all     # Update flake + chezmoi (+ homebrew on macOS)
```

### macOS-Only Commands

```bash
# Nix-darwin operations
just darwin         # Rebuild and switch configuration
just darwin-debug   # Build with verbose output

# Maintenance
just history        # List all generations of the system profile
just clean          # Clean generations older than 7 days
just clean-all      # Nix gc + brew cleanup
```

---

<a id="multi-profile-configuration"></a>

## 👤 Multi-Profile Configuration

The setup supports different configurations for different machines. In `.chezmoidata.yaml`, packages are organized into three categories:

- **shared** - Installed on all machines
- **work** - Only installed on work machines (Azure CLI, Cursor, etc.)
- **private** - Only installed on personal machines (1Password, gaming, etc.)

`work` is the primary switch: `private` is enabled automatically when `work=false` (default). `headless=true` skips GUI configs like AeroSpace/Karabiner. If prompted for `hostname`, use `hostname -s` (used as the flake output name).

```bash
# For work machines
chezmoi init --apply --promptBool work=true signalridge

# For personal machines (default: work=false -> private=true)
chezmoi init --apply signalridge

# For headless servers (no GUI configs)
chezmoi init --apply --promptBool headless=true signalridge
```

---

<a id="keyboard-shortcuts"></a>

## ⌨️ Keyboard Shortcuts

| Shortcut   | Action                         |
| ---------- | ------------------------------ |
| Alt + Up   | Navigate to parent directory   |
| Alt + Down | Navigate to previous directory |
| Ctrl + R   | Search command history (Atuin) |
| Ctrl + A   | tmux prefix key                |

---

<a id="theming"></a>

## 🌙 Theming

All tools are configured with the **Dracula** color palette for a consistent, eye-friendly dark theme:

- Starship prompt colors
- tmux status bar
- bat syntax highlighting
- lazygit interface
- yazi file manager

---

<a id="stats"></a>

## 📈 Stats

![Repobeats](https://repobeats.axiom.co/api/embed/b47788b120b4e3a0f049b72115d88268d5523f64.svg "Repobeats analytics")

---

<a id="acknowledgements"></a>

## 🙏 Acknowledgements

This dotfiles setup is built on the shoulders of giants. Special thanks to:

- [chezmoi](https://github.com/twpayne/chezmoi) by [@twpayne](https://github.com/twpayne) - The powerful dotfiles manager
- [nix-darwin](https://github.com/LnL7/nix-darwin) by [@LnL7](https://github.com/LnL7) - Declarative macOS configuration with Nix
- [flakey-profile](https://github.com/lf-/flakey-profile) by [@lf-](https://github.com/lf-) - Cross-platform Nix profile management
- [Nix](https://nixos.org/) by [NixOS](https://github.com/NixOS) - The purely functional package manager
- [Determinate Nix Installer](https://github.com/DeterminateSystems/nix-installer) by [@DeterminateSystems](https://github.com/DeterminateSystems)
- [Sheldon](https://github.com/rossmacarthur/sheldon) by [@rossmacarthur](https://github.com/rossmacarthur) - Fast zsh plugin manager
- [Dracula Theme](https://draculatheme.com/) by [@zenorocha](https://github.com/zenorocha) - The beautiful dark theme

And all the other amazing open-source projects and their contributors that make this setup possible.

---

<a id="license"></a>

## 📝 License

This project is licensed under the MIT License.
