# terminal-setup

[English](README.md) | [简体中文](README.zh-CN.md)

One-script terminal environment setup for macOS, Debian/Ubuntu, and Windows WSL.

It installs a modern terminal stack, deploys versioned configuration files, and keeps existing user config files by backing them up with timestamps.

## Features

- Fish or Zsh shell setup.
- Starship prompt with the bundled Catppuccin Mocha configuration.
- MesloLGS NF font installation from files bundled in this repository.
- Ghostty installation on macOS and Ghostty config deployment where applicable.
- Modern CLI tools: `bat`, `eza`, `fd`, `ripgrep`, `fzf`, `btop`, `zoxide`, `jq`, `tldr`, `delta`, and `lazygit`.
- Optional `fnm` + Node.js LTS setup.
- Optional Zellij installation.
- Dry-run mode for previewing mutating commands.

## Supported Platforms

| Platform | Status | Notes |
|----------|--------|-------|
| macOS | Primary | Uses Homebrew. Ghostty is installed as a native app. |
| Debian / Ubuntu | Supported | Uses apt, bundled Linux binaries, and selected fallbacks. |
| Windows WSL | Supported | Run the script inside WSL. Configure the terminal app on Windows. |
| Native Windows | Not supported | Use WSL instead. |

## Quick Start

One-command install:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/gamilian/easy-setup/main/install.sh) terminal
```

Choose Zsh or Fish:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/gamilian/easy-setup/main/install.sh) terminal --zsh
bash <(curl -fsSL https://raw.githubusercontent.com/gamilian/easy-setup/main/install.sh) terminal --fish
```

Preview without applying changes:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/gamilian/easy-setup/main/install.sh) terminal --zsh --dry-run
```

Manual checkout:

```bash
git clone https://github.com/gamilian/easy-setup.git
cd easy-setup
./setup.sh terminal --zsh
```

For WSL, install WSL first from an elevated PowerShell:

```powershell
wsl --install
```

Then run the command inside the WSL distribution.

## Options

| Command | Description |
|---------|-------------|
| `./setup.sh terminal` | Run terminal setup interactively. |
| `./setup.sh terminal --zsh` | Use Zsh with fish-like plugins. |
| `./setup.sh terminal --fish` | Use Fish. |
| `./setup.sh terminal --dry-run` | Print mutating commands without executing them. |
| `./install.sh terminal --zsh` | Use the local bootstrap entry point. |
| `./terminal-setup/terminal-setup.sh --zsh` | Run this module directly from a checkout. |

## What It Installs

| Component | Purpose |
|-----------|---------|
| Ghostty | Terminal emulator. Installed automatically on macOS. Linux and WSL users configure their terminal separately. |
| Fish or Zsh | User-selected shell. Zsh includes autosuggestions and syntax highlighting. |
| Starship | Cross-shell prompt using the bundled Catppuccin Mocha config. |
| MesloLGS NF | Nerd Font used for icons and Powerline glyphs. |
| CLI tools | `bat`, `eza`, `fd`, `ripgrep`, `fzf`, `btop`, `zoxide`, `jq`, `tldr`, `delta`, `lazygit`. |
| fnm | Optional Node.js version manager and Node.js LTS installer. |
| Zellij | Optional terminal multiplexer. |

## How Linux Installs Work

On Debian, Ubuntu, and WSL, the script uses apt first. For Ubuntu, it ensures the `universe` repository is enabled before retrying packages such as `btop` and `zoxide`, because some mirrors expose only the `main` component by default.

When apt does not provide a tool, the script uses the repository's bundled `linux-x86_64` binaries where available. `zoxide` can fall back to the vendored installer. `btop` is apt-only and is skipped with a clear warning if the configured sources still do not provide it.

If `btop` or `zoxide` cannot be installed through apt, check that your mirror is fully synced and run:

```bash
sudo apt-get update
```

On Ubuntu, also confirm `universe` is enabled:

```bash
sudo apt-add-repository universe
sudo apt-get update
```

## Post-install Font Setup

The script installs MesloLGS NF, but terminal applications still need to use it. Set your terminal font to `MesloLGS NF` to avoid broken icons or garbled Powerline glyphs.

- VS Code / Cursor: set `terminal.integrated.fontFamily` to `MesloLGS NF`.
- iTerm2: Profiles > Text > Font > `MesloLGS NF`.
- Ghostty: set `font-family = MesloLGS NF`.
- Windows Terminal: Profile > Appearance > Font face > `MesloLGS NF`.

Restart the terminal app after changing the font if icons still look wrong.

## Shell Choice

| | Fish | Zsh |
|---|------|-----|
| POSIX compatibility | No, Fish has its own syntax. | Mostly compatible for day-to-day shell usage. |
| Autosuggestions | Built in. | Installed through plugin. |
| Syntax highlighting | Built in. | Installed through plugin. |
| Node manager | fnm | fnm |
| Config path | `~/.config/fish/config.fish` | `~/.zshrc` |
| Recommended for | Users who want the cleanest interactive shell. | Users who often run POSIX-style shell snippets. |

## Deployed Config Files

Existing files are backed up before replacement.

| Config | Destination |
|--------|-------------|
| Starship | `~/.config/starship.toml` |
| Fish | `~/.config/fish/config.fish` |
| Zsh | `~/.zshrc` |
| Ghostty on macOS | `~/Library/Application Support/com.mitchellh.ghostty/config.ghostty` |
| Ghostty on Linux / WSL | `~/.config/ghostty/config` |

## Included Shell Helpers

- Modern command aliases or abbreviations for `ls`, `ll`, `lt`, `cat`, `find`, `grep`, `top`, and `lg`.
- fzf bindings for history, file, and directory search.
- zoxide smart directory jumping.
- `set-ssh-key` helper for loading a selected SSH key into the agent.

## Troubleshooting

### Icons or prompt glyphs look broken

Install completed, but your terminal app is probably not using `MesloLGS NF`. See [Post-install Font Setup](#post-install-font-setup).

### `btop` or `zoxide` is not available through apt

The script retries after enabling Ubuntu `universe`. If it still fails, your apt mirror may be stale, incomplete, or missing repository components. Switch to a fully synced mirror and run `sudo apt-get update`.

### Native Windows shell is rejected

Run the installer inside WSL. Native Windows environments such as Git Bash, MSYS, and Cygwin are not supported.

## License

MIT
