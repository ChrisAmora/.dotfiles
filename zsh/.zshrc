eval "$(starship init zsh)"

alias vim='nvim'
alias cat='batcat'
alias ls='exa'

# Golang
export PATH=$PATH:~/go/bin

# VSCode
export PATH="$PATH:/mnt/c/Users/chris/AppData/Local/Programs/Microsoft VS Code/bin"

# Cargo
export PATH=$PATH:~/.cargo/bin

export PATH="/home/zvist/.local/bin:$PATH"
export PATH=$PATH:/home/zvist/code/lua-language-server/bin

precmd () {print -Pn "\e]0;%~\a"}

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# opam configuration
[[ ! -r /home/zvist/.opam/opam-init/init.zsh ]] || source /home/zvist/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

. $HOME/.asdf/asdf.sh

# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit

# pnpm
export PNPM_HOME="/home/zvist/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end
