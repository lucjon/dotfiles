@echo off
pushd
cd %~dp0

rem Set up links
rem we're using hard links/junctions so we don't need admin privs
rem of course, they need to be on the same FS now, what a shame
mklink /j %USERPROFILE%\.dotfiles_dir %CD%
mklink /h %USERPROFILE%\.bashrc %CD%\bashrc
mklink /h %APPDATA%\_emacs %CD%\emacs
mklink /j %USERPROFILE%\vimfiles %CD%\vim
mklink /h %USERPROFILE%\_vimrc %CD%\vimrc

rem Fetch the rest of the Git crap
git submodule init
git submodule update

popd
