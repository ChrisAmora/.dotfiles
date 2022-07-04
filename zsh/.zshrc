if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


alias vim='nvim'
alias cat='bat'
alias luamake=/home/zvist/code/lua-language-server/3rd/luamake/luamake


export NVM_DIR="$HOME/.nvm"
export NVM_COMPLETION=true

# Golang
export PATH=$PATH:/usr/local/go/bin
# VSCode
export PATH="$PATH:/mnt/c/Users/chris/AppData/Local/Programs/Microsoft VS Code/bin"

# Cargo
export PATH=$PATH:~/.cargo/bin

export PATH="/home/zvist/.local/bin:$PATH"
export PATH=$PATH:/home/zvist/code/lua-language-server/bin

if [ -e /home/zvist/.nix-profile/etc/profile.d/nix.sh ]; then . /home/zvist/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

# source zsh plugin
source ~/.zsh_plugins.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

