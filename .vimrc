" ============================================================================
" Vim Configuration
" Modernized setup with vim-plug and coc.nvim
" ============================================================================

" This must be first, because it changes other options as side effect
set nocompatible

" ============================================================================
" vim-plug Setup
" ============================================================================

" Auto-install vim-plug if not present
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Intellisense engine
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Tmux integration
Plug 'christoomey/vim-tmux-navigator'

" Julia support
Plug 'JuliaEditorSupport/julia-vim'

call plug#end()

" ============================================================================
" General Settings
" ============================================================================

filetype plugin indent on
syntax enable

" Line numbers
set number

" Show matching brackets
set showmatch

" Searching with sanity
set hlsearch
set incsearch
set ignorecase
set smartcase

" Indentation (2 spaces)
set autoindent
set copyindent
set smartindent
set expandtab
set tabstop=2
set shiftwidth=2

" Backspace all day erryday
set backspace=indent,eol,start

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

" For better code pasting
set pastetoggle=<F2>

" Don't let me get too low or too high!
set scrolloff=4

" Reload files that are changed on file system
set autoread

" Capture mouse scroll events
set mouse=a

" Better display for messages
set cmdheight=2

" Update time for better experience
set updatetime=300

" Always show signcolumn
set signcolumn=yes

" ============================================================================
" Color Scheme
" ============================================================================

set background=dark

" Use Solarized if available, otherwise use default
silent! colorscheme solarized

" Draw line at 80 character limit
let &colorcolumn=join(range(81,999),",")
let &colorcolumn="80,".join(range(400,999),",")

" ============================================================================
" coc.nvim Configuration
" ============================================================================

" Use tab for trigger completion with characters ahead and navigate
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion
inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight symbol under cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Apply AutoFix to problem on current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>

" ============================================================================
" Key Mappings
" ============================================================================

" Leader key
let mapleader = ","

" Allows quick editing of .vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" Quick escape from insert mode
imap jk <Esc>

" Remove the need to use : for commands, use ; to avoid the <Shift>
nnoremap ; :

" Better split navigation (works with vim-tmux-navigator)
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" ============================================================================
" Auto Commands
" ============================================================================

" This will produce a headerguard name relative to CWD
function! g:HeaderguardName()
    return toupper(expand('%:.:gs/[^0-9a-zA-Z_]/_/g')) . '_'
endfunction

" Insert header guards for .h/.hpp files
function! s:insert_gates()
  let gatename = g:HeaderguardName()
  execute "normal! i#ifndef " . gatename
  execute "normal! o#define " . gatename . " "
  execute "normal! Go#endif  // " . gatename
  normal! kk
endfunction

" Map header guards to insert on file creation
autocmd BufNewFile *.{h,hpp} call <SID>insert_gates()

" Set Python indenting to 2 spaces
autocmd FileType python setlocal shiftwidth=2 tabstop=2
