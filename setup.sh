#!/usr/bin/env bash
#
# easy-setup — module selector
#
# Usage:
#   ./setup.sh                 # interactive module choice
#   ./setup.sh terminal        # run terminal-setup/terminal-setup.sh
#   ./setup.sh terminal --zsh  # pass args through to terminal-setup/terminal-setup.sh
#   ./install.sh terminal --zsh  # one-click bootstrap with the terminal module

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
    cat <<'EOF'
Usage:
  ./setup.sh [module] [module options]

Modules:
  terminal    Terminal environment setup (Ghostty + Fish/Zsh + Starship)

Examples:
  ./install.sh
  ./install.sh terminal --zsh
  ./install.sh terminal --fish --dry-run
  ./setup.sh terminal
  ./setup.sh terminal --zsh
  ./setup.sh terminal --fish --dry-run
EOF
}

ensure_module_script() {
    local module="$1"
    local module_script="$SCRIPT_DIR/$module/$module.sh"

    if [[ -f "$module_script" ]]; then
        printf '%s\n' "$module_script"
        return 0
    fi

    local tmpdir
    tmpdir="$(mktemp -d)"
    git clone --depth 1 https://github.com/gamilian/easy-setup.git "$tmpdir/easy-setup"
    module_script="$tmpdir/easy-setup/$module/$module.sh"

    if [[ ! -f "$module_script" ]]; then
        echo "Module not found after clone: $module" >&2
        exit 1
    fi

    printf '%s\n' "$module_script"
}

run_terminal_setup() {
    local module_script
    module_script="$(ensure_module_script "terminal-setup")"
    exec bash "$module_script" "$@"
}

if [[ $# -eq 0 ]]; then
    echo "Which setup do you want to run?"
    echo ""
    echo "  1) terminal  Terminal environment setup"
    echo ""
    read -rp "Choose [1]: " choice
    case "${choice:-1}" in
        1|terminal|terminal-setup) run_terminal_setup ;;
        *) echo "Unknown module: $choice" >&2; usage; exit 1 ;;
    esac
fi

module="$1"
shift

case "$module" in
    terminal|terminal-setup)
        run_terminal_setup "$@"
        ;;
    -h|--help|help)
        usage
        ;;
    *)
        echo "Unknown module: $module" >&2
        usage
        exit 1
        ;;
esac
