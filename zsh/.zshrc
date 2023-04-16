eval "$(starship init zsh)"

alias fd='fd --type f --color=always -H --exclude .git'
alias vim='nvim'
alias cat='batcat'
alias ls='exa'
alias lg='lazygit'

export FZF_DEFAULT_OPTS="-m --height 50% --layout=reverse --border --inline-info 
  --preview '([[ -f {} ]] && (batcat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
  --bind '?:toggle-preview' 
"

export FZF_DEFAULT_COMMAND='fd --type file --hidden --exclude .git'
export FZF_CTRL_T_COMMAND='fd --type file --hidden --exclude .git'

export PATH=$PATH:~/go/bin

export PATH=$PATH:~/.cargo/bin

export PATH="/home/zvist/.local/bin:$PATH"

precmd () {print -Pn "\e]0;%~\a"}

HISTFILE=~/.zsh_history
HISTSIZE=90000
SAVEHIST=90000
setopt appendhistory
setopt sharehistory
setopt incappendhistory
set -o vi

source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh
source $HOME/.dotfiles/zsh/.git-alias.zshrc

[[ ! -r /home/zvist/.opam/opam-init/init.zsh ]] || source /home/zvist/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

. $HOME/.asdf/asdf.sh

fpath=(${ASDF_DIR}/completions $fpath)

autoload -Uz compinit && compinit

export PNPM_HOME="/home/zvist/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
    *)            fzf "$@" ;;
  esac
}

eval "$(zoxide init zsh)"
