if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Homebrew (auto-detect Apple Silicon vs Intel)
if test -d /opt/homebrew
    fish_add_path /opt/homebrew/bin
else if test -d /usr/local/Cellar
    fish_add_path /usr/local/bin
end

# Starship prompt
if command -q starship
    source (starship init fish --print-full-init | psub)
end

# fnm (Node version manager) — only if installed
if command -q fnm
    fnm env --use-on-cd --shell fish | source
end

# SSH key switcher (fallback for multi-account setups)
# Usage: set-ssh-key lewis-official-20260224
# Prefer ~/.ssh/config Host aliases for automatic matching.
function set-ssh-key
    set -l key "$HOME/.ssh/$argv[1]"
    if not test -f "$key"
        echo "Key not found: $key" >&2
        echo "Available keys:" >&2
        for f in ~/.ssh/*.pub
            echo "  "(basename $f .pub) >&2
        end
        return 1
    end
    ssh-add -D 2>/dev/null
    ssh-add "$key"
    echo "Active SSH key: $argv[1]"
end

# pnpm
set -gx PNPM_HOME "$HOME/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# Abbreviations (compatible with Fish 3.x and 4.x)
if status is-interactive
    abbr -a ls "eza --icons --group-directories-first"
    abbr -a ll "eza -la --icons --group-directories-first"
    abbr -a lt "eza --tree --icons --level=2"
    abbr -a cat "bat"
    abbr -a find "fd"
    abbr -a grep "rg"
    abbr -a top "btop"
    abbr -a lg "lazygit"
    abbr -a cd "z"
end

# Proxy
function proxy
    set -l port (test (count $argv) -gt 0; and echo $argv[1]; or echo 7897)
    set -gx http_proxy "http://127.0.0.1:$port"
    set -gx https_proxy "http://127.0.0.1:$port"
    set -gx all_proxy "socks5://127.0.0.1:$port"
    set -gx HTTP_PROXY "$http_proxy"
    set -gx HTTPS_PROXY "$https_proxy"
    set -gx ALL_PROXY "$all_proxy"
    set -gx no_proxy "localhost,127.0.0.1,::1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16"
    set -gx NO_PROXY "$no_proxy"
    echo "Proxy on → 127.0.0.1:$port"
end

function unproxy
    set -e http_proxy https_proxy all_proxy no_proxy HTTP_PROXY HTTPS_PROXY ALL_PROXY NO_PROXY
    echo "Proxy off"
end

# zoxide
zoxide init fish | source

# fzf
fzf --fish | source
set -gx FZF_DEFAULT_OPTS '--height 40% --layout=reverse --border'
if command -q fd
    set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
    set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
    set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --follow --exclude .git'
end
