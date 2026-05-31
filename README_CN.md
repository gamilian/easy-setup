# easy-setup

个人开发环境配置脚本集合。

## 模块

- **terminal-setup**：适用于 macOS、Debian/Ubuntu 和 WSL 的终端环境配置。模块脚本：`terminal-setup/terminal-setup.sh`。

## 快速开始

一键运行：

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/gamilian/easy-setup/main/install.sh) terminal
```

选择 Shell 或预览改动：

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/gamilian/easy-setup/main/install.sh) terminal --zsh
bash <(curl -fsSL https://raw.githubusercontent.com/gamilian/easy-setup/main/install.sh) terminal --fish --dry-run
```

手动下载后运行：

```bash
git clone https://github.com/gamilian/easy-setup.git
cd easy-setup
./setup.sh terminal
```

终端配置参数放在模块名后面：

```bash
./setup.sh terminal --zsh
./setup.sh terminal --fish --dry-run
./install.sh terminal --zsh
./install.sh terminal --fish --dry-run
```

完整终端配置说明见 [terminal-setup/README_CN.md](terminal-setup/README_CN.md)。

**English Version:** [README.md](README.md)
