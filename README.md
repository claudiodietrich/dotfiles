# My Dotfiles

This repository contains my personal configuration files for various applications and tools.

## Installation

The installation process is automated using a script designed for Fedora.

**Warning:** The installation script will install packages and modify your system configuration.

1. **Clone the repository:**

```bash
git clone https://github.com/d33trik/dotfiles.git ~/dotfiles
```

2. **Navigate to the repository directory:**

```bash
cd ~/dotfiles
```

3. **Run the installation script:**

```bash
bash scripts/install_packages.sh
```

The script will:

- Execute all the installation scripts located in the `packages/` directory.
- Apply the dotfiles using `stow`.
