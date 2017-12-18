" This must be first, because it changes other options as side effect
set nocompatible

" To make compatible with vundle
filetype off

" Use pathogen to easily modify the runtime path to include all
" plugins under the ~/.vim/bundle directory
call pathogen#helptags()
call pathogen#infect()

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Plugin 'gmarik/vundle'
Plugin 'JuliaEditorSupport/julia-vim'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'Valloric/YouCompleteMe'

" Debugging for YCM Plugin
let g:ycm_server_keep_logfiles = 1
let g:ycm_server_log_level = 'debug'

" Apparently necessary for vundle
filetype plugin on

" This will produce a headerguard name relative to CWD.
function! g:HeaderguardName()
    return toupper(expand('%:.:gs/[^0-9a-zA-Z_]/_/g')) . '_'
endfunction

" Insert header guards for .h/.hpp files.
function! s:insert_gates()
  let gatename = g:HeaderguardName()
  execute "normal! i#ifndef " . gatename
  execute "normal! o#define " . gatename . " "
  execute "normal! Go#endif  // " . gatename
  normal! kk
endfunction

" Map header guards to insert on file creation.
autocmd BufNewFile *.{h,hpp} call <SID>insert_gates()

" Allows quick editing of .vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

:imap jk <Esc>

" Can't stand that default 8-spaces
set tabstop=2
" Auto indenting should match tab...
set shiftwidth=2
" Turn all tabs into spaces.
set expandtab

" Backspace all day erryday
set backspace=indent,eol,start

" Because I hate indenting code myself
set autoindent
set copyindent
set smartindent

" Need 'dem line numbers
set number

" Got to see them pairs
set showmatch

" Searching with sanity
set hlsearch
set incsearch
set ignorecase
set smartcase

" Increase undo history
set history=100
set undolevels=100

" Ignore compiled files
set wildignore=*.o,*~,*.pyc

" Take away those annoying bells!
set noerrorbells
set novisualbell

" Remove all the annoying temp files!
set nobackup
set nowb
set noswapfile

" For better code pasting.
" Vim assumes a paste is a fast text input, so indentation can be off
set pastetoggle=<F2>

" Remove the need to use : for commands, use ; to avoid the <Shift>
nnoremap ; :

" Don't let me get too low or too high!
set scrolloff=4

" Show tabs as another character.
" set listchars=tab:>-
" set list

" Set Python indenting to 4 spaces.
autocmd FileType python setlocal shiftwidth=2 tabstop=2

" Syntax Highlighting
syntax enable
set background=dark
colorscheme solarized

" Draw line at 80 character limit
let &colorcolumn=join(range(81,999),",")
let &colorcolumn="80,".join(range(400,999),",")

" Better split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Capture mouse scroll events (don't let tmux take hostage!)
set mouse=a

" Reload files that are changed on file system (useful for git branches)
set autoread
