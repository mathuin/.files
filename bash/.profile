# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# Prevent loops
export RUNNING_PROFILE=1

# if running bash
if [ -n "$BASH_VERSION" ]; then
    if [ -z "$RUNNING_BASHRC" ]; then
        if [ -f "$HOME/.bashrc" ]; then
            . "$HOME/.bashrc"
        fi
    fi
fi

# editor
export EDITOR=atom

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
export GOPATH=${HOME}/go
pathadd ${GOPATH}/bin

# Heroku toolbelt
pathadd /usr/local/heroku/bin

# Cask
pathadd ${HOME}/.cask/bin

# added by travis gem (possibly move to .bashrc)
[ -f ${HOME}/.travis/travis.sh ] && source ${HOME}/.travis/travis.sh

# github/hub (since it's in ${HOME}/bin)
if hash hub 2>/dev/null; then
    eval $(hub alias -s)
fi

# as per armiller 2015-Dec-16
if hash chef 2>/dev/null; then
    eval "$(chef shell-init bash)"
    pathadd /opt/kitchen/bin
fi

# pip install --user packages go here
pathadd ${HOME}/.local/bin
