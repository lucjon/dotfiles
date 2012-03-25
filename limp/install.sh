#!/bin/bash
# modified by LJ to only use sudo where appropriate, so $HOME
# points to the right place
VERSION=0.3.4
BASE=/usr/local/limp
LISP_FTP=$HOME/.vim/ftplugin/lisp


if [[ ! -d "$BASE" ]]; then
    sudo mkdir -p $BASE
    if [[ $? -gt 0 ]]; then
        echo
        echo "ERROR: Failed creating installation directory. Forgot 'sudo'?"
        exit 1
    fi
else
    sudo rm -rf $BASE/$VERSION
    sudo rm $BASE/latest
fi

echo "Installing Limp $VERSION to $BASE/$VERSION..."

sudo cp -fr $VERSION $BASE

echo "* symlink $BASE/$VERSION -> $BASE/latest"

sudo ln -sf $VERSION $BASE/latest

if [[ ! -d "$LISP_FTP" ]]; then
    mkdir -p $LISP_FTP
fi

echo "* symlink $LISP_FTP -> $BASE/latest"

rm $LISP_FTP/limp
ln -sf $BASE/latest/vim $LISP_FTP/limp
ln -sf limp/limp.vim $LISP_FTP/limp.vim

echo "* generating Lisp thesaurus..."

cd $BASE/$VERSION/bin
sudo ./make-thesaurus.sh

echo "Done."

