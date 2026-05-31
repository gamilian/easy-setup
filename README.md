# easy-setup

Personal setup scripts for development environments.

## Modules

- **terminal-setup**: terminal environment setup for macOS, Debian/Ubuntu, and WSL. Module script: `terminal-setup/terminal-setup.sh`.

## Quick Start

One-command install:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/gamilian/easy-setup/main/install.sh) terminal
```

Choose a shell or preview changes:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/gamilian/easy-setup/main/install.sh) terminal --zsh
bash <(curl -fsSL https://raw.githubusercontent.com/gamilian/easy-setup/main/install.sh) terminal --fish --dry-run
```

Manual download and run:

```bash
git clone https://github.com/gamilian/easy-setup.git
cd easy-setup
./setup.sh terminal
```

Pass terminal setup options after the module name:

```bash
./setup.sh terminal --zsh
./setup.sh terminal --fish --dry-run
./install.sh terminal --zsh
./install.sh terminal --fish --dry-run
```

For full terminal setup details, see [terminal-setup/README.md](terminal-setup/README.md).

**中文版文档:** [README_CN.md](README_CN.md)
