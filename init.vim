" ============
" | SETTINGS |
" ============
"

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
" let g:airline_powerline_fonts = 1
" let g:airline#extensions#tabline#enabled = 1
" let g:airline_theme='molokai'
let g:lightline = {
      \ 'colorscheme': 'iceberg',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

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

" file search
nnoremap <C-p> <Esc>:FZF<CR>
inoremap <C-p> <Esc>:FZF<CR>

"nnoremap <leader>n :NERDTreeFocus<CR>
"nnoremap <C-n> :NERDTree<CR>
nnoremap <C-e> :NvimTreeToggle<CR>
nnoremap <C-t> :Ranger<CR>
"nnoremap <C-f> :NERDTreeFind<CR>


nnoremap <C-A-s> :tab vert Git<CR>
nnoremap <C-A-d> :Gvdiffsplit<CR>

nnoremap <C-g> :Grepper<CR>


" ===========
" | PLUGINS |
" ===========

call plug#begin('~/.vim/plugged')

" fancy start screen
Plug 'mhinz/vim-startify'

" quick navigation with leader + w or leader + b
Plug 'easymotion/vim-easymotion'

" nice search
" Plug 'dyng/ctrlsf.vim'
Plug 'mhinz/vim-grepper'

" ctrl+p file search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" file tree
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'

" fancy status bar
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
" Plug 'itchyny/lightline.vim'
Plug 'nvim-lualine/lualine.nvim'

" git plugin
Plug 'tpope/vim-fugitive'

" language autocomplete
" Plug 'neovim/nvim-lspconfig'
Plug 'neovim/nvim-lspconfig'
Plug 'glepnir/lspsaga.nvim', { 'branch': 'main', 'commit': 'c8bbcb598e5d63ce927d0f93d2f243532dd602c5' }
" Plug 'ms-jpq/coq_nvim'
" Plug 'ray-x/lsp_signature.nvim'

Plug 'pangloss/vim-javascript'
" Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'

" gcc toggle comments
Plug 'tpope/vim-commentary'

" git lense blamer
Plug 'APZelos/blamer.nvim'

" auto close parentheses
" Plug 'cohama/lexima.vim'
Plug 'tpope/vim-surround'

" auto close html tags
"Plug 'alvan/vim-closetag'

" better highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" nice colorschemes
" Plug 'arcticicestudio/nord-vim'
" Plug 'NLKNguyen/papercolor-theme'
Plug 'cocopon/iceberg.vim'

" show current scope 
" Plug 'SmiteshP/nvim-gps'

Plug 'francoiscabrol/ranger.vim'
Plug 'rbgrouleff/bclose.vim'

" Plug 'vim-scripts/project'
" Plug 'chrisbra/Colorizer'
" Plug 'sonph/onehalf', { 'rtp': 'vim' }

Plug 'akinsho/bufferline.nvim', { 'tag': 'v2.*' }


Plug 'hashivim/vim-terraform'
call plug#end()

" if filereadable(expand("~/.vimrc_background"))
"   let base16colorspace=256          " Remove this line if not necessary
"   source ~/.vimrc_background
" endif

lua <<EOF
local lsp = require "lspconfig"
-- local coq = require "coq" -- add this

lsp.tsserver.setup{}
lsp.pylsp.setup{}

-- cfg = {}  -- add you config here
-- require "lsp_signature".setup(cfg)

local saga = require 'lspsaga'

-- change the lsp symbol kind
-- local kind = require('lspsaga.lspkind')
-- kind[type_number][2] = icon -- see lua/lspsaga/lspkind.lua

-- use default config
saga.init_lsp_saga()

vim.opt.termguicolors = true
require("bufferline").setup {
  options = {
    offsets = {{filetype = "NvimTree", text = "File Explorer", text_align = "left"}}
  }
}

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "c", "lua", "svelte", "typescript", "vim", "yaml", "json", "bash", "bibtex", "dockerfile", "go", "hcl", "html", "javascript", "latex", "make", "markdown", "python" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  ignore_install = {  },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { "c", "rust" },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },

  autotag = {
    enable = true,
    filetypes = { "html" , "xml", "tsx" },
  }
}

require'nvim-tree'.setup {
  open_on_setup = true,
  open_on_setup_file = false,
  open_on_tab = true,
  focus_empty_on_setup = true,
  ignore_buffer_on_setup = true,
  git = {
    ignore = false
  }
}

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'iceberg',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = false,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = { 'filename' },
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}
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


" colorscheme based on time
" if strftime("%H") > 6 && strftime("%H") < 18
"   set background=light
" else
"   set background=dark
" endif

"set background=light " DOT_LIGHTTHEME=on
command Dark execute "set background=dark"
command Light execute "set background=light"

colorscheme iceberg


" do not hl current line
set cursorline!

let g:airline#extensions#wordcount#enabled = 0

command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number -- '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

