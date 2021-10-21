set smartcase				
set autoindent				
set smartindent
set cindent					
set number					
set softtabstop=4
set tabstop=4				
set shiftwidth=4			
set linebreak
set formatoptions=croql
set ignorecase
set ruler					
set incsearch
set smarttab
set hlsearch				
set mouse=a
set nocompatible
set title
set showmatch				
set showmode
set wildmenu
syntax on
set background=dark
set cb=unnamed
set cursorline
filetype plugin on
filetype indent on
set bs=eol,start,indent

set scrolloff=2
set wildmode=longest,list
"set sw=1					
set autowrite				 
set autoread				 
set history=256
"set laststatus=2			 
"set paste					 
set statusline=\ %<%l:%v\ [%P]%=%a\ %h%m%r\ %F\
set viminfo=


au BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\ exe "norm g`\"" |
\ endif


if $LANG[0]=='k' && $LANG[1]=='o'
set fileencoding=korea
endif


colorscheme jellybeans"
"colorscheme delek"


if has("syntax")
    syntax on
endif

" Clipboard Copy and Cut
vmap <C-c> y:call system("xclip -i -selection clipboard", getreg("\""))<CR>:call system("xclip -i", getreg("\""))<CR>
vmap <C-x> "pd
vmap <C-v> <ESC> "ppi
imap <C-v> <ESC> "ppi


map <F1> :ter<CR>
vmap <F1> <ESC> :ter<CR>
imap <F1> <ESC> :ter<CR>

map <C-s> :w<CR>
vmap <C-s> <ESC> :w<CR>
imap <C-s> <ESC> :w<CR>

map <C-q> :q<CR>
vmap <C-q> <ESC> :q<CR>
imap <C-q> <ESC> :q<CR>

map <F2> :vsplit<CR><TAB>
vmap <F2> <ESC> :vsplit<CR><TAB>
imap <F2> <ESC> :vsplit<CR><TAB>

map <F3> :split<CR><TAB>
vmap <F3> <ESC> :split<CR><TAB>
imap <F3> <ESC> :split<CR><TAB>

map <TAB> <C-w><C-w>
map <F4> :close<CR>

map <F5> <C-w>=
map <F6> :ls<CR>
map <F7> :bp<CR>
map <F8> :bn<CR>
map <F9> :bd<CR>

map <F10> :call system("gnome-terminal")<CR>
imap <F10> <ESC>:call system("gnome-terminal")<CR>
vmap <F10> <ESC>:call system("gnome-terminal")<CR>
