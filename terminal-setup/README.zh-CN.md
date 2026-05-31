# terminal-setup

[English](README.md) | [简体中文](README.zh-CN.md)

适用于 macOS、Debian/Ubuntu 和 Windows WSL 的终端环境一键配置脚本。

它会安装现代终端工具栈，部署仓库内维护的配置文件，并在覆盖已有配置前自动创建带时间戳的备份。

## 功能特性

- 支持选择 Fish 或 Zsh。
- 安装 Starship，并部署仓库内置的 Catppuccin Mocha 配置。
- 使用仓库内置文件安装 MesloLGS NF 字体。
- macOS 自动安装 Ghostty，并在适用平台部署 Ghostty 配置。
- 安装现代 CLI 工具：`bat`、`eza`、`fd`、`ripgrep`、`fzf`、`btop`、`zoxide`、`jq`、`tldr`、`delta`、`lazygit`。
- 可选安装 `fnm` 和 Node.js LTS。
- 可选安装 Zellij。
- 支持 dry-run，先预览会执行的修改。

## 支持平台

| 平台 | 状态 | 说明 |
|------|------|------|
| macOS | 主力平台 | 使用 Homebrew，Ghostty 会作为原生应用安装。 |
| Debian / Ubuntu | 支持 | 使用 apt、内置 Linux 二进制和少量 fallback。 |
| Windows WSL | 支持 | 在 WSL 内运行脚本，Windows 侧终端需要单独设置字体。 |
| 原生 Windows | 不支持 | 请使用 WSL。 |

## 快速开始

一键运行：

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/gamilian/easy-setup/main/install.sh) terminal
```

选择 Zsh 或 Fish：

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/gamilian/easy-setup/main/install.sh) terminal --zsh
bash <(curl -fsSL https://raw.githubusercontent.com/gamilian/easy-setup/main/install.sh) terminal --fish
```

只预览，不修改系统：

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/gamilian/easy-setup/main/install.sh) terminal --zsh --dry-run
```

手动 clone 后运行：

```bash
git clone https://github.com/gamilian/easy-setup.git
cd easy-setup
./setup.sh terminal --zsh
```

WSL 用户先在管理员 PowerShell 中安装 WSL：

```powershell
wsl --install
```

然后进入 WSL 发行版内部运行安装命令。

## 参数

| 命令 | 说明 |
|------|------|
| `./setup.sh terminal` | 交互式运行终端配置。 |
| `./setup.sh terminal --zsh` | 使用 Zsh，并安装类 Fish 体验插件。 |
| `./setup.sh terminal --fish` | 使用 Fish。 |
| `./setup.sh terminal --dry-run` | 只打印会修改系统的命令，不实际执行。 |
| `./install.sh terminal --zsh` | 使用本地 bootstrap 入口。 |
| `./terminal-setup/terminal-setup.sh --zsh` | 在本地 checkout 中直接运行模块脚本。 |

## 安装内容

| 组件 | 用途 |
|------|------|
| Ghostty | 终端模拟器。macOS 会自动安装；Linux 和 WSL 用户需自行配置终端应用。 |
| Fish 或 Zsh | 用户选择的 Shell。Zsh 会安装 autosuggestions 和 syntax highlighting。 |
| Starship | 跨 Shell prompt，使用仓库内置 Catppuccin Mocha 配置。 |
| MesloLGS NF | Nerd Font，用于显示图标和 Powerline 字符。 |
| CLI 工具 | `bat`、`eza`、`fd`、`ripgrep`、`fzf`、`btop`、`zoxide`、`jq`、`tldr`、`delta`、`lazygit`。 |
| fnm | 可选 Node.js 版本管理器，并可安装 Node.js LTS。 |
| Zellij | 可选终端复用器。 |

## Linux 安装逻辑

在 Debian、Ubuntu 和 WSL 中，脚本会优先使用 apt。对于 Ubuntu，脚本会确保启用 `universe` 仓库后再重试 `btop`、`zoxide` 等包，因为有些镜像默认只启用 `main` 组件。

当 apt 没有提供某些工具时，脚本会优先使用仓库内置的 `linux-x86_64` 二进制。`zoxide` 可以回退到内置 installer。`btop` 只通过 apt 安装，如果当前源仍然没有，会给出明确警告并跳过。

如果 `btop` 或 `zoxide` 仍然无法通过 apt 安装，先确认镜像源完整并已同步，然后运行：

```bash
sudo apt-get update
```

Ubuntu 用户也可以手动确认 `universe` 已启用：

```bash
sudo apt-add-repository universe
sudo apt-get update
```

## 安装后字体设置

脚本会安装 MesloLGS NF，但终端应用本身还需要切换到这个字体。请把终端字体设置为 `MesloLGS NF`，否则图标和 Powerline 字符可能乱码。

- VS Code / Cursor：把 `terminal.integrated.fontFamily` 设置为 `MesloLGS NF`。
- iTerm2：Profiles > Text > Font > `MesloLGS NF`。
- Ghostty：设置 `font-family = MesloLGS NF`。
- Windows Terminal：Profile > Appearance > Font face > `MesloLGS NF`。

如果改完后图标仍不正常，重启对应终端应用。

## Shell 选择

| | Fish | Zsh |
|---|------|-----|
| POSIX 兼容 | 不兼容，Fish 有自己的语法。 | 日常交互中基本兼容 POSIX 风格命令。 |
| 自动建议 | 内置。 | 通过插件安装。 |
| 语法高亮 | 内置。 | 通过插件安装。 |
| Node 管理 | fnm | fnm |
| 配置路径 | `~/.config/fish/config.fish` | `~/.zshrc` |
| 更适合 | 想要更干净交互体验的用户。 | 经常运行 POSIX 风格命令片段的用户。 |

## 部署的配置文件

覆盖已有文件前，脚本会先创建备份。

| 配置 | 目标路径 |
|------|----------|
| Starship | `~/.config/starship.toml` |
| Fish | `~/.config/fish/config.fish` |
| Zsh | `~/.zshrc` |
| macOS Ghostty | `~/Library/Application Support/com.mitchellh.ghostty/config.ghostty` |
| Linux / WSL Ghostty | `~/.config/ghostty/config` |

## 内置 Shell 辅助功能

- 为 `ls`、`ll`、`lt`、`cat`、`find`、`grep`、`top`、`lg` 提供现代工具别名或缩写。
- fzf 历史、文件、目录搜索快捷键。
- zoxide 智能目录跳转。
- `set-ssh-key`：快速把指定 SSH key 加载到 agent。

## 排障

### 图标或 prompt 字符显示异常

安装已经完成，但终端应用可能还没有使用 `MesloLGS NF`。参考 [安装后字体设置](#安装后字体设置)。

### `btop` 或 `zoxide` 无法通过 apt 安装

脚本会在 Ubuntu 中启用 `universe` 后重试。如果仍失败，通常是 apt 镜像未同步、组件不完整，或系统源配置不完整。请切换到完整同步的镜像源，然后运行 `sudo apt-get update`。

### 原生 Windows shell 被拒绝

请在 WSL 内运行安装器。Git Bash、MSYS、Cygwin 等原生 Windows 环境不受支持。

## License

MIT
