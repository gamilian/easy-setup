#!/usr/bin/env bash
#
# easy-setup one-click bootstrap

set -euo pipefail

REPO_URL="https://github.com/gamilian/easy-setup.git"

usage() {
    cat <<'EOF'
Usage:
  ./install.sh [module] [module options]
  bash <(curl -fsSL https://raw.githubusercontent.com/gamilian/easy-setup/main/install.sh) [module] [module options]

Modules:
  terminal    Terminal environment setup (Ghostty + Fish/Zsh + Starship)

Examples:
  ./install.sh
  ./install.sh terminal --zsh
  ./install.sh terminal --fish --dry-run
  bash <(curl -fsSL https://raw.githubusercontent.com/gamilian/easy-setup/main/install.sh) terminal
  bash <(curl -fsSL https://raw.githubusercontent.com/gamilian/easy-setup/main/install.sh) terminal --fish --dry-run
EOF
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMPDIR_CLONE=""
SETUP_SH=""

cleanup() {
    if [[ -n "$TMPDIR_CLONE" && -d "$TMPDIR_CLONE" ]]; then
        rm -rf "$TMPDIR_CLONE"
    fi
}
trap cleanup EXIT

resolve_setup_script() {
    if [[ -f "$SCRIPT_DIR/setup.sh" ]]; then
        SETUP_SH="$SCRIPT_DIR/setup.sh"
        return 0
    fi

    if ! command -v git >/dev/null 2>&1; then
        echo "git is required to bootstrap easy-setup remotely." >&2
        exit 1
    fi

    TMPDIR_CLONE="$(mktemp -d)"
    git clone --depth 1 "$REPO_URL" "$TMPDIR_CLONE/easy-setup"
    SETUP_SH="$TMPDIR_CLONE/easy-setup/setup.sh"
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" || "${1:-}" == "help" ]]; then
    usage
    exit 0
fi

resolve_setup_script
bash "$SETUP_SH" "$@"
