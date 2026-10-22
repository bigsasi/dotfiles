# Dotfiles

Managed with [chezmoi](https://www.chezmoi.io/).

## Features

- **Shell**: Bash with cross-platform support (Linux & macOS)
- **Prompt**: [Starship](https://starship.rs/) (fast, minimal, git-aware)
- **Editor & Completion**: [ble.sh](https://github.com/akinomyoga/ble.sh) (real-time syntax highlighting & autosuggestions for Bash)
- **Pager**: Colorized `man` pages
- **Editor**: Vim configured with Nord theme, Vundle, and development plugins
- **Environment**: Sourced `~/.exports` and `~/.bash_aliases`

## Quick Start / Installation on a New Machine

1. Install chezmoi:
   ```bash
   sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin
   ```

2. Initialize and apply dotfiles:
   ```bash
   chezmoi init --apply <your-github-username>/dotfiles
   ```
   Or if cloned locally into `~/dotfiles`:
   ```bash
   chezmoi init --source=~/dotfiles --apply
   ```

## Useful Commands

- `chezmoi status` - View pending changes between source state and home directory
- `chezmoi diff` - View unified diff of pending changes
- `chezmoi apply` - Apply changes to home directory
- `chezmoi cd` - Open a shell in the chezmoi dotfiles directory
- `chezmoi edit <file>` - Edit a managed file
