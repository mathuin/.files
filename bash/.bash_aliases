# ~/.bash_aliases

# VNC
alias vncclean='rm /tmp/.X3-lock /tmp/.X11-unix/X3'
#alias vnccyan='vncserver -geometry 1280x968 :3'
# should be 1276x985
alias vnccyan='vncserver -geometry 1274x983 :3'
alias vncaurora='vncserver -geometry 1366x768 :3'

# gmrhc
alias gmrhc='/home/jmt/git/brutal-chaos/GMRHC/dist/build/GMRHC/GMRHC --key YUQWJY4TKXE3'

# making pictures for pyment
gen_mead_images() {
    if [ -z "$1" ]; then
	exit
    fi
    if [ -e originals ]; then
	for letter in A B C; do
	    sipfile=`echo "SIP $1 $letter.jpg" | sed -e "s/ /\\\ /"`
	    (IFS=$'\n';
	    convert originals/$sipfile -resize 300x400 main/$sipfile;
	    convert originals/$sipfile -resize 100x133 thumbnails/$sipfile)
	done
    fi
}

# sigh
alias fig=docker-compose

# git!
alias resync="git fetch upstream && git checkout master && git merge upstream/master && git push"

# spacebase dev
alias sbupdate="./packaging/linux_install.sh restore && ./packaging/linux_install.sh"

# driver hell
alias console='sudo cp /etc/default/grub.console /etc/default/grub && sudo update-grub && sudo reboot'

alias gui='sudo cp /etc/default/grub.gui /etc/default/grub && sudo update-grub && sudo reboot'
