#!/bin/bash

set -eux

# get generic development tools
dnf groupinstall "Development Tools" -y

# install pyenv
curl https://pyenv.run | bash

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(pyenv init -)"' >> ~/.bash_profilepy  py

# install OS java jdk
dnf install java-11-openjdk java-17-openjdk java-21-openjdk -y
