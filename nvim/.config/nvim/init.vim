" enables syntax highlighting
syntax on

" Better colors
set termguicolors

" number of spaces in a <Tab>
set tabstop=2
set softtabstop=2
set expandtab

" enable autoindents
set smartindent

" number of spaces used for autoindents
set shiftwidth=2

" adds line numbers
set number

" columns used for the line number
set numberwidth=4

" highlights the matched text pattern when searching
set incsearch
set nohlsearch

" open splits intuitively
set splitbelow
set splitright

" navigate buffers without losing unsaved work
set hidden

" start scrolling when 8 lines from top or bottom
" set scrolloff=8

" Save undo history
set undofile

" Enable mouse support
set mouse=a

" case insensitive search unless capital letters are used
set ignorecase
set smartcase

set clipboard+=unnamedplus

call plug#begin('~/.config/nvim/plugged')

Plug 'sainnhe/gruvbox-material'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-treesitter/nvim-treesitter'

Plug 'neovim/nvim-lspconfig'

Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'L3MON4D3/LuaSnip'
Plug 'onsails/lspkind-nvim'
Plug 'hrsh7th/cmp-buffer'

Plug 'rafamadriz/friendly-snippets'
Plug 'ray-x/lsp_signature.nvim'
Plug 'glepnir/lspsaga.nvim'

Plug 'neovim/nvim-lspconfig'
Plug 'github/copilot.vim'
Plug 'jose-elias-alvarez/null-ls.nvim'
call plug#end()
colorscheme gruvbox-material
lua require('chris')
nnoremap <Leader>w <C-w>

