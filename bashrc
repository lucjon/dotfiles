#!/bin/bash

pushd . &> /dev/null
cd ~/.dotfiles_dir

# Automatically check for dotfiles updates
. bashrc.d/autoupdate
# Provides aliases for various VCS commands
. bashrc.d/vcs_alias
# Provides a fancy PS1 prompt
# test -f ~/.no_funny_business || . bashrc.d/ps1_prompt
test -f ~/.no_funny_business || . bashrc.d/powerline
# Use a nice console font
. bashrc.d/console_font
# Provides sensible aliases & environment
. bashrc.d/excommands
# Sets the appropriate environment for devkitPro
test -d /opt/devkitpro && . bashrc.d/devkitpro
# When running xmonad, do some X setup
if [ "$DESKTOP_SESSION" != "" ]; then
	( echo "$DESKTOP_SESSION" | grep xmonad ) && . bashrc.d/xmonad
fi
# If we're on Windows, set up PATH correctly
if [ -e /c/ ]; then
	. bashrc.d/windowspath
fi
# If we're on a vaguely recent version of Bash, source completion
if [ "${BASH_VERSINFO[0]}" -ge 4 ] && [ -f /usr/share/bash-completion/bash_completion ]; then
	. /usr/share/bash-completion/bash_completion
fi

popd &> /dev/null
