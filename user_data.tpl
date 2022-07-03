#!/usr/bin/env bash

sudo apt-get update -y
sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo apt-get install -y build-essential neovim

cd /home/ubuntu

# Install Vim Plug
sh -c 'curl -fLo .local/share/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Download nvim config
curl --create-dirs -O --output-dir .config/nvim/ https://gist.githubusercontent.com/CDThomas/3532c223ee44383e991b3ee991df6866/raw/init.vim

cat <<EOF >> .bashrc

# Added by user_data in cloud init
set -o vi
EOF

chown -R ubuntu /home/ubuntu

# Install nvim packages
su - ubuntu -c 'nvim -es -u .config/nvim/init.vim -i NONE -c "PlugInstall" -c "qa"'
