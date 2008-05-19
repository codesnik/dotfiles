
. ~/.aliases

if [[ `uname` = FreeBSD ]]; then
 . ~/.aliases.freebsd   
fi

if [[ -e .aliases.local ]] then  
 . ~/.aliases.local
fi

umask 002
export PATH=~/bin:/var/lib/gems/1.8/bin:$PATH

#export LANG=en_US.UTF-8
export VISUAL=vim
bindkey -e

export LESS='-R'
#export RI='-f ansi'

#if [[ $TERM == xterm ]]; then
  #export TERM=xterm-256color
#fi

export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.flac=01;35:*.mp3=01;35:*.mpc=01;35:*.ogg=01;35:*.wav=01;35:'


HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000


setopt auto_cd auto_pushd pushd_ignore_dups correct extended_glob numeric_glob_sort rc_quotes listpacked histignoredups noflowcontrol

# colors hash
autoload colors
colors

# cool renaming function
autoload -U zmv

prompt="%S%~%s%{$(printf '\e[37m')%} "
# green prompt - localhost, brown - remote host. just that.
if [[ $USER != codesnik ]] then
    user=$USER
fi
if [[ x$SSH_TTY != x ]]; then
  # remote host
  prompt="$user%{$fg[yellow]%}%15<...<%~%<<>%b "
else
  prompt="$user%{$fg[green]%}%15<...<%~%<<>%b "
fi


# func for putting text into title
function title {
  if [[ $TERM == "screen" ]]; then
    # Use these two for GNU Screen:
    print -nR $'\033k'$1$'\033'\\\

    print -nR $'\033]0;'$2$'\a'
  # elif [[ $TERM == "xterm" || $TERM == "rxvt" ]]; then
  elif [[ $TERM == "xterm" || $TERM == "xterm-256color" ]]; then 
    # Use this one instead for XTerms:
    if [[ x$SSH_TTY != x ]]; then
      print -nR $'\033]0;'$* @ `hostname`$'\a'
    else
      print -nR $'\033]0;'$*$'\a'
    fi
  fi
}
  
# put just path in terminal title
function precmd {
  #  title $(print -P '%~') @ `hostname`
  #else
    title $(print -P '%~')
  #fi
}

# put currently executed command in terminal title
function preexec {
  emulate -L zsh
  local -a cmd; cmd=(${(z)1})
  title $cmd[1]:t "$cmd[2,-1]"
}




# sometimes it closes ssh connection
# bindkey '^[[Z' reverse-menu-complete
clear
bindkey "^[^J" accept-and-infer-next-history

# thoose are my old completions

#zstyle ':completion:*' max-errors 2
#zstyle ':completion:*' menu yes select
zstyle ':completion:*' menu select
zstyle ':completion:*' select-prompt "$fg[yellow]Scrolling active: current selection at %p%s"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Use menuselection for pid completion
zstyle ':completion:*:*:fg:*' menu yes select
zstyle ':completion:*:*:bg:*' menu yes select
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:processes' command 'ps -au$USER -o pid,stat,tty,cmd'
# clever colors for it

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) #[^ ]# #[^ ]#(*)=2=32=0'

# fix for rake tasks with : in names
zstyle ':completion:*' matcher-list 'r:|[:]=*'

# --- end of completions

# The following lines were added by compinstall

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format "$fg[black]%d:$fg[white]"
zstyle ':completion:*' glob 1
zstyle ':completion:*' group-name ''
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' substitute 1
zstyle :compinstall filename '/home/codesnik/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
