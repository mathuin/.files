# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# editor
export EDITOR=emacs

# git-prompt variables
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="auto"
export GIT_PS1_DESCRIBE_STYLE="branch"
export GIT_PS1_SHOWCOLORHINTS=1
export PROMPT_COMMAND='__git_ps1'

export PATH

# http://superuser.com/questions/39751/add-directory-to-path-if-its-not-already-there
pathadd() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="${PATH:+"$PATH:"}$1"
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
pathadd ${HOME}/bin

# Android
export ADT=/home/jmt/android-studio
for newpath in ${ADT}/bin ${ADT}/sdk/tools ${ADT}/sdk/platform-tools; do
    pathadd $newpath
done

# CUDA
pathadd /usr/local/cuda-5.0/bin

# Go
# JMT: GOMAXPROCS not needed with Go 1.5.1
#export GOMAXPROCS=16
export GOROOT=/usr/local/go
pathadd ${GOROOT}/bin
export GOPATH=/home/jmt/gopath
pathadd ${GOPATH}/bin

# Heroku toolbelt
pathadd /usr/local/heroku/bin

# Cask
pathadd ${HOME}/.cask/bin

# added by travis gem (possibly move to .bashrc)
[ -f /home/jmt/.travis/travis.sh ] && source /home/jmt/.travis/travis.sh

# github/hub (since it's in ${HOME}/bin)
if hash hub 2>/dev/null; then
    $(hub alias -s)
fi
