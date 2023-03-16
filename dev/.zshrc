# TOOLCHAIN
export PATH="$PATH:/opt/riscv/bin"

# AUTO-COMPLETE
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
setopt APPEND_HISTORY
setopt SHARE_HISTORY
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt HIST_EXPIRE_DUPS_FIRST
setopt EXTENDED_HISTORY

# COLORS
source ~/.zsh/F-Sy-H/F-Sy-H.plugin.zsh
alias ls="ls --color=auto"

# PROMPT
eval "$(starship init zsh)"
