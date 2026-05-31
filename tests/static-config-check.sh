#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROOT_SETUP_SH="$ROOT_DIR/setup.sh"
INSTALL_SH="$ROOT_DIR/install.sh"
MODULE_DIR="$ROOT_DIR/terminal-setup"
SETUP_SH="$MODULE_DIR/terminal-setup.sh"
STARSHIP_TOML="$MODULE_DIR/configs/starship.toml"
README_MD="$ROOT_DIR/README.md"
README_ZH_CN_MD="$ROOT_DIR/README.zh-CN.md"
MODULE_README_ZH_CN_MD="$MODULE_DIR/README.zh-CN.md"
CLAUDE_MD="$ROOT_DIR/CLAUDE.md"
RAW_INSTALL_URL="https://raw.githubusercontent.com/gamilian/easy-setup/main/install.sh"

if [[ -e "$ROOT_DIR/README_CN.md" ]] || [[ -e "$MODULE_DIR/README_CN.md" ]]; then
    echo "Chinese READMEs must use README.zh-CN.md, not README_CN.md" >&2
    exit 1
fi

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

for file in "$README_MD" "$README_ZH_CN_MD" "$MODULE_DIR/README.md" "$MODULE_README_ZH_CN_MD"; do
    if ! grep -q "$RAW_INSTALL_URL" "$file"; then
        echo "$file must document the one-click install URL: $RAW_INSTALL_URL" >&2
        exit 1
    fi
done

if ! grep -R -q "$RAW_INSTALL_URL) terminal --zsh" \
    "$README_MD" "$README_ZH_CN_MD" "$MODULE_DIR/README.md" "$MODULE_README_ZH_CN_MD"; then
    echo "READMEs must show one-click zsh usage as: $RAW_INSTALL_URL) terminal --zsh" >&2
    exit 1
fi

if grep -R -n "$RAW_INSTALL_URL) --zsh\\|$RAW_INSTALL_URL) --fish" \
    "$README_MD" "$README_ZH_CN_MD" "$MODULE_DIR/README.md" "$MODULE_README_ZH_CN_MD" >/dev/null; then
    echo "one-click README examples must include the terminal module before shell options" >&2
    exit 1
fi

if grep -R -n 'README_CN\.md' \
    "$README_MD" "$README_ZH_CN_MD" "$MODULE_DIR/README.md" "$MODULE_README_ZH_CN_MD" "$CLAUDE_MD" >/dev/null; then
    echo "README links must use README.zh-CN.md, not README_CN.md" >&2
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

if ! grep -q 'enable_ubuntu_universe' "$SETUP_SH"; then
    echo "terminal setup must enable Ubuntu universe before installing Linux tools that may live outside main" >&2
    exit 1
fi

if ! grep -q 'apt_install_or_retry_with_universe "btop"' "$SETUP_SH"; then
    echo "btop install must retry after enabling Ubuntu universe" >&2
    exit 1
fi

if ! grep -q 'apt_install_or_retry_with_universe "zoxide"' "$SETUP_SH"; then
    echo "zoxide install must retry after enabling Ubuntu universe before fallback" >&2
    exit 1
fi

for expected in \
    'VS Code / Cursor' \
    'iTerm2' \
    'Windows Terminal' \
    'MesloLGS NF'
do
    if ! grep -q "$expected" "$SETUP_SH"; then
        echo "final installer output must remind users to configure terminal fonts: $expected" >&2
        exit 1
    fi
done

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
    "$ROOT_SETUP_SH" "$SETUP_SH" "$README_MD" "$README_ZH_CN_MD" "$CLAUDE_MD" >/dev/null; then
    echo "Repository clone URLs must point at github.com/gamilian/easy-setup.git" >&2
    exit 1
fi

for file in "$README_MD" "$README_ZH_CN_MD"; do
    if ! grep -q '^# .*easy-setup' "$file"; then
        echo "$file must use easy-setup as the repository name" >&2
        exit 1
    fi
done

if ! grep -q '\[简体中文\](README.zh-CN.md)' "$README_MD"; then
    echo "README.md must expose the Chinese README switch near the top" >&2
    exit 1
fi

if ! grep -q '\[English\](README.md)' "$README_ZH_CN_MD"; then
    echo "README.zh-CN.md must expose the English README switch near the top" >&2
    exit 1
fi

if ! grep -q 'terminal-setup' "$README_MD" || ! grep -q 'terminal-setup' "$README_ZH_CN_MD"; then
    echo "READMEs must keep the current terminal setup feature named terminal-setup" >&2
    exit 1
fi

if ! grep -q '\[简体中文\](README.zh-CN.md)' "$MODULE_DIR/README.md"; then
    echo "terminal-setup/README.md must expose the Chinese README switch near the top" >&2
    exit 1
fi

if ! grep -q '\[English\](README.md)' "$MODULE_README_ZH_CN_MD"; then
    echo "terminal-setup/README.zh-CN.md must expose the English README switch near the top" >&2
    exit 1
fi

if ! grep -q 'Post-install Font Setup' "$MODULE_DIR/README.md"; then
    echo "terminal-setup/README.md must document terminal font setup after install" >&2
    exit 1
fi

if ! grep -q '安装后字体设置' "$MODULE_README_ZH_CN_MD"; then
    echo "terminal-setup/README.zh-CN.md must document terminal font setup after install" >&2
    exit 1
fi

if ! grep -q 'Ubuntu.*universe' "$MODULE_DIR/README.md"; then
    echo "terminal-setup/README.md must mention Ubuntu universe handling for apt packages" >&2
    exit 1
fi

if ! grep -q 'Ubuntu.*universe' "$MODULE_README_ZH_CN_MD"; then
    echo "terminal-setup/README.zh-CN.md must mention Ubuntu universe handling for apt packages" >&2
    exit 1
fi

if grep -R -n 'terminal-setup/setup.sh' \
    "$ROOT_SETUP_SH" "$README_MD" "$README_ZH_CN_MD" "$CLAUDE_MD" "$MODULE_DIR/README.md" "$MODULE_README_ZH_CN_MD" >/dev/null; then
    echo "references must use terminal-setup/terminal-setup.sh, not terminal-setup/setup.sh" >&2
    exit 1
fi
