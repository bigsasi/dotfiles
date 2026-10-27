# Dotfiles

Managed with [chezmoi](https://www.chezmoi.io/).

## Features

- **Shell**: Fast, responsive Bash (Linux & macOS) with zero keystroke lag
- **Readline (`.inputrc`)**: Case-insensitive completion, single-Tab colored menu, and history prefix search (`Up`/`Down`)
- **Prompt**: [Starship](https://starship.rs/) styled with the **Nord** palette, git state/counts, SSH detection, exit codes, and dev runtimes (Go, Python, Rust, Node/TS, C/C++, Erlang, Docker)
- **Modern CLI Suite** (auto-bootstrapped to `~/.local/bin`):
  - [`fzf`](https://github.com/junegunn/fzf): Fuzzy search for command history (`Ctrl+R`), files with syntax preview (`Ctrl+T`), and directories (`Alt+C`)
  - [`zoxide`](https://github.com/ajeetdsouza/zoxide): Smart directory jumper (`z <query>`, interactive `zi`)
  - [`eza`](https://github.com/eza-community/eza): Modern `ls` replacement with Nerd Font icons, git status (`ll`, `la`), and tree views (`lt`)
  - [`bat`](https://github.com/sharkdp/bat): Syntax-highlighted `cat` (`bcat`, `catp`) and Nord-themed `man` pager
  - [`fd`](https://github.com/sharkdp/fd) & [`ripgrep`](https://github.com/BurntSushi/ripgrep): Ultra-fast file & code search (`fd`, `rg`)
- **Editor**: Vim configured with Nord theme, Vundle, and development plugins
- **Environment**: Sourced `~/.exports` and `~/.bash_aliases`

## Quick Start / Installation on a New Machine

1. Install chezmoi:
   ```bash
   sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin
   ```

2. Initialize and apply dotfiles:
   ```bash
   chezmoi init --apply bigsasi/dotfiles
   ```
   Or if cloned locally into `~/dotfiles`:
   ```bash
   chezmoi init --source=~/dotfiles --apply
   ```

## Useful Keybindings & Commands

- `Ctrl+R` - Fuzzy search command history (`fzf`)
- `Ctrl+T` - Fuzzy find files in current directory with `bat` syntax preview
- `Alt+C` - Fuzzy jump into subdirectories with `eza` tree preview
- `z <dir>` / `zi` - Jump to frecent directories (`zoxide`)
- `ll` / `la` / `lt` - File listings with icons, git status, or 2-level tree (`eza`)
- `cms` / `cmd` / `cma` - Shortcuts for `chezmoi status`, `diff`, and `apply`
