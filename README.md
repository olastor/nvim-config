### install

todo: lsp server, vimplug cmd

```
git clone https://github.com/olastor/nvim-config ~/.config/nvim
# install vimplug
pip install python-lsp-server
sudo npm install -g typescript-language-server typescript
# font
https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/UbuntuMono.zip
unpack to ~/.fonts
clear cache fc-cache -f -v
'UbuntuMono Nerd Font Mono'
```

aliases
```
alias vim='nvim'
alias nvdiff='cd ~/.config/nvim && git diff'
alias nvpush='cd ~/.config/nvim && git add -A && git commit -m "update config" && git push'
alias nvpull='cd ~/.config/nvim && git pull'
```
