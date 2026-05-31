# easy-setup

[English](README.md) | [简体中文](README.zh-CN.md)

个人开发环境配置脚本集合。

这个仓库提供可重复执行的开发环境安装脚本，适合在新机器上快速恢复常用工具。目前主要模块是 `terminal-setup`，用于在 macOS、Debian/Ubuntu 和 Windows WSL 中配置现代终端环境。

## 功能特性

- 支持从 GitHub 一条命令启动安装。
- 支持本地 `setup.sh` 模块分发，便于先审查源码再执行。
- macOS 通过 Homebrew 安装。
- Debian/Ubuntu 和 WSL 通过 apt、内置二进制和少量 fallback 安装。
- 支持 dry-run，执行前预览会修改什么。

## 快速开始

直接运行终端环境安装：

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/gamilian/easy-setup/main/install.sh) terminal
```

明确选择 Shell：

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/gamilian/easy-setup/main/install.sh) terminal --zsh
bash <(curl -fsSL https://raw.githubusercontent.com/gamilian/easy-setup/main/install.sh) terminal --fish
```

只预览，不做修改：

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/gamilian/easy-setup/main/install.sh) terminal --zsh --dry-run
```

如果想先查看源码再运行：

```bash
git clone https://github.com/gamilian/easy-setup.git
cd easy-setup
./setup.sh terminal --zsh
```

## 模块

| 模块 | 说明 | 详细文档 |
|------|------|----------|
| `terminal` / `terminal-setup` | 安装并配置 Ghostty、Fish 或 Zsh、Starship、MesloLGS NF 和现代 CLI 工具。 | [terminal-setup/README.zh-CN.md](terminal-setup/README.zh-CN.md) |

## 用法

```bash
./setup.sh                         # 交互式选择模块
./setup.sh terminal                # 交互式运行终端配置
./setup.sh terminal --zsh          # 使用 Zsh
./setup.sh terminal --fish         # 使用 Fish
./setup.sh terminal --dry-run      # 预览改动
./install.sh terminal --zsh        # 本地 bootstrap 入口
```

`install.sh` 和 `setup.sh` 使用相同的参数风格：先写模块名，再写模块参数。

## 项目结构

```text
.
├── install.sh
├── setup.sh
├── terminal-setup/
│   ├── terminal-setup.sh
│   ├── configs/
│   ├── fonts/
│   ├── bin/
│   └── scripts/
└── tests/
    └── static-config-check.sh
```

## 支持平台

- macOS：主力平台。
- Debian / Ubuntu：支持，但测试覆盖少于 macOS。
- Windows WSL：在 WSL 内部支持。
- Git Bash、MSYS、Cygwin 等原生 Windows shell：不支持，请使用 WSL。

## 验证

仓库没有构建步骤，主要通过 Shell 语法检查和静态检查验证：

```bash
bash -n install.sh setup.sh terminal-setup/terminal-setup.sh
tests/static-config-check.sh
```

如果安装了 `shellcheck`，也建议运行：

```bash
shellcheck install.sh setup.sh terminal-setup/terminal-setup.sh
```

## License

MIT
