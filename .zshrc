setopt extended_glob
# zmodload zsh/zprof
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export NLS_LANG="$LANG"

## Homebrew

export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1

export PATH="/opt/homebrew/opt/icu4c@77/bin:$PATH"
export PATH="/opt/homebrew/opt/icu4c@77/sbin:$PATH"

## Ruby

#export RBENV_ROOT=~/.rbenv
#if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# for keeping openssl upgraded by homebrew
#export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"

export DISABLE_SIMPLECOV=true
export DISABLE_SPRING=yes

. /opt/homebrew/opt/asdf/libexec/asdf.sh

## Docker

# export DOCKER_HOST="${DOCKER_HOST:=tcp://127.0.0.1:2375}"

## nodejs

#export NVM_DIR="$HOME/.nvm"
#alias loadnvm=". $NVM_DIR/nvm.sh"
#loadnvm

# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

## Haskell

# [ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" # ghcup-env
# export HUSKY_SKIP_INSTALL=1

## Postgres

export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"

## Elixir

#export ELIXIR_EDITOR="open -a Terminal 'vim +__LINE__ __FILE__'"
export ELIXIR_EDITOR='osascript -e '\''tell application "iTerm2"
  tell current window
  create tab with default profile command "vim +__LINE__ __FILE__"
  end tell)
end tell'\'

export ERL_AFLAGS="-kernel shell_history enabled"

## Android

export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH"

## python

#---------------------------------------------- chpwd pyvenv ---
python_venv() {
  MYVENV=../.env
  # when you cd into a folder that contains $MYVENV
  [[ -d $MYVENV ]] && source $MYVENV/bin/activate > /dev/null 2>&1
  # when you cd into a folder that doesn't
  [[ ! -d $MYVENV ]] && deactivate > /dev/null 2>&1
}
autoload -U add-zsh-hook
add-zsh-hook chpwd python_venv

python_venv

# Load pyenv automatically by appending
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init -)"

## Java

#export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
#export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"

## Perl

PATH="$HOME/.perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="$HOME/.perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="$HOME/.perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"$HOME/.perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=$HOME/.perl5"; export PERL_MM_OPT;

## Go

export GOPATH="$HOME/.go"

## zsh

dirname-previous-word () {
    autoload -U modify-current-argument
    modify-current-argument '${ARG:h}/'
}
zle -N dirname-previous-word
bindkey "\e-" dirname-previous-word

bindkey "\e^J" accept-and-infer-next-history
bindkey "\ep" history-beginning-search-backward
bindkey "\en" history-beginning-search-forward
bindkey -s "\el" "\eqls^J"
bindkey -s "\eg" "\eqgit status^J"

bindkey '^]' vi-find-next-char
bindkey "\e^]" vi-find-prev-char
bindkey "\e " set-mark-command

# done by omz
# autoload -U edit-command-line
# zle -N edit-command-line

# word boundary on spaces
autoload -U select-word-style
select-word-style shell

# M-H to open help on builtins too
(( $+aliases[run-help] )) && unalias run-help
autoload -Uz run-help

test -e "${HOME}/.ilerm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# autoload -U compinit compdef
# for dump in ~/.zcompdump(N.mh+24); do
#   compinit
# done
# compinit -C

autoload -U zmv
alias mmv='noglob zmv -W'

## oh-my-zsh

# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
export ZSH_THEME="codesnik"

export EDITOR=nvim
export ACK_PAGER_COLOR='less -R'
export PAGER='less -RS'

# Set to this to use case-sensitive completion
# export CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
export DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# export DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# export DISABLE_AUTO_TITLE="true"

export APPLE_SSH_ADD_BEHAVIOR=macos

# export LSCOLORS=BxGxcxdxCxegedabagacad
# use GNU ls
zstyle ':omz:lib:theme-and-appearance' gnu-ls yes

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
# npm ansible mix vi-mode
plugins=(
  brew
  asdf
  gem
  ruby
  rails
  bundler
  docker
  fzf
  mix-fast
  fancy-ctrl-z
  aliases
  colored-man-pages
  colorize
  dash
  thefuck
  npm
  yarn
  httpie
)

source $ZSH/oh-my-zsh.sh

export PATH="$HOME/.local/bin:$PATH"

if [[ -s ~/.aliases ]] ; then source ~/.aliases ; fi
if [[ -s ~/.api ]] ; then source ~/.api ; fi

#zprof
