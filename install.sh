#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"
DRY_RUN=false

for arg in "$@"; do
  case $arg in
    --dry-run|--diff|-n) DRY_RUN=true ;;
  esac
done

$DRY_RUN && echo "Dry run — no changes will be made" && echo ""

echo "Dotfiles: $DOTFILES"
echo ""

# ─── helpers ─────────────────────────────────────────────────────────────────

backup_and_remove() {
  local path="$1"
  if $DRY_RUN; then
    printf "  [backup] %s -> %s\n" "$path" "$BACKUP/${path#"$HOME"/}"
  else
    mkdir -p "$BACKUP/$(dirname "${path#"$HOME"/}")"
    mv "$path" "$BACKUP/${path#"$HOME"/}"
    printf "  [backup] %s\n" "$path"
  fi
}

check_dotfiles_symlink() {
  local dst="$HOME/.dotfiles"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$DOTFILES" ]; then
    printf "  [ok]     %s\n" "$dst"
  elif [ -L "$dst" ]; then
    printf "  [update] %s\n" "$dst"
    printf "           was: %s\n" "$(readlink "$dst")"
    printf "           now: %s\n" "$DOTFILES"
    $DRY_RUN || ln -snf "$DOTFILES" "$dst"
  elif [ -e "$dst" ]; then
    backup_and_remove "$dst"
    $DRY_RUN || ln -snf "$DOTFILES" "$dst"
  else
    printf "  [new]    %s -> %s\n" "$dst" "$DOTFILES"
    $DRY_RUN || ln -snf "$DOTFILES" "$dst"
  fi
}

link() {
  local src="$DOTFILES/$1"
  local dst="$2"

  if [ -L "$dst" ]; then
    local current
    current="$(readlink "$dst")"
    if [ "$current" = "$src" ]; then
      printf "  [ok]     %s\n" "$dst"
    else
      printf "  [update] %s\n" "$dst"
      printf "           was: %s\n" "$current"
      printf "           now: %s\n" "$src"
      $DRY_RUN || { mkdir -p "$(dirname "$dst")"; ln -snf "$src" "$dst"; }
    fi
  elif [ -e "$dst" ]; then
    backup_and_remove "$dst"
    $DRY_RUN && printf "  [link]   %s -> %s\n" "$dst" "$src"
    $DRY_RUN || { mkdir -p "$(dirname "$dst")"; ln -snf "$src" "$dst"; }
    $DRY_RUN || printf "  [link]   %s -> %s\n" "$dst" "$src"
  else
    printf "  [new]    %s -> %s\n" "$dst" "$src"
    $DRY_RUN || { mkdir -p "$(dirname "$dst")"; ln -snf "$src" "$dst"; }
  fi
}

# ─── links ───────────────────────────────────────────────────────────────────

echo "$HOME/.dotfiles symlink"
check_dotfiles_symlink

echo ""
echo "Shell"
link "zsh/.zshrc"                         "$HOME/.zshrc"

echo ""
echo "Git"
link "git/.gitconfig"                     "$HOME/.gitconfig"
link "git/.gitignore_global"              "$HOME/.gitignore_global"

echo ""
echo "Tmux"
link "tmux/.tmux.conf"                    "$HOME/.tmux.conf"

echo ""
echo "Editors"
link "nvim/.config/nvim"                  "$HOME/.config/nvim"
link "lazygit/.config/lazygit"            "$HOME/.config/lazygit"

echo ""
echo "Terminals"
link "ghostty/.config/ghostty"            "$HOME/.config/ghostty"
link "wezterm/.config/wezterm"            "$HOME/.config/wezterm"

echo ""
echo "Prompt / tools"
link "starship/.config/starship.toml"     "$HOME/.config/starship.toml"
link "atuin/.config/atuin"                "$HOME/.config/atuin"
link "mise/.tool-versions"                "$HOME/.tool-versions"
if [[ "$(uname)" != "Darwin" ]]; then
  link "mise/config.toml"                 "$HOME/.config/mise/config.toml"
fi

echo ""
echo "macOS"
link "aerospace/.config/aerospace"        "$HOME/.config/aerospace"
link "kanata/.config/kanata"              "$HOME/.config/kanata"

if [[ "$(uname)" == "Darwin" ]]; then
  plist_dst="$HOME/Library/LaunchAgents/com.kanata.plist"
  plist_src="$DOTFILES/kanata/com.kanata.plist"
  sudoers_dst="/etc/sudoers.d/kanata"
  if [ -f "$plist_dst" ]; then
    printf "  [ok]     %s\n" "$plist_dst"
  elif $DRY_RUN; then
    printf "  [new]    %s\n" "$plist_dst"
  elif command -v kanata &>/dev/null; then
    # sudoers entry so LaunchAgent can run kanata as root without a password prompt
    if [ ! -f "$sudoers_dst" ]; then
      echo "$(whoami) ALL=(ALL) NOPASSWD: $(command -v kanata)" | sudo tee "$sudoers_dst" > /dev/null
      sudo chmod 440 "$sudoers_dst"
      printf "  [new]    %s\n" "$sudoers_dst"
    fi
    mkdir -p "$HOME/Library/LaunchAgents"
    sed "s|__HOME__|$HOME|g" "$plist_src" > "$plist_dst"
    launchctl load "$plist_dst"
    printf "  [new]    %s\n" "$plist_dst"
  else
    printf "  [skip]   %s (kanata not installed)\n" "$plist_dst"
  fi
fi

# ─── tool check ──────────────────────────────────────────────────────────────

echo ""
echo "Checking tools..."

# format: "binary:install hint"
tools=(
  "starship:brew install starship"
  "nvim:brew install neovim"
  "tmux:brew install tmux"
  "bat:brew install bat"
  "eza:brew install eza"
  "fd:brew install fd"
  "rg:brew install ripgrep"
  "fzf:brew install fzf"
  "lazygit:brew install lazygit"
  "gh:brew install gh"
  "delta:brew install git-delta"
  "direnv:brew install direnv"
  "mise:brew install mise"
  "zoxide:brew install zoxide"
  "atuin:brew install atuin"
  "yazi:brew install yazi"
  "aerospace:brew install nikitabobko/tap/aerospace"
  "kanata:manual install — see https://github.com/jtroo/kanata/releases"
  "shellcheck:brew install shellcheck"
  "shfmt:brew install shfmt"
  "btop:brew install btop"
)

missing=()
for entry in "${tools[@]}"; do
  cmd="${entry%%:*}"
  hint="${entry#*:}"
  if command -v "$cmd" &>/dev/null; then
    printf "  [ok]     %s\n" "$cmd"
  else
    printf "  [miss]   %s\n" "$cmd"
    missing+=("$hint")
  fi
done

if [ ${#missing[@]} -gt 0 ]; then
  echo ""
  echo "Install missing tools:"
  for hint in "${missing[@]}"; do
    echo "  $hint"
  done
fi

# ─── fzf-tab (not on brew) ───────────────────────────────────────────────────

echo ""
echo "tpm (tmux plugin manager)"
if [ -d "$HOME/.tmux/plugins/tpm" ]; then
  printf "  [ok]     ~/.tmux/plugins/tpm\n"
elif $DRY_RUN; then
  printf "  [new]    ~/.tmux/plugins/tpm (git clone)\n"
else
  git clone --depth=1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm" &>/dev/null
  printf "  [new]    ~/.tmux/plugins/tpm\n"
fi

echo ""
echo "fzf-tab"
if [ -d "$HOME/.fzf-tab" ]; then
  printf "  [ok]     ~/.fzf-tab\n"
elif $DRY_RUN; then
  printf "  [new]    ~/.fzf-tab (git clone)\n"
else
  git clone --depth=1 https://github.com/Aloxaf/fzf-tab "$HOME/.fzf-tab" &>/dev/null
  printf "  [new]    ~/.fzf-tab\n"
fi

if ! $DRY_RUN && [ -d "$BACKUP" ]; then
  echo ""
  echo "Backups saved to: $BACKUP"
fi

echo ""
if $DRY_RUN; then
  echo "Done (dry run). Run without --dry-run to apply."
else
  echo "Done. Next steps:"
  echo "  1. Open a new shell to pick up changes"
  echo "  2. Run: mise install"
  echo "  3. Open tmux and run: prefix + I  (install plugins)"
  echo "  4. Open nvim and run: :Lazy sync  (pin smart-splits + other new plugins to lazy-lock.json)"
  if [[ "$(uname)" == "Darwin" ]]; then
    echo "  5. macOS: grant kanata Input Monitoring + Accessibility in System Settings → Privacy & Security"
    echo "     then reboot once for permissions to take effect"
  fi
fi
