# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
##########################
# Default config at setup
##########################
#
[ -f "${HOME}/.shell.common" ] && . "${HOME}/.shell.common"
# FZF
[ -f "~/.fzf.zsh" ] && . "~/.fzf.zsh"
# ASDF completion
[ -d "$ASDF_DIR" ] && fpath=(${ASDF_DIR}/completions $fpath)

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory autocd extendedglob notify
bindkey -e
zstyle :compinstall filename '/home/georgio/.zshrc'
autoload -Uz compinit
compinit

if [ -f ~/.config/antigen/antigen.zsh ]; then
  source ~/.config/antigen/antigen.zsh
  # Load the oh-my-zsh's library.
  antigen use oh-my-zsh
  # Bundles from the default repo (robbyrussell's oh-my-zsh).
  antigen bundle laurenkt/zsh-vimto
  antigen bundle git
  antigen bundle zsh-users/zsh-completions
  antigen bundle command-not-found
  antigen bundle alexrochas/zsh-extract
  antigen bundle alexrochas/zsh-vim-crtl-z
  antigen bundle alexrochas/zsh-git-semantic-commits
  antigen bundle alexrochas/zsh-path-environment-explorer
  # Syntax highlighting bundle.
  antigen bundle zsh-users/zsh-syntax-highlighting
  # Load the theme.
  # You probably will want to install powerline fonts https://github.com/powerline/fonts
  # antigen theme sindresorhus/pure
  # antigen theme denysdovhan/spaceship-prompt
  # antigen theme robbyrussell/oh-my-zsh themes/agnoster
  # antigen theme robbyrussell/oh-my-zsh themes/arrow
  # antigen theme robbyrussell/oh-my-zsh themes/cloud
  # Tell antigen that you're done.
  antigen bundle chisui/zsh-nix-shell
  antigen apply
fi

# Dir env
hash direnv 2>/dev/null && eval "$(direnv hook zsh)"
# Zoxide = Better cd
hash zoxide 2>/dev/null && eval "$(zoxide init zsh)"
# Prompt
hash starship 2>/dev/null && eval "$(starship init zsh)"
# Fzf theme
[ -f ~/.fzf.colors ] && source ~/.fzf.colors

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
