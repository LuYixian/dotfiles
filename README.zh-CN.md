<div align="center">

![header](https://capsule-render.vercel.app/api?type=waving&color=0:282a36,100:bd93f9&height=200&section=header&text=~/.dotfiles&fontSize=48&fontColor=f8f8f2&fontAlignY=30&desc=One%20command%20%C2%B7%20Full%20environment%20%C2%B7%20Zero%20hassle&descSize=16&descColor=8be9fd&descAlignY=55&animation=fadeIn)

**chezmoi + Nix · 跨平台开发环境 (macOS / Linux)**

[English](README.md) | [中文](README.zh-CN.md) | [日本語](README.ja.md)

[![CI](https://github.com/LuYixian/dotfiles/actions/workflows/ci.yaml/badge.svg)](https://github.com/LuYixian/dotfiles/actions/workflows/ci.yaml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![macOS](https://img.shields.io/badge/macOS-Sonoma+-000000?logo=apple&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-supported-FCC624?logo=linux&logoColor=black)
[![nix-darwin](https://img.shields.io/badge/nix--darwin-24.11-5277C3)](https://github.com/LnL7/nix-darwin)

![code size](https://img.shields.io/github/languages/code-size/LuYixian/dotfiles)
![repo size](https://img.shields.io/github/repo-size/LuYixian/dotfiles)
[![last commit](https://img.shields.io/github/last-commit/LuYixian/dotfiles)](https://github.com/LuYixian/dotfiles/commits/main)
[![zsh](https://img.shields.io/badge/zsh-5.9+-F15A24?logo=zsh&logoColor=white)](https://www.zsh.org/)
[![chezmoi](https://img.shields.io/github/v/tag/twpayne/chezmoi?color=4B91E2&label=chezmoi&sort=semver)](https://github.com/twpayne/chezmoi)

[![starship](https://img.shields.io/github/v/tag/starship/starship?color=DD0B78&label=starship&logo=starship&logoColor=white&sort=semver)](https://github.com/starship/starship)
[![sheldon](https://img.shields.io/github/v/tag/rossmacarthur/sheldon?color=5C5C5C&label=sheldon&sort=semver)](https://github.com/rossmacarthur/sheldon)
[![mise](https://img.shields.io/github/v/tag/jdx/mise?color=5C4EE5&label=mise&sort=semver)](https://github.com/jdx/mise)
[![atuin](https://img.shields.io/github/v/tag/atuinsh/atuin?color=FF6B6B&label=atuin&sort=semver)](https://github.com/atuinsh/atuin)
[![tmux](https://img.shields.io/github/v/tag/tmux/tmux?color=1BB91F&label=tmux&logo=tmux&logoColor=white&sort=semver)](https://github.com/tmux/tmux)

*基于 Nix 与 chezmoi 的现代、可复现开发环境，同时支持 macOS 与 Linux*
</div>

本仓库提供一套完全声明式的系统配置：能在几分钟内把一台全新的机器引导到可用状态，并自动应用所有软件包、系统设置与 dotfiles。整套方案围绕 Rust 编写的 CLI 工具构建，追求极致性能，并支持多 Profile 配置，便于在工作与个人环境之间无缝切换。

---

## 📑 目录

- [亮点](#highlights)
- [动机](#motivation)
- [快速开始](#quick-start)
- [私密信息与加密](#security)
- [架构](#architecture)
- [工具链](#tool-chains)
- [Shell 函数](#shell-functions)
- [包管理](#package-management)
- [目录结构](#directory-structure)
- [日常操作](#daily-operations)
- [多 Profile 配置](#multi-profile-configuration)
- [键盘快捷键](#keyboard-shortcuts)
- [主题](#theming)
- [统计](#stats)
- [致谢](#acknowledgements)
- [许可证](#license)

---

> [!WARNING]
> **运行前请先阅读！** 本仓库包含会修改系统配置的脚本。
> 在不了解其作用前，不要盲目执行安装/初始化命令。
> 建议先 Fork 本仓库，再按自己的需求进行定制。

---

<a id="highlights"></a>

## ✨ 亮点

- **跨平台**：同一套配置支持 macOS + Linux（`nix-darwin` + `flakey-profile`）
- **自动引导**：首次 apply 会安装 Nix（Determinate）、切换 profile，并在 macOS 上维护 Homebrew
- **私密信息**：使用 `age` 加密（可选 1Password 自动拉取密钥）
- **多 Profile**：`work` / `private` / `headless` 通过 `chezmoi init` 的 prompts 控制
- **效率工具链**：现代 CLI、统一主题、以及 AI 辅助工具

---

<a id="motivation"></a>

## 🎯 动机

搭建一台新的开发机器很繁琐：你需要安装几十个软件包、配置无数工具，并记住这些年积累下来的各种小调整。本仓库通过以下方式解决这个问题：

- **声明式配置** - 所有软件包、设置与配置文件都以代码方式定义
- **可复现** - 一条命令即可在任意机器上获得完全一致的环境
- **跨平台** - 同时支持 macOS 与 Linux，并针对各平台进行优化
- **版本控制** - 持续追踪系统配置的变更历史
- **多 Profile 支持** - 为工作/个人机器提供不同的软件包集合

---

<a id="quick-start"></a>

## 🚀 快速开始

### macOS

#### 一行安装

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply LuYixian
```

#### 手动安装

```bash
# 第 1 步：使用 Determinate Systems 安装器安装 Nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# 第 2 步：安装 chezmoi 并用本仓库初始化
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply LuYixian

# 第 3 步：构建并激活 nix-darwin 配置
cd ~/.local/share/chezmoi
nix run --extra-experimental-features 'nix-command flakes' nixpkgs#just -- darwin
```

### Linux

```bash
# 第 1 步：使用 Determinate Systems 安装器安装 Nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# 第 2 步：安装 chezmoi 并用本仓库初始化
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply LuYixian

# 首次 apply 时会通过 flakey-profile 自动安装软件包
```

安装完成后，重启终端即可享受你的新环境。如果因为加密文件解密失败导致 apply 中断，请参考「[私密信息与加密](#security)」。

---

<a id="security"></a>

## 🔐 私密信息与加密

本仓库使用 `age` 加密管理私密文件（例如 `private_dot_ssh/encrypted_config.age`）。`chezmoi` 会根据 `.chezmoi.toml.tmpl` 使用 `~/.ssh/main`（私钥）和 `~/.ssh/main.pub`（收件人）进行解密。

首次 apply 时，`.chezmoiscripts/run_once_before_01_setup-encryption-key.sh` 会通过 Nix 安装 `age` 与 `op`（1Password CLI），并尝试从 1Password 拉取密钥（桌面集成或 `OP_SERVICE_ACCOUNT_TOKEN`）。如果获取失败会退出并提示手动步骤。

如果你 fork 了本仓库，请按你的环境修改密钥路径和 1Password 条目路径。

---

<a id="architecture"></a>

## 🧩 架构

这套 dotfiles 方案将多款强大的工具组合在一起，实现跨平台配置：

**chezmoi** 用于跨机器管理 dotfiles，支持模板、secret，并确保配置文件始终保持同步。以 `dot_` 前缀命名的文件会生成对应的点文件（dotfile），`.tmpl` 文件会作为 Go 模板处理，支持平台条件判断。

### macOS 配置

**nix-darwin** 提供声明式的 macOS 系统配置：通过 Nix 与 Homebrew（formula/cask）管理系统软件包，并设置 macOS 系统偏好。整个系统状态由 Nix 表达式描述，可原子化地构建与切换。

### Linux 配置

**flakey-profile** 为 Linux 提供声明式的包管理。它使用与 macOS 相同的 Nix flake，但不涉及系统级配置，专注于用户软件包，可在任何 Linux 发行版上使用。

### 协同工作方式

| 组件 | macOS | Linux |
| ---- | ----- | ----- |
| Dotfiles | chezmoi | chezmoi |
| 系统配置 | nix-darwin | N/A |
| 用户软件包 | flakey-profile | flakey-profile |
| GUI 应用 | Homebrew Cask | N/A |
| Mac App Store | mas | N/A |

---

<a id="tool-chains"></a>

## ⚡ 工具链

该配置用现代、Rust 编写的替代品取代传统 Unix 工具：更快、更易用，并提供更合理的默认值。

### 现代 CLI 替代方案

| 传统   | 现代                                              | 说明                                 |
| ------ | ------------------------------------------------- | ------------------------------------ |
| `ls`   | [eza](https://github.com/eza-community/eza)       | git 集成、图标、树形视图             |
| `cat`  | [bat](https://github.com/sharkdp/bat)             | 语法高亮、git 集成                   |
| `grep` | [ripgrep](https://github.com/BurntSushi/ripgrep)  | 极速正则搜索                         |
| `find` | [fd](https://github.com/sharkdp/fd)               | 更直观的语法，遵循 `.gitignore`      |
| `du`   | [dust](https://github.com/bootandy/dust)          | 可视化磁盘占用分析                   |
| `df`   | [duf](https://github.com/muesli/duf)              | 美观的磁盘剩余空间表格               |
| `cd`   | [zoxide](https://github.com/ajeetdsouza/zoxide)   | 智能目录跳转                         |
| `man`  | [tldr](https://github.com/tldr-pages/tlrc)        | 更实用的命令示例                     |
| `time` | [hyperfine](https://github.com/sharkdp/hyperfine) | 命令基准测试                         |

### Shell 环境

Shell 提示符由 **Starship** 驱动：Rust 编写、轻量且快速。使用 Dracula 配色，并展示 git 状态、当前目录与编程语言版本等上下文信息。

**Sheldon** 用于高效管理 zsh 插件。相比 oh-my-zsh 或 zinit，Sheldon 由 Rust 编写，加载速度更快，并支持对非关键插件进行可选的延迟加载。

**Atuin** 彻底升级了 shell 历史：将命令记录存入 SQLite，并支持全局模糊搜索。按下 Ctrl+R，就能立刻找回三个月前那条复杂命令。

**Direnv** 会在进入/离开目录时自动加载/卸载环境变量。配合本仓库提供的辅助函数，可以快速为项目创建 Python virtualenv、Nix flake 开发环境，或 mise 环境。

| 工具                                                                            | 作用                           |
| ------------------------------------------------------------------------------- | ------------------------------ |
| [starship](https://github.com/starship/starship)                                | 极简、飞快的提示符（含 git 信息） |
| [sheldon](https://github.com/rossmacarthur/sheldon)                             | 快速、可配置的 zsh 插件管理器  |
| [atuin](https://github.com/atuinsh/atuin)                                       | 支持模糊搜索的增强命令历史     |
| [direnv](https://github.com/direnv/direnv)                                      | 按目录自动加载环境变量         |
| [fzf](https://github.com/junegunn/fzf)                                          | 文件/历史等模糊查找器          |
| [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)         | Fish 风格命令建议              |
| [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) | 命令语法高亮                   |

### 开发工具

**mise**（前身 rtx）是多语言运行时管理器，可管理 Node.js、Python、Go、Rust、Terraform 等。相比 nvm/pyenv/rbenv 更快，并提供统一的接口。

**lazygit** 提供漂亮的终端 git UI，让交互式 rebase、cherry-pick 与冲突处理等复杂操作更易上手。

**yazi** 是超快的终端文件管理器，支持图片预览，是 ranger 的现代替代品，使用 Rust 编写以追求性能。

本仓库的 **tmux** 配置包含 vim 风格按键、Dracula 主题色，以及用于快速打开 lazygit/htop 的弹窗窗口。前缀键设置为 Ctrl+A，按起来更顺手。

| 工具                                                | 作用                                   |
| --------------------------------------------------- | -------------------------------------- |
| [mise](https://github.com/jdx/mise)                 | 多语言运行时管理器（Node/Python/Go/Rust） |
| [lazygit](https://github.com/jesseduffield/lazygit) | 终端 git UI                            |
| [yazi](https://github.com/sxyazi/yazi)              | 超快的终端文件管理器                   |
| [tmux](https://github.com/tmux/tmux)                | 终端复用器（支持弹窗窗口）             |
| [ghq](https://github.com/x-motemen/ghq)             | 远程仓库管理                           |
| [gh](https://github.com/cli/cli)                    | GitHub CLI（Issue、PR 等）             |

### AI 集成

**Claude Code** 已直接集成到 shell 环境中。`aicommit` 函数可根据已暂存的变更，通过 AI 生成 Conventional Commits 风格的提交信息。Starship 提示符也可选择显示 Claude API 使用统计。

### 桌面应用（仅 macOS）

GUI 应用通过 Homebrew cask 管理：

| 分类     | 应用                              |
| -------- | --------------------------------- |
| 终端     | Ghostty, iTerm2                   |
| 编辑器   | Neovim, VS Code, Cursor           |
| 浏览器   | Arc (Dia)                         |
| 窗口管理 | AeroSpace（i3 风格平铺）           |
| 生产力   | Notion, Obsidian, Logseq, Raycast |
| 容器     | OrbStack（Docker 替代）           |

---

<a id="shell-functions"></a>

## 🔧 Shell 函数

除了 alias，这套配置还提供了一些面向常用工作流的 shell 函数。

如果有不想提交到仓库的本机改动，可以写到 `~/.custom/local.sh`（存在时会被自动 `source`）。

### 项目跳转

`dev` 函数把 **ghq** 与 **fzf** 组合起来做项目管理：输入 `dev` 后，会出现一个可模糊搜索的仓库列表（带目录树预览）；选中后立刻进入项目目录，同时把 tmux 会话重命名为项目名。

```bash
dev                 # FZF 驱动的项目选择器（基于 ghq）
mkcd <dir>          # 创建目录并 cd 进入
dotcd               # 跳转到 chezmoi 源目录
dotfiles            # 用编辑器打开 dotfiles
```

### Git 工作流

`fgc` 提供带日志预览的模糊分支切换；`fgl` 用于浏览提交记录并预览完整 diff；`fga` 列出未暂存文件并支持选择性暂存。这些函数让复杂的 git 操作变得更自然。

```bash
fgc                 # 模糊切换 git 分支（带预览）
fgl                 # 模糊浏览 git log
fga                 # 模糊 git add（选择文件）
aicommit            # 使用 AI 生成提交信息
```

### 系统工具

`fkill` 提供带确认提示的安全进程终止，不用再担心误杀关键进程；`port` 可以快速查看某个端口被哪个进程占用；`backup_dev_env` 用于导出当前 Brewfile、VS Code 扩展与 mise 工具清单，便于备份。

```bash
fkill               # 模糊选择并结束进程（带确认）
fenv                # 模糊查看环境变量
port <num>          # 查看占用端口的进程
backup_dev_env      # 备份开发环境配置
```

### 环境初始化

`create_direnv_venv` 一条命令创建 Python virtualenv 并与 direnv 集成；`create_direnv_nix` 则用于创建 Nix flake 开发环境并接入 direnv。

```bash
create_direnv_venv  # 创建 Python venv + direnv
create_direnv_nix   # 创建 Nix flake + direnv
create_direnv_mise  # 创建 mise 环境 + direnv
create_py_project   # 使用 uv 快速初始化 Python 项目
```

---

<a id="package-management"></a>

## 📦 包管理

软件包来自多个来源，各有所长：

| 来源              | 平台          | 说明                   | 示例                             |
| ----------------- | ------------- | ---------------------- | -------------------------------- |
| Nix packages      | macOS, Linux  | 可复现、可回滚         | ripgrep, bat, eza, starship      |
| Homebrew formulas | 仅 macOS      | macOS 特定工具         | macos-trash, cliclick            |
| Homebrew cask     | 仅 macOS      | GUI 应用               | VS Code, Ghostty, Notion         |
| Mac App Store     | 仅 macOS      | App Store 独占应用     | Magnet, WeChat, Office           |

所有软件包清单都在 `.chezmoidata.yaml` 中定义，并支持 shared / work-only / private-only 的分类管理。

---

<a id="directory-structure"></a>

## 📁 目录结构

```text
~/.local/share/chezmoi/
├── .chezmoidata.yaml           # 各 Profile 的软件包定义
├── .chezmoi.toml.tmpl          # Chezmoi 配置
├── .chezmoiignore              # 平台相关的文件排除规则
├── Justfile.tmpl               # 任务入口（跨平台）
├── .chezmoiscripts/            # 生命周期脚本
│   ├── run_once_before_*.sh    # 首次 apply 前仅运行一次
│   ├── run_onchange_after_*.sh # 指定文件变更时运行
│   └── run_after_*.sh          # 每次 apply 后运行
├── dot_custom/                 # 自定义 shell 配置
│   ├── alias.sh                # 别名（含全局别名）
│   ├── eval.sh                 # 工具初始化
│   ├── exports.sh              # 环境变量
│   ├── functions.sh            # Shell 函数
│   └── utils.sh                # 工具函数库
├── dot_local/bin/              # 自定义脚本（~/.local/bin）
│   ├── battery                 # tmux/终端电量显示
│   └── wifi                    # WiFi 信号强度显示
├── nix-config/                 # Nix 配置
│   ├── flake.nix.tmpl          # Flake 输入与输出（跨平台）
│   └── modules/
│       ├── profile.nix.tmpl    # 用户软件包（flakey-profile）
│       ├── apps.nix.tmpl       # 安装软件包（macOS）
│       ├── system.nix.tmpl     # macOS 系统偏好设置
│       └── host-users.nix      # 用户配置（macOS）
├── private_dot_ssh/            # 加密的 SSH 配置/私密文件
│   └── encrypted_config.age    # 解密后为 ~/.ssh/encrypted_config
└── private_dot_config/         # XDG 配置文件
    ├── atuin/config.toml       # 命令历史设置
    ├── gh-dash/config.yml      # GitHub dashboard TUI
    ├── git/config.tmpl         # Git 配置
    ├── git/ignore              # 全局 gitignore
    ├── ghostty/config          # 终端模拟器
    ├── lazygit/config.yml      # Git TUI 设置
    ├── mise/config.toml        # 运行时管理器
    ├── sheldon/plugins.toml    # Zsh 插件
    ├── starship.toml           # 提示符配置（Dracula 主题）
    ├── tmux/tmux.conf          # 终端复用器
    └── yazi/                   # 文件管理器
```

---

<a id="daily-operations"></a>

## 🔄 日常操作

所有常用操作都通过 Justfile 统一入口（由 `Justfile.tmpl` 渲染到 `~/Justfile`）。若本机还没有 `just`，可用 `nix run --extra-experimental-features 'nix-command flakes' nixpkgs#just -- <task>` 直接运行：

### 跨平台命令

```bash
# Chezmoi 操作
just apply          # 应用 dotfiles 变更
just diff           # 查看待应用的差异
just re-add         # 重新添加被修改的文件

# Nix 操作
just up             # 更新所有 flake 输入
just switch         # 切换 flakey-profile（重建软件包）
just gc             # 清理未使用的 nix store
just optimize       # 优化 nix store（硬链接去重）

# 开发
just check          # 运行 pre-commit 检查

# 一键合集
just full-upgrade   # 完整系统升级
just update-all     # 更新 flake + chezmoi（macOS 还包括 homebrew）
```

### 仅 macOS 命令

```bash
# Nix-darwin 操作
just darwin         # 重建并切换配置
just darwin-debug   # 以详细输出构建

# 维护
just history        # 列出所有系统 profile generation
just clean          # 清理 7 天前的 generation
just clean-all      # nix gc + brew cleanup
```

---

<a id="multi-profile-configuration"></a>

## 👤 多 Profile 配置

该配置支持为不同机器准备不同的方案。在 `.chezmoidata.yaml` 中，软件包分为三类：

- **shared** - 所有机器都安装
- **work** - 仅工作机器安装（Azure CLI、Cursor 等）
- **private** - 仅个人机器安装（1Password、游戏相关等）

`work` 是主要开关：当 `work=false`（默认）时会自动启用 `private=true`。`headless=true` 会跳过 AeroSpace/Karabiner 等 GUI 配置。若提示输入 `hostname`，请填写 `hostname -s` 的输出（会作为 flake 的名字使用）。

```bash
# 工作机器
chezmoi init --apply --promptBool work=true LuYixian

# 个人机器（默认：work=false -> private=true）
chezmoi init --apply LuYixian

# 无头服务器（不需要 GUI 配置）
chezmoi init --apply --promptBool headless=true LuYixian
```

---

<a id="keyboard-shortcuts"></a>

## ⌨️ 键盘快捷键

| 快捷键    | 动作                     |
| --------- | ------------------------ |
| Alt + Up  | 返回上级目录             |
| Alt + Down | 回到上一个目录           |
| Ctrl + R  | 搜索命令历史（Atuin）    |
| Ctrl + A  | tmux 前缀键              |

---

<a id="theming"></a>

## 🌙 主题

所有工具都统一使用 **Dracula** 配色，保证一致且护眼的深色主题体验：

- Starship 提示符配色
- tmux 状态栏
- bat 语法高亮
- lazygit 界面
- yazi 文件管理器

---

<a id="stats"></a>

## 📈 统计

![Repobeats](https://repobeats.axiom.co/api/embed/b47788b120b4e3a0f049b72115d88268d5523f64.svg "Repobeats analytics")

---

<a id="acknowledgements"></a>

## 🙏 致谢

这套 dotfiles 站在巨人的肩膀上。特别感谢：

- [chezmoi](https://github.com/twpayne/chezmoi) by [@twpayne](https://github.com/twpayne) - 强大的 dotfiles 管理器
- [nix-darwin](https://github.com/LnL7/nix-darwin) by [@LnL7](https://github.com/LnL7) - 基于 Nix 的声明式 macOS 配置
- [flakey-profile](https://github.com/lf-/flakey-profile) by [@lf-](https://github.com/lf-) - 跨平台 Nix profile 管理
- [Nix](https://nixos.org/) by [NixOS](https://github.com/NixOS) - 纯函数式包管理器
- [Determinate Nix Installer](https://github.com/DeterminateSystems/nix-installer) by [@DeterminateSystems](https://github.com/DeterminateSystems)
- [Sheldon](https://github.com/rossmacarthur/sheldon) by [@rossmacarthur](https://github.com/rossmacarthur) - 快速的 zsh 插件管理器
- [Dracula Theme](https://draculatheme.com/) by [@zenorocha](https://github.com/zenorocha) - 漂亮的深色主题

以及其他所有让这套配置成为可能的开源项目与贡献者。

---

<a id="license"></a>

## 📝 许可证

本项目基于 MIT License 发布。
