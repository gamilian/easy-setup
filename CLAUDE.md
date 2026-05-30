# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A single-script terminal-environment installer. Running `./setup.sh` installs and configures a complete terminal stack (Ghostty + Fish/Zsh + Starship + Nerd Font + a set of modern CLI tools) on **macOS**, **Debian/Ubuntu**, and **Windows WSL**. macOS is the primary, well-tested target; Linux/WSL are functional but experimental.

There is no build system, dependency manager, compilation step, or test framework. The "source" is `setup.sh` plus the static config files it deploys.

## Commands

```bash
./setup.sh              # interactive: prompts for Fish vs Zsh
./setup.sh --fish       # non-interactive Fish
./setup.sh --zsh        # non-interactive Zsh
./setup.sh --dry-run    # print every mutating command without executing (combine with --fish/--zsh)
```

There are no configured linters, tests, or CI. Use these as de-facto verification:

```bash
bash -n setup.sh        # syntax check (the only "compile" available)
shellcheck setup.sh     # if installed — no config file, so default rules
./setup.sh --dry-run --zsh   # exercise the full logic path safely; every change is gated behind run_cmd
```

`--dry-run` is the main way to verify changes: the script is destructive (installs packages, runs `chsh`, writes `~/.zshrc`, edits global git config), so prefer dry-running over executing during development.

## Architecture

`setup.sh` (~1000 lines) is a monolithic, top-to-bottom procedural script — there are no sourced modules. Understanding it means understanding four cross-cutting mechanisms, all defined near the top:

- **`detect_os` → global `$OS`** (`macos` | `debian` | `wsl` | errors out otherwise). This single variable branches nearly every step. WSL is detected by grepping `/proc/version`; native Windows (MINGW/Cygwin) is explicitly rejected with a "install WSL" message.
- **Package abstraction**: `pkg_install` (brew on macOS, `apt-get` on Linux) and `cask_install` (macOS-only, no-op elsewhere) hide the package-manager difference. `has_cmd` gates everything for **idempotency** — every install checks "already present?" first, so the script is safe to re-run.
- **`run_cmd` is the dry-run seam**: it either executes its arguments or prints them with a `[DRY-RUN]` prefix. **Every state-changing command must go through `run_cmd`** or `--dry-run` will silently lie. This is the most important convention when editing the script.
- **Logging helpers** `info/success/warn/error` (error exits). The script runs under `set -euo pipefail`.

The body is **9 numbered steps** (package manager → terminal → font → shell → CLI tools → Starship → fnm → Zellij → deploy configs). Steps 4 and 5 fan out into `install_shell_macos`/`install_shell_linux` and `install_cli_tools_macos`/`install_cli_tools_linux`.

### Config deployment model (Step 9)

Configs are **copied, not symlinked**, into their platform-specific destinations (shell configs from `configs/<os>/`, shared configs from `configs/`). Any pre-existing file is first backed up as `<file>.bak.$(date +%s)` (these match `*.bak.*` in `.gitignore`). Destinations differ by OS — e.g. Ghostty is `config.ghostty` on macOS but `config` on Linux; lives under `~/Library/Application Support/...` on macOS vs `~/.config/ghostty` on Linux.

### Per-OS config files

The two configs that differ by platform — `.zshrc` and `config.fish` — exist as separate variants under `configs/macos/` and `configs/linux/`. Step 9 picks the directory from `$OS` (`macos` → `configs/macos/`, `debian`/`wsl` → `configs/linux/`) and copies the file as-is. There is **no `sed` patching** — each variant already contains its platform's paths. `starship.toml` and `ghostty.config` are byte-identical across platforms, so they stay at `configs/` and are not duplicated.

### Source-of-truth for shell config

Each shell config is fully self-contained in its per-OS file — `setup.sh` only copies, it never edits or appends. Aliases, fzf, zoxide, fnm, history, `set-ssh-key`, and (for Fish) the abbreviations all live directly in `configs/<os>/.zshrc` / `configs/<os>/config.fish`. To change Fish aliases, edit the `abbr` block in the `config.fish` files — not `setup.sh`.

### Bundled assets (offline/fallback installs on Linux)

- `bin/linux-x86_64/` ships prebuilt static binaries (`delta`, `eza`, `lazygit`, `starship`, `tldr`). On Linux the install order is apt → bundled binary (`install_bundled_bin` copies to `/usr/local/bin`). This makes installs work on machines where apt lacks newer tools. (`zoxide` similarly falls back to `scripts/install-zoxide.sh`; `btop` is apt-only and is skipped with a warning if unavailable. There is no snap fallback.)
- `fonts/` ships the MesloLGS NF `.ttf` files; they are copied directly (no network download).
- `scripts/install-zoxide.sh` is a vendored fallback installer used when apt doesn't have zoxide.
- On Debian, `bat`→`batcat` and `fd`→`fdfind`; the script symlinks the real names into `~/.local/bin`.

### curl-pipe bootstrap

If `configs/` isn't found next to the script (i.e. it was run via `bash <(curl ...)`), Step 0 `git clone`s the repo to a tmpdir and repoints `$SCRIPT_DIR`/`$CONFIGS_DIR` there before proceeding.

## Gotchas

- **`zsh-syntax-highlighting` must be sourced last** in both `configs/macos/.zshrc` and `configs/linux/.zshrc`. It wraps ZLE widgets, so it has to load after `compinit`, `zle -N`, and autosuggestions. This ordering was the subject of recent bugfix PRs — do not move that block up the file.
- **`configs/macos/` and `configs/linux/` are parallel variants.** A change to a shared section (aliases, history, fzf, abbreviations) must be applied to both files — there is no shared base. Linux-only differences: `/usr/share/...` plugin paths, `~/.local/bin` + `~/.local/share/fnm` in PATH, `~/.local/share/pnpm` for pnpm.
- The clone URL (`github.com/gamilian/terminal-setup.git`) appears in both the curl-pipe bootstrap (`setup.sh`) and the READMEs; keep them consistent if the repo moves.
- **README.md (English) and README_CN.md (Chinese) are parallel** — user-facing changes (new tool, new flag, alias table) should land in both.

## Non-installer files

- `terminal-color-demo.sh` — standalone interactive True-Color/Nerd-Font demo; not part of the installer.
- `dev-layout-sample.kdl` — sample Zellij layout users can load with `zellij --layout`; not deployed by the script.
