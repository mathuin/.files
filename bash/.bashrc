# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Prevent loops
RUNNING_BASHRC=1

# If .profile has not yet been called, call it.
if [ -z "$RUNNING_PROFILE" ]; then
    if [ -f "$HOME/.profile" ]; then
	. "$HOME/.profile"
    fi
fi

# taken from .profile

# editor
if [ "$DISPLAY" ]; then
    export EDITOR="atom --wait"
else
    export EDITOR=vi
fi

# python virtualenvs
export WORKON_HOME=~/.virtualenvs

# git-prompt variables
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="auto"
export GIT_PS1_DESCRIBE_STYLE="branch"
export GIT_PS1_SHOWCOLORHINTS=1
if [ `type -t __git_ps1 | wc -l` -gt 0 ]; then
    : # export PROMPT_COMMAND='__git_ps1'
fi

export PATH

# http://superuser.com/questions/39751/add-directory-to-path-if-its-not-already-there
pathadd() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="${PATH:+"$PATH:"}$1"
    fi
}

pathpre() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="$1:${PATH}"
    fi
}

pathclean() {
    entries=$(echo $PATH | tr ":" " ")
    PATH=
    for entry in $entries; do
	pathadd $entry
    done
}

pathclean

# set PATH so it includes user's private bin if it exists
pathpre ${HOME}/bin

# pip install --user packages go here
pathpre ${HOME}/.local/bin

# local NPM stuff goes here
pathpre ${HOME}/node_modules/.bin

# local Ruby stuff goes here
if command -v rbenv >/dev/null; then
    pathpre ${HOME}/.rbenv/bin
    eval "$(rbenv init -)"
    pathpre ${HOME}/.rbenv/plugins/ruby-build/bin
fi

# Android
export ADT=/home/jmt/android-studio
for newpath in ${ADT}/bin ${ADT}/sdk/tools ${ADT}/sdk/platform-tools; do
    pathadd $newpath
done

# CUDA
pathadd /usr/local/cuda-5.0/bin

# Go
export GOPATH=${HOME}/go
pathadd ${GOPATH}/bin
pathpre /usr/local/go/bin

# Heroku toolbelt
pathadd /usr/local/heroku/bin

# Cask
pathadd ${HOME}/.cask/bin

# added by travis gem (possibly move to .bashrc)
[ -f ${HOME}/.travis/travis.sh ] && source ${HOME}/.travis/travis.sh

# github/hub (since it's in ${HOME}/bin)
if hash hub 2>/dev/null; then
    eval "$(hub alias -s)"
fi

# as per armiller 2015-Dec-16
# if hash chef 2>/dev/null; then
#     eval "$(chef shell-init bash)"
#     pathadd /opt/kitchen/bin
# fi

# end .profile

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    # Prompt color codes
    COLOR_DEFAULT="\[\e[0m\]"
    COLOR_BLACK="\[\e[0;30m\]"
    COLOR_BLUE="\[\e[0;34m\]"
    COLOR_GREEN="\[\e[0;32m\]"
    COLOR_CYAN="\[\e[0;36m\]"
    COLOR_RED="\[\e[0;31m\]"
    COLOR_PURPLE="\[\e[0;35m\]"
    COLOR_BROWN="\[\e[0;33m\]"
    COLOR_GRAY="\[\e[0;37m\]"
    COLOR_DARK_GRAY="\[\e[1;30m\]"
    COLOR_L_BLUE="\[\e[1;34m\]"
    COLOR_L_GREEN="\[\e[1;32m\]"
    COLOR_L_CYAN="\[\e[1;36m\]"
    COLOR_L_RED="\[\e[1;31m\]"
    COLOR_L_PURPLE="\[\e[1;35m\]"
    COLOR_YELLOW="\[\e[1;33m\]"
    COLOR_WHITE="\[\e[1;37m\]"
else
    COLOR_DEFAULT=""
    COLOR_BLACK=""
    COLOR_BLUE=""
    COLOR_GREEN=""
    COLOR_CYAN=""
    COLOR_RED=""
    COLOR_PURPLE=""
    COLOR_BROWN=""
    COLOR_GRAY=""
    COLOR_DARK_GRAY=""
    COLOR_L_BLUE=""
    COLOR_L_GREEN=""
    COLOR_L_CYAN=""
    COLOR_L_RED=""
    COLOR_L_PURPLE=""
    COLOR_YELLOW=""
    COLOR_WHITE=""
fi

# Prompts can have colors embedded, as they will be ignored if not supported.
git_ps1()
{
    if [ `type -t __git_ps1 | wc -l` -gt 0 ]; then
        __git_ps1 '(%s) '
    fi
}

__machine_ps1()
{
    local format=${1:- [%s]}
    if test ${DOCKER_MACHINE_NAME}; then
	local status=$(docker-machine status ${DOCKER_MACHINE_NAME})
	case ${status} in
	    Running)
		status=' R'
		;;
	    Stopping)
		status=' R->S'
		;;
	    Starting)
		status=' S->R'
		;;
	    Error|Timeout)
		status=' E'
		;;
	    *)
		# everything else is stopped
		status=' S'
		;;
	esac
	printf -- "${format}" "${DOCKER_MACHINE_NAME}${status}"
    fi
}

machine_ps1()
{
    __machine_ps1 '[%s] '
}

PS1="${COLOR_L_RED}\$(machine_ps1)${COLOR_L_PURPLE}\$(git_ps1)${COLOR_L_GREEN}\u@\h${COLOR_DEFAULT}:${COLOR_L_BLUE}\w${COLOR_DEFAULT}\$ "

unset color_prompt force_color_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# keychain fun
# keychain_add_dir expects one argument: the name of a directory in ~/.ssh with keys
keychain_add_dir() {
    if hash keychain 2>/dev/null; then
        KEYDIR="${HOME}/.ssh/$1"
        if [ -d ${KEYDIR} ]; then
            KEYS=`find ${HOME}/.ssh/$1 \( -name "*_id_rsa" -o -name "*_id_dsa" \) -print | xargs echo`
            eval `keychain --eval ${KEYS}`
        fi
    fi
}
KEYCHAIN_DIRFILE="${HOME}/.ssh/keychain-list"
if hash keychain 2>/dev/null; then
    KEYCHAIN_DIRS="."
    if [ -f ${KEYCHAIN_DIRFILE} ]; then
        KEYCHAIN_DIRS=`xargs echo < ${KEYCHAIN_DIRFILE}`
    fi
    for dir in ${KEYCHAIN_DIRS}; do
        keychain_add_dir $dir
    done
fi

function fsh () {
    ssh -t fir "sudo bash -i -c \"ssh $@\""
}

# run arandr if necessary
if [ "$DISPLAY" ]; then
    LAYOUTDIR="${HOME}/.screenlayout"
    if [ -d "${LAYOUTDIR}" ]; then
        HOST=`hostname`
        LAYOUT="${LAYOUTDIR}/${HOST}.sh"
        if [ -e "${LAYOUT}" ]; then
            . ${LAYOUT}
        fi
    fi
fi

HASTE_SERVER=https://hastebin.twilley.org/
haste () {
    local output returnfile contents server docs
    if [ -z ${HASTE_SERVER+x} ]; then
	server="http://hastebin.com/"
    else
	server=$HASTE_SERVER
    fi
    server=$(echo $server | sed -e "s|/$||")
    docs=${server}/documents
    if (( $# == 0 )) && [[ $(printf "%s" "$0" | wc -c) > 0 ]]
    then
	contents=$0
    elif (( $# != 1 )) || [[ $1 =~ ^(-h|--help)$ ]]
    then
	echo "Usage: $0 FILE"
	echo "Upload contents of plaintext document to hastebin."
	echo "\nInvocation with no arguments takes input from stdin or pipe."
	echo "Terminate stdin by EOF (Ctrl-D)."
	return 1
    elif [[ -e $1 && ! -f $1 ]]
    then
	echo "Error: Not a regular file."
	return 1
    elif [[ ! -e $1 ]]
    then
	echo "Error: No such file."
	return 1
    elif (( $(stat -c %s $1) > (512*1024**1) ))
    then
	echo "Error: File must be smaller than 512 KiB."
	return 1
    fi
    if [[ -n "$contents" ]] || [[ $(printf "%s" "$contents" | wc -c) < 1 ]]
    then
	contents=$(cat $1)
    fi
    result=$(curl -# -sf --data-binary @${1:--} ${docs}) || {
	echo "ERROR: failed to post document >&2"
	return 1
    }
    key=$(echo $result | jq -r .key)
    echo ${server}/${key}
}

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/jmt/.sdkman"
[[ -s "/home/jmt/.sdkman/bin/sdkman-init.sh" ]] && source "/home/jmt/.sdkman/bin/sdkman-init.sh"
