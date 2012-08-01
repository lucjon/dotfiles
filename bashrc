#!/bin/bash

pushd .
cd ~/.dotfiles_dir

# Automatically check for dotfiles updates
. bashrc.d/autoupdate
# Provides aliases for various VCS commands
. bashrc.d/vcs_alias
# Provides a fancy PS1 prompt
-f ~/.no_funny_business || . bashrc.d/ps1_prompt
# Use a nice console font
. bashrc.d/console_font
# Provides sensible aliases & environment
. bashrc.d/excommands
# Sets the appropriate environment for devkitPro
-d /opt/devkitpro && . bashrc.d/devkitpro
# When running xmonad, do some X setup
grep xmonad "$DESKTOP_SESSION" && . bashrc.d/xmonad

popd
