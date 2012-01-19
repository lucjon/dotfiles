#!/bin/bash
#MAGIC_DOTFILES_BASHRC
# ^-- used by the install script; don't remove

## My bashrc extensions
## Assumes console width of 79
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
	ON_SSH=yes
else
	ON_SSH=no
fi


if [ "$NO_FUNKY_DISPLAY" != "yes" ] && ! [ -f ~/.no_funny_business ] || [ "$ON_SSH" == "yes" ]; then
	###### Little bits of config
	MB_VCS_EDITOR_NANO=yes
	######

	clear
	echo \n

	### PS1
	# Header row init
		# Move to top, print 160 spaces, move to top again
		MB_HEADER_IN="\[\e[s\e[2;0H\]"
	# Header row formatting
		MB_HEADER_FM="\[\e[1;7m\]"
	# Header row 1 content
		MB_HEADER_R1=""

		for x in {0..79}; do
			MB_HEADER_R1="${MB_HEADER_R1} "
		done
		MB_HEADER_R1="${MB_HEADER_R1}\[\e[2;0H\]\d,  \u@\H -> \[\e[44m\]\w\[\e[40m\]"
	# Header row 2 content
		MB_HEADER_R2=""
		for x in {0..79}; do
			MB_HEADER_R2="$MB_HEADER_R2 "
		done
		MB_HEADER_R2="${MB_HEADER_R2}\r\`uptime | cut -d, -f1\`  \`mb_r2_ex\`"
	# Header row deinit
		MB_HEADER_EN="\[\e[0m\e[u\]"
	# Header row
		MB_HEADER="${MB_HEADER_IN}${MB_HEADER_FM}${MB_HEADER_R1}\n${MB_HEADER_R2}${MB_HEADER_EN}\n"

	# Prompt formatting
		MB_PROMPT_FM="\[\e[1;33m\]"
	# Prompt contents
		MB_PROMPT_DT="\#/\!> "
	# Prompt deinit
		MB_PROMPT_EN="\[\e[0m\]"
	# Prompt
		MB_PROMPT="${MB_PROMPT_FM}\`mb_prompt_ex\`${MB_PROMPT_DT}${MB_PROMPT_EN}"

	# Clear hack for header row
		function clear {
			echo -ne "\e[2J\e[3;0H"
		}

	# PS1
		PS1="${MB_HEADER}${MB_PROMPT}"
		echo -ne "\e[s\e[0;0H(ok. shell: bash $BASH_VERSION); `fortune -s -n 45`\e[3;0H\e[u"
	# PROMPT_COMMAND
		PROMPT_COMMAND=mb_pcmd_ex

	# Prompt command
		function mb_pcmd_ex {
			# set xterm, etc. titles
			MB_TITLE="$USER@`hostname` -> `pwd`"
			# xterm
			echo -ne "\e]2;$MB_TITLE\007"

			# check for updates
			if [ -f ~/.dotfiles_updated ]; then
				echo -e "\e[1m(!) Updated dotfiles. You might want to restart bash.\e[0m"
				rm ~/.dotfiles_updated
			fi
		}

	# Prompt extended info function (ie, git repos ...)
		function mb_prompt_ex {
			# maybe a git repo?
			if [ -d ".git" ]; then
				echo -ne "(git:`git branch | head -n 1 | cut '-d ' -f2 2> /dev/null`/`git log -1 --pretty=format:%h 2> /dev/null`) "
			fi
			# how about mercurial
			if [ -d ".hg" ]; then
				echo -ne "(hg:`hg branch`) "
			fi
		}
	# Header row 2 extended info
		function mb_r2_ex {
			# git status
			if [ -d ".git" ]; then
				echo -n " [git: " `git log -1 "--pretty=format:%s, %ar" 2> /dev/null | cut -c1-45`...
			fi
		}
fi

### Console Font Setup
	# Ignore errors (ie, on a ptty)
	consolechars -f Lat15-Terminus14 2> /dev/null

### VCS Functions
	function mb_ingit {
		[ -d ".git" ];
	}
	function mb_inhg {
		[ -d ".hg" ];
	}
	function mb_inbzr {
		[ -d ".bzr" ];
	}

	function commit {
		if [ "$MB_VCS_EDITOR_NANO" == "yes" ]; then
			# vim seems to be a bit borked, ^C breaks everything
			# when not used directly from shell
			export EDITOR=nano
		fi

		if mb_ingit; then
			git commit -a
		elif mb_inhg; then
			hg add .
			hg commit
		elif mb_inbzr; then
			bzr add .
			bzr commit
		else
			echo "commit: did not find supported (hg, git, bzr) VCS in $PWD"
		fi
	}

### Misc Functions
	function s? {
		if [ "$?" == "0" ]; then
			echo "ok"
		else
			echo "fail ($?)"
		fi
	}

	function update_dotfiles {
		pushd . &> /dev/null
		cd ~/.dotfiles_dir

		OLD_HASH=`git log -1 "--pretty=format:%H" 2> /dev/null`
		git pull -q &> /dev/null
		NEW_HASH=`git log -1 "--pretty=format:%H" 2> /dev/null`

		if [ "$OLD_HASH" != "$NEW_HASH" ]; then
			touch ~/.dotfiles_updated
			./install
		fi

		popd &> /dev/null
	}

	function aod {
		CMD=`history | tail -n 2 | head -n 1 | sed -e 's/^[0-9 ]* //'`
		alias $1=$CMD
	}

	function keepalias {
		CMD=`alias $1 | cut -d= -f2-`
		echo "alias $1='$CMD'" >> ~/.dotfiles_dir/user-aliases
	}

### Aliases
	alias gpush="git push origin master"
	alias ..="cd ..; pwd"
	alias l="ls --color -F"
	alias ll="ls --color -Fl"
	alias la="ls --color -Fa"
	alias lla="ls --color -Fla"
	# vim seems to get a bit borked when called as vi
	alias vi=vim

	# load user aliases
	source ~/.dotfiles_dir/user-aliases


### Environment
	export DEVKITPRO="/opt/devkitpro"
	export DEVKITPPC="$DEVKITPRO/devkitPPC"
	export PATH="$PATH:$DEVKITPPC/bin:$HOME/bin:$HOME/.local/bin"

	if [ "$EDITOR" == "vi" ]; then
		export EDITOR=vim
	fi

	set -o vi

### Check for updates
	update_dotfiles &
