
. ~/.aliases

if [[ `uname` = FreeBSD ]]; then
 . ~/.aliases.freebsd   
fi

if [[ -e .aliases.local ]] then  
 . ~/.aliases.local
fi

# i like to be friendly to my friends
umask 002

export PATH=~/bin:/var/lib/gems/1.8/bin:$PATH

export FPATH=~/.zsh/func:$FPATH

#export LANG=en_US.UTF-8
export VISUAL=vim
bindkey -e

export LESS='-R'
#export RI='-f ansi'

#if [[ $TERM == xterm ]]; then
  #export TERM=xterm-256color
#fi

# GNU ls. maybe should be something other on freebsd
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.flac=01;35:*.mp3=01;35:*.mpc=01;35:*.ogg=01;35:*.wav=01;35:'


HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000


setopt auto_cd auto_pushd pushd_ignore_dups correct extended_glob numeric_glob_sort rc_quotes listpacked histignoredups noflowcontrol incappendhistory

# colors hash
autoload colors
colors

# cool renaming function
autoload -U zmv

# green prompt - localhost, brown - remote host. just that.

#branch=`git-branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'`
if [[ $USER != codesnik ]] then
    user=$USER
fi
if [[ x$SSH_TTY != x ]]; then
  # remote host
  user="$user@`uname -n`"
fi
if [[ x$user != x ]]; then
  prompt="%{$fg[cyan]%}$user:%{$fg[yellow]%}%15<...<%~%<<>%b "
else
  prompt="%{$fg[green]%}%15<...<%~%<<>%b "
fi

# func for putting text into title
function title {
  if [[ $TERM == "screen" ]]; then
    # Use these two for GNU Screen:
    print -nR $'\033k'$1$'\033'\\\
    print -nR $'\033]0;'$2$'\a'
  elif [[ $TERM == "xterm" || $TERM == "xterm-256color" ]]; then 
    print -nR $'\033]0;'$*$'\a'
  fi
}
  
# puts @ somehost after title, if it is something over SSH
function title_with_host {
  if [[ x$SSH_TTY != x ]]; then
    title "$* @ `hostname`"
  else
    title "$*"
  fi
}
# put just path in terminal title
function precmd {
  title_with_host $(print -P '%~')
}

# put currently executed command in terminal title
function preexec {
  emulate -L zsh
  local -a cmd; cmd=(${(z)1})
  title_with_host $cmd[1]:t "$cmd[2,-1]"
}




# sometimes it closes ssh connection
# bindkey '^[[Z' reverse-menu-complete
#clear
bindkey "^[^J" accept-and-infer-next-history
bindkey "^[p" history-beginning-search-backward
bindkey "^[n" history-beginning-search-forward

autoload -U select-word-style
select-word-style shell

autoload -U edit-command-line
zle -N edit-command-line
# thoose are my old completions

#zstyle ':completion:*' max-errors 2
#zstyle ':completion:*' menu yes select
zstyle ':completion:*' menu select
# показывать меню для более чем одного варианта комплишна
zstyle ':completion:*' force-list 2 
zstyle ':completion:*' last-prompt yes
zstyle ':completion:*' select-prompt "$fg[yellow]Scrolling active: current selection at %p%s"
# цвета для файлов
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Use menuselection for pid completion
zstyle ':completion:*:*:fg:*' menu yes select
zstyle ':completion:*:*:bg:*' menu yes select
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:processes' command 'ps -au$USER -o pid,stat,tty,cmd'
# clever colors for it
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) #[^ ]# #[^ ]#(*)=2=32=0'

# treat . and : in completed words just as like / in dirs - expand them
# fix for rake tasks with : in names
# also allows for c/e.<tab> expanded to config/environment.rb
zstyle ':completion:*' matcher-list 'r:|[.:-]=*'



zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _complete _expand 
zstyle ':completion:*' format "$fg_bold[black]%d:$fg[white]"
zstyle ':completion:*' glob yes
# show all completion group names when completing
zstyle ':completion:*' group-name ''
#zstyle ':completion:*' insert-unambiguous yes
#zstyle ':completion:*' substitute yes # default
#zstyle ':completion:*' show-completer yes
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
#
#

# NEW
dirname-previous-word () {
    autoload -U modify-current-argument
    modify-current-argument '${ARG:h}/'
}

zle -N dirname-previous-word
bindkey '^[q' dirname-previous-word

# one more:

# show mode
#function zle-line-init zle-keymap-select {
#    RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
#    RPS2=$RPS1
#    zle reset-prompt
#}
#zle -N zle-line-init
#zle -N zle-keymap-select

# END OF NEW


gemdoc() {
  export GEMDIR=`gem env gemdir`
  firefox  $GEMDIR/doc/`ls $GEMDIR/doc | grep $1 | sort | tail -1`/rdoc/index.html
}
