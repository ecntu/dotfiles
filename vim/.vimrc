" --- basics ---
set nocompatible
set encoding=utf-8
set fileformats=unix,dos,mac

" --- UI / ergonomics ---
set number            " line numbers
set relativenumber    " relative numbers for motions
set showcmd           " show (partial) command in status line
set wildmenu          " better command-line completion
set laststatus=2      " always show statusline
set ruler             " show cursor position
set showmatch         " highlight matching brackets
syntax on

" --- editing behavior ---
set expandtab         " spaces instead of tabs
set shiftwidth=2      " indent size
set tabstop=2         " visual tab size
set smartindent       " auto-indent on new lines
set autoindent
set wrap              " wrap long lines
set linebreak         " wrap at word boundaries
set backspace=indent,eol,start

" --- search ---
set ignorecase
set smartcase         " case-sensitive if caps used
set incsearch         " live incremental search
set hlsearch          " highlight search results

" --- performance / backups ---
set undofile          " persistent undo (needs a writable undodir)
set undodir=~/.vim/undo//
set swapfile          " you can :set noswapfile if you prefer
set updatetime=300    " faster CursorHold/autocomplete

" --- useful mappings ---
nnoremap <Space> <Nop>        " reserve Space as leader
let mapleader=" "
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>e :e %%<Left><Left> " edit file in current dir


" --- file-aware indentation ---
augroup filetypes
  autocmd!
  autocmd FileType javascript,typescript,tsx,jsx setlocal shiftwidth=2 tabstop=2
  autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=4
  autocmd FileType markdown,text setlocal wrap linebreak spell
augroup END
