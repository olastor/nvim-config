
" ============
" | SETTINGS |
" ============

" mouse selection
set mouse=a

" use system clipboard
set clipboard=unnamedplus

" hybrid line numbers
set number relativenumber

"  no colors
" syntax off
" set nohlsearch
" set t_Co=0

"  soft tabs 2 spaces
set tabstop=2
set shiftwidth=2
set expandtab
set autoindent

"  leader key = space
let mapleader=" "

" easymotion highlight colors
hi link EasyMotionTarget Search
hi link EasyMotionTarget2First Search
hi link EasyMotionTarget2Second Search
hi link EasyMotionShade Comment

let g:ctrlp_custom_ignore = '\v[\/](\.(git|hg|svn)|node_modules)$'

syntax on
set t_Co=256
set cursorline

" coloring
"#set termguicolors     " enable true colors support
" let ayucolor="light"  " for light version of theme
if (has("termguicolors"))
  set termguicolors
endif

" airline configs
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='molokai'

let g:coq_settings = { 'auto_start': 'shut-up' }

"set completeopt=menu,menuone,noselect
augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end


" ==============
" | KEY COMBOS |
" ==============

" clear search highlight with escape
" nnoremap <esc> :noh<return><esc>

" shortcut exit
" fix, see  https://stackoverflow.com/a/7884226
silent !stty -ixon > /dev/null 2>/dev/null
nnoremap <C-q> <Esc>:q<CR>
inoremap <C-q> <Esc>:q<CR>

" shortcut save
nnoremap <C-s> <Esc>:w<CR>
inoremap <C-s> <Esc>:w<CR>

" shortcut save + exit
nnoremap <C-x> <Esc>:w<CR>:sus<CR>
inoremap <C-x> <Esc>:w<CR>:sus<CR>

" tabbing
nnoremap <C-n> <esc>:tabnew<CR>
inoremap <C-n> <esc>:tabnew<CR>

nnoremap <C-Right> <esc>:tabnext<CR>
inoremap <C-Right> <esc>:tabnext<CR>
nnoremap <C-Left> <esc>:tabprevious<CR>
inoremap <C-Left> <esc>:tabprevious<CR>


"nnoremap <leader>n :NERDTreeFocus<CR>
"nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NvimTreeToggl<CR>
"nnoremap <C-f> :NERDTreeFind<CR>

nnoremap <C-A-s> :tab vert Git<CR>
nnoremap <C-A-d> :Gvdiffsplit<CR>

"nnoremap <C-f> :CtrlSF
inoremap <C-f> <esc>:CtrlSF


" ===========
" | PLUGINS |
" ===========

call plug#begin('~/.vim/plugged')

" fancy start screen
Plug 'mhinz/vim-startify'

" quick navigation with leader + w or leader + b
Plug 'easymotion/vim-easymotion'

" nice search
Plug 'dyng/ctrlsf.vim'

" ctrl+p file search
Plug 'ctrlpvim/ctrlp.vim'

" file tree
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'

" fancy status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" git plugin
Plug 'tpope/vim-fugitive'

" language autocomplete
Plug 'neovim/nvim-lspconfig'
Plug 'ms-jpq/coq_nvim'
Plug 'ray-x/lsp_signature.nvim'

Plug 'pangloss/vim-javascript'
" Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'

" gcc toggle comments
Plug 'tpope/vim-commentary'

" auto close parentheses
Plug 'cohama/lexima.vim'

" auto close html tags
Plug 'alvan/vim-closetag'

" nice colorscheme
Plug 'arcticicestudio/nord-vim'

" Plug 'vim-scripts/project'
" Plug 'chrisbra/Colorizer'
" Plug 'tpope/vim-surround'
" Plug 'sonph/onehalf', { 'rtp': 'vim' }
call plug#end()

if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256          " Remove this line if not necessary
  source ~/.vimrc_background
endif

lua <<EOF
local lsp = require "lspconfig"
local coq = require "coq" -- add this

lsp.tsserver.setup{}
lsp.tsserver.setup(coq.lsp_ensure_capabilities{})
lsp.pylsp.setup{}
lsp.pylsp.setup(coq.lsp_ensure_capabilities{})

cfg = {}  -- add you config here
require "lsp_signature".setup(cfg)

require'nvim-tree'.setup()
EOF


command! DiffHistory call s:view_git_history()

function! s:view_git_history() abort
  Git difftool --name-only ! !^@
  call s:diff_current_quickfix_entry()
  " Bind <CR> for current quickfix window to properly set up diff split layout after selecting an item
  " There's probably a better way to map this without changing the window
  copen
  nnoremap <buffer> <CR> <CR><BAR>:call <sid>diff_current_quickfix_entry()<CR>
  wincmd p
endfunction

function s:diff_current_quickfix_entry() abort
  " Cleanup windows
  for window in getwininfo()
    if window.winnr !=? winnr() && bufname(window.bufnr) =~? '^fugitive:'
      exe 'bdelete' window.bufnr
    endif
  endfor
  cc
  call s:add_mappings()
  let qf = getqflist({'context': 0, 'idx': 0})
  if get(qf, 'idx') && type(get(qf, 'context')) == type({}) && type(get(qf.context, 'items')) == type([])
    let diff = get(qf.context.items[qf.idx - 1], 'diff', [])
    echom string(reverse(range(len(diff))))
    for i in reverse(range(len(diff)))
      exe (i ? 'leftabove' : 'rightbelow') 'vert diffsplit' fnameescape(diff[i].filename)
      call s:add_mappings()
    endfor
  endif
endfunction

function! s:add_mappings() abort
  nnoremap <buffer>]q :cnext <BAR> :call <sid>diff_current_quickfix_entry()<CR>
  nnoremap <buffer>[q :cprevious <BAR> :call <sid>diff_current_quickfix_entry()<CR>
  " Reset quickfix height. Sometimes it messes up after selecting another item
  11copen
  wincmd p
endfunction

colorscheme nord
nnoremap <C-f> :CtrlSF
