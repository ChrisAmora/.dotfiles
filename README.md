# dotfiles

macOS-first, WSL2-compatible. Managed with a custom `install.sh` that symlinks configs and backs up anything it replaces.

## Install

```sh
brew bundle          # install tools
./install.sh         # symlink configs, clone fzf-tab and tpm
mise install         # install language runtimes
```

After tmux is open: `prefix + I` to install plugins.

## What's included

| Tool | Purpose |
|---|---|
| zsh + starship | shell + prompt |
| tmux | multiplexer (catppuccin theme, sessionx, resurrect) |
| neovim | editor (LazyVim) |
| mise | language version manager (node, go, rust) |
| atuin | shell history (local-only, no sync) |
| zoxide | smarter `cd` |
| fzf + fzf-tab | fuzzy finder + tab completion |
| ghostty | terminal (macOS) |
| wezterm | terminal (Windows/WSL2) |
| aerospace | tiling window manager (macOS) |
| kanata | keyboard remapper |
| lazygit | git TUI |

## Tmux session persistence

tmux-resurrect + tmux-continuum are configured to auto-save and auto-restore sessions.

| Binding | Action |
|---|---|
| `prefix + Ctrl-s` | Save session manually |
| `prefix + Ctrl-r` | Restore session manually |

Sessions are saved to `~/.local/share/tmux/resurrect/`. Continuum auto-saves every 15 minutes and restores on tmux server start. To clear old sessions: `rm ~/.local/share/tmux/resurrect/*.txt`.

## Kanata

CapsLock: tap = Escape, hold = nav layer (hjkl = arrows, nm,. = home/pgdn/pgup/end).  
Left Shift + Right Shift = CapsLock toggle.

**macOS setup** (kanata isn't on Homebrew):

1. Download the ARM64 zip from [github.com/jtroo/kanata/releases](https://github.com/jtroo/kanata/releases) (`macos-binaries-arm64.zip`)
2. Extract and install:
   ```sh
   unzip macos-binaries-arm64.zip
   chmod +x kanata
   sudo mv kanata /usr/local/bin/kanata
   ```
3. Grant **Input Monitoring** and **Accessibility** in System Settings → Privacy & Security
4. Reboot (required for TCC permissions to take effect)
5. Run `./install.sh` — it will install and load the LaunchDaemon automatically

## Fresh machine

```sh
git clone https://github.com/ChrisAmora/.dotfiles ~/code/.dotfiles
cd ~/code/.dotfiles
brew bundle
./install.sh
mise install
```

Fonts are installed via Brewfile (`font-caskaydia-cove-nerd-font`). On Windows, install WezTerm from [wezfurlong.org](https://wezfurlong.org/wezterm/installation.html) and fonts on the Windows host. For kanata, follow the macOS setup steps above.

## Windows / WSL2

On the Windows host first:
1. Install [WezTerm](https://wezfurlong.org/wezterm/installation.html)
2. Install [CaskaydiaCove Nerd Font](https://www.nerdfonts.com/font-downloads) — fonts must be on the Windows host, not inside WSL2

Inside WSL2 (Ubuntu):

```sh
# Prerequisites (ncurses-term provides tmux-256color — required for Neovim undercurls/italics)
sudo apt update && sudo apt install -y zsh git curl fzf zsh-autosuggestions zsh-syntax-highlighting ncurses-term

# Clone and install
git clone https://github.com/ChrisAmora/.dotfiles ~/code/.dotfiles
cd ~/code/.dotfiles
./install.sh
mise install

# Set zsh as default shell
chsh -s $(which zsh)
```

WezTerm will open WSL2 automatically (`default_domain = "WSL:Ubuntu"` in `wezterm.lua`). Update the distro name if yours differs (`wsl -l` to check).

**Kanata** must run as a Windows process (not inside WSL2) so it remaps keys system-wide.

1. Download `kanata.exe` from [github.com/jtroo/kanata/releases](https://github.com/jtroo/kanata/releases)
2. The config lives in WSL2 but is reachable from Windows at:
   `\\wsl.localhost\Ubuntu\home\<user>\.config\kanata\kanata.kbd`
3. To auto-start at login with admin rights, add a Task Scheduler entry:
   - Trigger: At log on
   - Action: `kanata.exe --cfg \\wsl.localhost\Ubuntu\home\<user>\.config\kanata\kanata.kbd`
   - Run with highest privileges: yes

Note: the `;` binding (`M-rght`) is macOS-only — change it to `_` in the config on Windows.
