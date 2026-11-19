# Dotfiles

Managed with [chezmoi](https://www.chezmoi.io/).

## Features

- **Shell**:
  - **Linux & macOS**: Fast, responsive Bash with zero keystroke lag
  - **Windows**: PowerShell 7 (`pwsh`) & Windows PowerShell 5.1 profile with UTF-8 I/O and full CLI parity
- **History Autosuggestions**:
  - **Bash (`.blerc` & `.inputrc`)**: Instant Fish-style inline ghost-text (`→` / `End` to accept, `Alt+→` for next word) via lightweight [`ble.sh`](https://github.com/akinomyoga/ble.sh), plus `Up`/`Down` prefix search
  - **PowerShell (`PSReadLine`)**: Inline history ghost-text predictions + `Up`/`Down` prefix search
- **Prompt**: Compact single-line [Starship](https://starship.rs/) styled with the **Nord** palette (SSH-safe, no Nerd Font required)
- **Modern CLI Suite** (auto-bootstrapped to `~/.local/bin`, or via `winget` with GitHub Release fallback on Windows):
  - [`fzf`](https://github.com/junegunn/fzf): Fuzzy search for command history (`Ctrl+R`), files with syntax preview (`Ctrl+T`), and directories (`Alt+C`, via `PSFzf` on PowerShell)
  - [`zoxide`](https://github.com/ajeetdsouza/zoxide): Smart directory jumper (`z <query>`, interactive `zi`)
  - [`eza`](https://github.com/eza-community/eza): Modern `ls` replacement with git status (`ll`, `la`) and tree views (`lt`)
  - [`bat`](https://github.com/sharkdp/bat): Syntax-highlighted `cat` (`bcat`, `catp`) and Nord-themed `man` pager
  - [`fd`](https://github.com/sharkdp/fd) & [`ripgrep`](https://github.com/BurntSushi/ripgrep): Ultra-fast file & code search (`fd`, `rg`)
- **Editor**: Vim configured with Nord theme, Vundle, and development plugins (Unix/macOS)
- **Environment**: Sourced `~/.exports` and `~/.bash_aliases`

## Quick Start / Installation on a New Machine

### Linux & macOS
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

### Windows (PowerShell)
1. Install chezmoi:
   ```powershell
   winget install twpayne.chezmoi
   ```

2. Initialize and apply dotfiles:
   ```powershell
   chezmoi init --apply bigsasi
   ```
   Restart your terminal once finished so updated `PATH` entries and `PSReadLine`/`PSFzf` modules load.

## Useful Keybindings & Commands

- `→` / `End` (or `Alt+→`) - Accept inline history ghost-text suggestion (or next word)
- `Ctrl+R` - Fuzzy search command history (`fzf`)
- `Ctrl+T` - Fuzzy find files in current directory with `bat` syntax preview
- `Alt+C` - Fuzzy jump into subdirectories with `eza` tree preview
- `z <dir>` / `zi` - Jump to frecent directories (`zoxide`)
- `ll` / `la` / `lt` - File listings with git status or 2-level tree (`eza`)
- `cms` / `cmd` / `cma` - Shortcuts for `chezmoi status`, `diff`, and `apply`
