#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROOT_SETUP_SH="$ROOT_DIR/setup.sh"
INSTALL_SH="$ROOT_DIR/install.sh"
MODULE_DIR="$ROOT_DIR/terminal-setup"
SETUP_SH="$MODULE_DIR/terminal-setup.sh"
STARSHIP_TOML="$MODULE_DIR/configs/starship.toml"
README_MD="$ROOT_DIR/README.md"
README_CN_MD="$ROOT_DIR/README_CN.md"
CLAUDE_MD="$ROOT_DIR/CLAUDE.md"
RAW_INSTALL_URL="https://raw.githubusercontent.com/gamilian/easy-setup/main/install.sh"

if [[ ! -f "$INSTALL_SH" ]]; then
    echo "root install.sh must provide the one-click bootstrap entry point" >&2
    exit 1
fi

if grep -q 'DEFAULT_MODULE=' "$INSTALL_SH"; then
    echo "install.sh must require the module argument instead of defaulting to terminal" >&2
    exit 1
fi

if ! grep -q 'https://github.com/gamilian/easy-setup.git' "$INSTALL_SH"; then
    echo "install.sh must clone from github.com/gamilian/easy-setup.git when run remotely" >&2
    exit 1
fi

for file in "$README_MD" "$README_CN_MD" "$MODULE_DIR/README.md" "$MODULE_DIR/README_CN.md"; do
    if ! grep -q "$RAW_INSTALL_URL" "$file"; then
        echo "$file must document the one-click install URL: $RAW_INSTALL_URL" >&2
        exit 1
    fi
done

if ! grep -R -q "$RAW_INSTALL_URL) terminal --zsh" \
    "$README_MD" "$README_CN_MD" "$MODULE_DIR/README.md" "$MODULE_DIR/README_CN.md"; then
    echo "READMEs must show one-click zsh usage as: $RAW_INSTALL_URL) terminal --zsh" >&2
    exit 1
fi

if grep -R -n "$RAW_INSTALL_URL) --zsh\\|$RAW_INSTALL_URL) --fish" \
    "$README_MD" "$README_CN_MD" "$MODULE_DIR/README.md" "$MODULE_DIR/README_CN.md" >/dev/null; then
    echo "one-click README examples must include the terminal module before shell options" >&2
    exit 1
fi

if [[ ! -f "$ROOT_SETUP_SH" ]] || ! grep -q 'terminal|terminal-setup)' "$ROOT_SETUP_SH"; then
    echo "root setup.sh must offer a terminal setup option" >&2
    exit 1
fi

if ! grep -q 'terminal-setup/terminal-setup.sh' "$ROOT_SETUP_SH"; then
    echo "root setup.sh must dispatch to terminal-setup/terminal-setup.sh" >&2
    exit 1
fi

if [[ ! -f "$SETUP_SH" ]]; then
    echo "terminal setup installer must live at terminal-setup/terminal-setup.sh" >&2
    exit 1
fi

if ! grep -q 'pkg_install "fontconfig"' "$SETUP_SH"; then
    echo "setup.sh must install fontconfig on Linux/WSL so fc-cache and fc-match are available" >&2
    exit 1
fi

for expected in \
    'Ubuntu = ""' \
    'Linux = ""' \
    'Debian = ""'
do
    if ! grep -q "$expected" "$STARSHIP_TOML"; then
        echo "configs/starship.toml must use a broadly supported Linux OS icon: $expected" >&2
        exit 1
    fi
done

if grep -R -n 'github.com/gamilian/terminal-setup.git\|github.com/gamilian/esay-setup.git' \
    "$ROOT_SETUP_SH" "$SETUP_SH" "$README_MD" "$README_CN_MD" "$CLAUDE_MD" >/dev/null; then
    echo "Repository clone URLs must point at github.com/gamilian/easy-setup.git" >&2
    exit 1
fi

for file in "$README_MD" "$README_CN_MD"; do
    if ! grep -q '^# .*easy-setup' "$file"; then
        echo "$file must use easy-setup as the repository name" >&2
        exit 1
    fi
done

if ! grep -q 'terminal-setup' "$README_MD" || ! grep -q 'terminal-setup' "$README_CN_MD"; then
    echo "READMEs must keep the current terminal setup feature named terminal-setup" >&2
    exit 1
fi

if grep -R -n 'terminal-setup/setup.sh' \
    "$ROOT_SETUP_SH" "$README_MD" "$README_CN_MD" "$CLAUDE_MD" "$MODULE_DIR/README.md" "$MODULE_DIR/README_CN.md" >/dev/null; then
    echo "references must use terminal-setup/terminal-setup.sh, not terminal-setup/setup.sh" >&2
    exit 1
fi
