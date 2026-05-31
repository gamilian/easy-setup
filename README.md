# easy-setup

[English](README.md) | [简体中文](README.zh-CN.md)

Personal setup scripts for development environments.

This repository provides small, repeatable installers for setting up a new development machine. The current module is `terminal-setup`, which configures a modern terminal stack for macOS, Debian/Ubuntu, and Windows through WSL.

## Features

- One-command bootstrap from GitHub.
- Local `setup.sh` module dispatcher for reviewed checkouts.
- macOS support through Homebrew.
- Debian/Ubuntu and WSL support through apt, bundled binaries, and selected fallbacks.
- Dry-run mode for previewing mutating commands before applying changes.

## Quick Start

Run the terminal setup directly:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/gamilian/easy-setup/main/install.sh) terminal
```

Choose a shell explicitly:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/gamilian/easy-setup/main/install.sh) terminal --zsh
bash <(curl -fsSL https://raw.githubusercontent.com/gamilian/easy-setup/main/install.sh) terminal --fish
```

Preview the install without making changes:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/gamilian/easy-setup/main/install.sh) terminal --zsh --dry-run
```

If you prefer to inspect the code first:

```bash
git clone https://github.com/gamilian/easy-setup.git
cd easy-setup
./setup.sh terminal --zsh
```

## Modules

| Module | Description | Details |
|--------|-------------|---------|
| `terminal` / `terminal-setup` | Installs and configures Ghostty, Fish or Zsh, Starship, MesloLGS NF, and modern CLI tools. | [terminal-setup/README.md](terminal-setup/README.md) |

## Usage

```bash
./setup.sh                         # interactive module selection
./setup.sh terminal                # run terminal setup interactively
./setup.sh terminal --zsh          # run terminal setup with Zsh
./setup.sh terminal --fish         # run terminal setup with Fish
./setup.sh terminal --dry-run      # preview changes
./install.sh terminal --zsh        # local bootstrap entry point
```

`install.sh` and `setup.sh` use the same module-first argument style. Pass the module name first, then module options.

## Project Layout

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

## Supported Platforms

- macOS: primary target.
- Debian / Ubuntu: supported, but less extensively tested than macOS.
- Windows WSL: supported inside the Linux distribution.
- Native Windows shells such as Git Bash, MSYS, or Cygwin: not supported. Use WSL.

## Verification

There is no build step. The repository uses shell syntax checks and static checks:

```bash
bash -n install.sh setup.sh terminal-setup/terminal-setup.sh
tests/static-config-check.sh
```

`shellcheck` is also useful when available:

```bash
shellcheck install.sh setup.sh terminal-setup/terminal-setup.sh
```

## License

MIT
