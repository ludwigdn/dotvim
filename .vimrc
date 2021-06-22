
" Autoinstall PLUG if not installed --------------------------------------------------------------
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


" Plugins ----------------------------------------------------------------------------------------
call plug#begin('~/.vim/plugged')
  Plug 'gruvbox-community/gruvbox'
  Plug 'preservim/nerdtree'
  Plug 'dense-analysis/ale'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'tpope/vim-fugitive'
  Plug 'leafgarland/typescript-vim'
  Plug 'peitalin/vim-jsx-typescript'
  Plug 'tpope/vim-rhubarb'
call plug#end()

" Plugins dependencies
" - Silver Searcher (https://github.com/ggreer/the_silver_searcher#installing)
" - Ripgrep (https://github.com/BurntSushi/ripgrep#installation)

" coc extensions:
" https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions
" :CocInstall coc-json coc-tsserver
" :CocInstall coc-html coc-css
" :CocInstall coc-vetur
" :CocInstall coc-omnisharp


" Set --------------------------------------------------------------------------------------------
set relativenumber
set nu
set nowrap
set linebreak
set exrc
set belloff=all
set guicursor=
set scrolloff=10
set nohlsearch
set hidden
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set hlsearch
set cmdheight=2
"set colorcolumn=82
set signcolumn=yes
let g:NERDTreeShowHidden=1

" Folding
set nofoldenable
set foldmethod=indent
set foldlevel=20
set foldclose=all

" Autocompletion
filetype plugin on
set omnifunc=syntaxcomplete#Complete

" Use filetype detection and file-based automatic indenting
filetype plugin indent on
set tabstop=2
set shiftwidth=2
set expandtab
set smartindent

" Prevent freeze on large ts files because of syntax highlighting
" (source: https://jameschambers.co.uk/vim-typescript-slow)
syntax on
set re=0


" Colors -----------------------------------------------------------------------------------------
set t_Co=256
colorscheme gruvbox
set background=dark


" Status line ------------------------------------------------------------------------------------
set statusline=
set statusline+=%#PmenuSel#
set statusline+=%{(FugitiveStatusline())}
set statusline+=%#LineNr#
set statusline+=\ %f
set statusline+=%m\
set statusline+=%=
set statusline+=%#CursorColumn#
" set statusline+=\ %y
" set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
" set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\


" Ale lintera-------------------------------------------------------------------------------------
let g:ale_sign_error = '●'
let g:ale_sign_warning = '.'
let g:ale_lint_on_save = 1


" Functions --------------------------------------------------------------------------------------

" Highlight all instances of word under cursor, when idle Type z/ to toggle
nnoremap z/ :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
function! AutoHighlightToggle()
  let @/ = ''
  if exists('#auto_highlight')
    au! auto_highlight
    augroup! auto_highlight
    setl updatetime=50
    echo 'Highlight current word: off'
    return 0
  else
    augroup auto_highlight
      au!
      au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
    augroup end
    setl updatetime=50
    echo 'Highlight current word: ON'
    return 1
  endif
endfunction

" Well, the name is explicit
fun! TrimWhitespace()
	let l:save = winsaveview()
	keeppatterns %s/\s\+$//e
	call winrestview(l:save)
endfun


" Auto commands ---------------------------------------------------------------------------------
augroup MyCustomAutoGroup
    autocmd!
    autocmd StdinReadPre * let s:std_in=1
    " Use actual tab chars in Makefiles.
    autocmd FileType make set tabstop=8 shiftwidth=8 softtabstop=0 noexpandtab
    " Start NERDTree when Vim starts with a file argument.
    autocmd VimEnter * if argc() > 0 || exists("s:std_in") | NERDTree | wincmd p | endif
    " Start NERDTree when Vim starts with a directory argument.
    autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') | execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0]  | endif
    " Exit Vim if NERDTree is the only window left.
    autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
    " call function to auto-trim whitespaces at end of lines
    autocmd BufWritePre * :call TrimWhitespace()
    " This sets the file formats to unix, avoiding ^M errors when coming from dos
    autocmd BufWritePre * :set fileformat=unix
  	" Auto source .vimrc file at saving
  	autocmd BufWritePost .vimrc :so %
augroup END


" Remaps -----------------------------------------------------------------------------------------
let mapleader = "\<space>"

" Shortcut to Git Browse
map <leader>gb :GBrowse<CR>

" Inner terminal shortcut
" map <leader>t :terminal<CR>

" Reveal current file in NERDTree
nnoremap <leader>nf :NERDTreeFind<CR>
nnoremap <leader>nt :NERDTreeToggle<CR>

" Switch between windows more easily
nnoremap <C-h> :wincmd h<CR>
nnoremap <C-j> :wincmd j<CR>
nnoremap <C-k> :wincmd k<CR>
nnoremap <C-l> :wincmd l<CR>

" Move to previous/next buffer
nnoremap <leader>j :bnext<CR>:NERDTreeFind<CR><c-w><c-p>
nnoremap <leader>k :bprev<CR>:NERDTreeFind<CR><c-w><c-p>

" Move to previous/next tab
nnoremap <leader>h :tabp<CR>
nnoremap <leader>l :tabn<CR>

" Quickfixlist shortcuts
nnoremap <leader>co :copen<CR>
nnoremap <leader>cc :ccl<CR>

" Yank current word / paste on current word
nnoremap <leader>y viwy
nnoremap <leader>p viwpviwy

" Search through file names (via fzf)
nnoremap <silent> <leader>ff :Files<CR>
" Search files content (via ripgrep)
nnoremap <silent> <leader>fg :Rg<CR>

"Auto resize windows
nnoremap <silent> <leader>= <C-w>=

"Maps to prevent unwanted actions when focus is on NERDTree
nnoremap <silent> <expr> <leader>ff (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Files\<cr>"
nnoremap <silent> <expr> <leader>fg (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Rg\<cr>"
nnoremap <silent> <expr> <leader>j (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":bnext\<CR>:NERDTreeFind\<CR>\<c-w>\<c-p>"
nnoremap <silent> <expr> <leader>k (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":bprev\<CR>:NERDTreeFind\<CR>\<c-w>\<c-p>"
" nnoremap <silent> <expr> ":q<cr>" (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":q\<cr>"

source ~/coc.vim
