command -v starship &>/dev/null && eval "$(starship init zsh)"

alias fd='fd --type f --color=always -H --exclude .git'
alias vim='nvim'
alias cat='bat'
alias ls='eza'
alias lg='lazygit'
alias diff='delta'
alias y='yazi'

export EDITOR=nvim
export VISUAL=nvim

# go/cargo paths are managed by mise — kept as fallback for non-mise environments
export PATH=$PATH:~/go/bin
export PATH=$PATH:~/.cargo/bin

precmd () {print -Pn "\e]0;%~\a"}

HISTFILE=~/.zsh_history
HISTSIZE=90000
SAVEHIST=90000
setopt sharehistory
setopt incappendhistory
set -o vi

export PATH="$HOME/.local/bin:$PATH"

if command -v mise &>/dev/null; then
  eval "$(mise activate zsh)"
fi
autoload -Uz compinit && compinit -C  # -C skips security scan, uses cache — run compinit once after new tool installs

# sourced after compinit so compdef calls inside take effect
[[ -f "$HOME/.dotfiles/zsh/.git-alias.zshrc" ]] && source "$HOME/.dotfiles/zsh/.git-alias.zshrc"

if [[ "$OSTYPE" == "darwin"* ]]; then
  export PNPM_HOME="$HOME/Library/pnpm"
else
  export PNPM_HOME="$HOME/.local/share/pnpm"
fi
[[ -d "$PNPM_HOME" ]] && export PATH="$PNPM_HOME:$PATH"

# tokyonight-storm palette: bg+=#2d3149 (selection), border=#565f89 (comment)
export FZF_DEFAULT_OPTS="--height 40% --border --layout=reverse --color=bg+:#2d3149,border:#565f89"

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf "$@" --preview 'eza --tree --color=always {} | head -200' ;;
    *)            fzf "$@" ;;
  esac
}

command -v direnv  &>/dev/null && eval "$(direnv hook zsh)"
[[ $- == *i* ]] && command -v zoxide &>/dev/null && eval "$(zoxide init zsh --cmd cd)"

if [[ "$OSTYPE" == "darwin"* ]]; then
  _brew="${HOMEBREW_PREFIX:-/opt/homebrew}"  # env var set by brew shellenv; fallback for Apple Silicon
  source "$_brew/opt/fzf/shell/key-bindings.zsh"
  source "$_brew/opt/fzf/shell/completion.zsh"
  [[ -f "$HOME/.fzf-tab/fzf-tab.plugin.zsh" ]] && source "$HOME/.fzf-tab/fzf-tab.plugin.zsh"
  source "$_brew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  source "$_brew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  unset _brew
else
  # Linux / WSL2 — install via: sudo apt install fzf zsh-autosuggestions zsh-syntax-highlighting
  [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]              && source /usr/share/doc/fzf/examples/key-bindings.zsh
  [[ -f /usr/share/doc/fzf/examples/completion.zsh ]]                && source /usr/share/doc/fzf/examples/completion.zsh
  [[ -f "$HOME/.fzf-tab/fzf-tab.plugin.zsh" ]]                       && source "$HOME/.fzf-tab/fzf-tab.plugin.zsh"
  [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]    && source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# atuin last — overrides fzf's ctrl+r binding
command -v atuin   &>/dev/null && eval "$(atuin init zsh)"
export HISTORY_IGNORE="(access_token|accesstoken|AKIA|api_key|apikey|authonly|authorization|aws_access_key_id|aws_secret_access_key|bearer|client-secret|client_secret|current_key|eyjrijoi|gh_token|github_token|hooks.slack.com|id-token|id_token|kubectl --token=|kubectl config set-credentials|pagerduty_|password|private_key|private_key_id|read|refresh-token|refresh_token|refreshtoken|token|x-api-key|x-auth-key)"
