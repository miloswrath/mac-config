# Portable settings from nix-conf 9aead75978c9b7782fb66aff716fd54ec1919d71.
# Sourced after the user's existing .zshrc so local environment setup is retained.
[[ -o interactive ]] || return 0
[[ ${_NIX_CONF_PORTABLE_LOADED:-0} == 1 ]] && return 0
typeset -g _NIX_CONF_PORTABLE_LOADED=1
typeset -g _NIX_CONF_ZSH_DIR=${${(%):-%N}:A:h}

# Homebrew's location is discovered; no /opt/homebrew or /usr/local assumption.
typeset _terminal_brew_prefix
if (( $+commands[brew] )); then
  _terminal_brew_prefix=$(command brew --prefix)
fi

# Reuse an existing Oh My Zsh installation, or the copy installed with this setup.
if [[ ! -d ${ZSH:-}/plugins ]]; then
  if [[ -d $HOME/.oh-my-zsh/plugins ]]; then
    export ZSH=$HOME/.oh-my-zsh
  else
    export ZSH=$_NIX_CONF_ZSH_DIR/vendor/oh-my-zsh
  fi
fi
if (( ! $+functions[omz] )) && [[ -r $ZSH/oh-my-zsh.sh ]]; then
  ZSH_THEME=''
  plugins=(git gitignore z)
  source "$ZSH/oh-my-zsh.sh"
else
  # The existing .zshrc already initialized OMZ; add only its missing plugins.
  (( $+functions[compdef] )) || { autoload -Uz compinit; compinit; }
  if (( ! $+functions[git_current_branch] )) && [[ -r $ZSH/plugins/git/git.plugin.zsh ]]; then
    source "$ZSH/plugins/git/git.plugin.zsh"
  fi
  if (( ! $+functions[gi] )) && [[ -r $ZSH/plugins/gitignore/gitignore.plugin.zsh ]]; then
    source "$ZSH/plugins/gitignore/gitignore.plugin.zsh"
  fi
  if (( ! $+functions[zshz] )) && [[ -r $ZSH/plugins/z/z.plugin.zsh ]]; then
    source "$ZSH/plugins/z/z.plugin.zsh"
  fi
fi

if (( ! $+functions[p10k] )) && [[ -r $_terminal_brew_prefix/share/powerlevel10k/powerlevel10k.zsh-theme ]]; then
  source "$_terminal_brew_prefix/share/powerlevel10k/powerlevel10k.zsh-theme"
fi
source "$_NIX_CONF_ZSH_DIR/.p10k.zsh"

# History and completion. The location follows XDG and is created automatically.
typeset -g HISTFILE=${XDG_DATA_HOME:-$HOME/.local/share}/zsh/history
command mkdir -p -- "${HISTFILE:h}"
HISTSIZE=100000
SAVEHIST=100000
unsetopt menu_complete flowcontrol
setopt prompt_subst always_to_end append_history auto_menu complete_in_word
setopt extended_history hist_expire_dups_first hist_ignore_dups hist_ignore_space
setopt hist_verify inc_append_history share_history

# This source uses the Macchiato FZF palette, even though Kitty uses Mocha.
export FZF_DEFAULT_OPTS='--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796'
export PI_SKIP_VERSION_CHECK=1
export EDITOR=nvim
export VISUAL=nvim

# Ctrl+l launches the file manager (Ctrl+a is intercepted by tmux inside tmux).
_portable_yazi_widget() { BUFFER=yazi; zle accept-line; }
zle -N _portable_yazi_widget
for _terminal_keymap in emacs viins; do
  bindkey -M "$_terminal_keymap" '^L' _portable_yazi_widget
  bindkey -M "$_terminal_keymap" '^A' beginning-of-line
  bindkey -M "$_terminal_keymap" '^E' end-of-line
done

# Aliases that do not reference the original author's directories or machines.
alias cls='clear' nv='nvim'
alias tml='tmux list-sessions' attach='tmux attach' att='tmux attach'
alias l='eza -lh --icons=auto' ls='eza -1 --icons=auto'
alias ll='eza -lha --icons=auto --sort=name --group-directories-first'
alias ld='eza -lhD --icons=auto' tree='eza --icons=auto --tree'
alias vc='code' nf='fastfetch'
# GNU tools preserve the flags and interactive behavior of the Linux original.
alias cp='gcp -iv' mv='gmv -iv' rm='grm -vI'
alias bc='bc -ql' mkd='mkdir -pv' grep='ggrep --color=always'
alias dk='docker' dku='docker-compose up -d' dkd='docker-compose down'
alias cmat='cmatrix -C magenta'
alias -g G='| grep'
alias -g UUID='$(uuidgen | tr -d "\n")'
alias lg="lazygit"

# trash-cli is keg-only on macOS; invoke it without changing the user's PATH.
tp() { "$_terminal_brew_prefix/opt/trash-cli/bin/trash-put" "$@"; }
tpr() { "$_terminal_brew_prefix/opt/trash-cli/bin/trash-restore" "$@"; }
pokemon() { "$_NIX_CONF_ZSH_DIR/../bin/pokego" --random 1-8 --no-title "$@"; }
tmux-sessionizer() { bash "$_NIX_CONF_ZSH_DIR/../tmux/scripts/tmux-sessionizer" "$@"; }

source "$_NIX_CONF_ZSH_DIR/functions.zsh"

if (( $+commands[direnv] )); then
  eval "$(command direnv hook zsh)"
fi
if [[ -r $_terminal_brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source "$_terminal_brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi
# Highlighting must load after widgets and other shell plugins.
if [[ -r $_terminal_brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source "$_terminal_brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
unset _terminal_keymap
