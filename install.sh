#!/bin/bash

NVIM_VERSION="v0.8.0"
INSTALL_DIR="$HOME/.nvim-binary"

# backup
cp "$HOME/.config/nvim/init.vim" "$HOME/.config/nvim/init.vim.bak.$(date --iso-8601=seconds)" 

if [[ -d "${INSTALL_DIR}" ]]; then
  rm -rf "${INSTALL_DIR}"
fi

cd /tmp
wget "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux64.tar.gz"
tar -xzvf nvim-linux64.tar.gz
rm -f nvim-linux64.tar.gz
mv nvim-linux64 "${INSTALL_DIR}"

ln -s "${INSTALL_DIR}/bin/nvim" "${HOME}/.local/bin/nvim" 
