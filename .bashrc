# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
export EDITOR=vim
export BUILD_COLORS=1
#alias moshmouse="perl -E ' print \"\e[?1005h\e[?1002h\" ' && mosh" 



[ -f ~/.fzf.bash ] && source ~/.fzf.bash
