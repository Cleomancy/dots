set encoding=utf-8
scriptencoding utf-8

let mapleader =","

" plugin installation
if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
Plug 'preservim/nerdtree'
Plug 'junegunn/goyo.vim'
Plug 'ap/vim-css-color'
call plug#end()

" The number of color to use
set t_Co=256

" Use English as default
language en_US.utf-8

" Set height of status line
set laststatus=2

" Changing fillchars for folding, so there is no garbage charactes
set fillchars=fold:\ ,vert:\|

" Paste mode toggle, it seems that Neovim's bracketed paste mode
" does not work very well for nvim-qt, so we use good-old paste mode
" set pastetoggle=<F12>

" Split window below/right when creating horizontal/vertical windows
set splitbelow splitright

" Time in milliseconds to wait for a mapped sequence to complete,
" see https://unix.stackexchange.com/q/36882/221410 for more info
set timeoutlen=500

" For CursorHold events
set updatetime=800

" Disable creating swapfiles, see https://stackoverflow.com/q/821902/6064933
set noswapfile

" General tab settings
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set shiftwidth=4    " number of spaces to use for autoindent
set expandtab       " expand tab to spaces so that tabs are spaces

" Set matching pairs of characters and highlight matching brackets
set matchpairs+=<:>,「:」

" Show line number and relative line number
set number relativenumber

" Ignore case in general, but become case-sensitive when uppercase is present
set ignorecase smartcase

" File and script encoding settings for vim
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1

" Break line at predefined characters
set linebreak

" Minimum lines to keep above and below cursor when scrolling
set scrolloff=3

" Show full path of file and last-mod time on the window title. The
" meaning of the format str for strftime can be found in
" http://man7.org/linux/man-pages/man3/strftime.3.html. The function to get
" lastmod time is drawn from https://stackoverflow.com/q/8426736/6064933
set title
set titlestring=
set titlestring+=%(%{expand('%:p')}\ \ %)
set titlestring+=%{strftime('%Y-%m-%d\ %H:%M',getftime(expand('%')))}

" Persistent undo even after you close a file and re-open it.
" For vim, we need to set up an undodir so that $HOME is not cluttered with
" undo files.
if !has('nvim')
    if !isdirectory($HOME . '/.local/vim/undo')
        call mkdir($HOME . '/.local/vim/undo', 'p', 0700)
    endif
    set undodir=~/.local/vim/undo
endif
set undofile

" Do not add two spaces after a period when joining lines or formatting texts,
" see https://stackoverflow.com/q/4760428/6064933
set nojoinspaces

" set go=a
set mouse=a
set nohlsearch
set clipboard+=unnamedplus
set noruler
set laststatus=0
set noshowcmd
colorscheme vim

" Some basics:
nnoremap c "_c
filetype plugin indent on
syntax on

" Enable autocompletion:
set wildmode=longest,list,full

" Disables automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Shortcutting split navigation, saving a keypress:
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Perform dot commands over visual blocks:
vnoremap . :normal .<CR>
" Goyo plugin makes text more readable when writing prose:
map <leader>g :Goyo \| set linebreak<CR>
" Spell-check set to <leader>o, 'o' for 'orthography':
map <leader>o :set spell! spelllang=en_us<CR>

" Check file in shellcheck:
map <leader>s :!clear && shellcheck -x %<CR>

" Replace all is aliased to S.
nnoremap S :%s//g<Left><Left>

" Compile document, be it groff/LaTeX/markdown/etc.
map <leader>c :w! \| !compiler "%:p"<CR>

" Open corresponding .pdf/.html or preview
map <leader>p :!opout "%:p"<CR>

" Nerd tree
map <leader>n :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let NERDTreeBookmarksFile = stdpath('data') . '/NERDTreeBookmarks'

" Automatically deletes all trailing whitespace and newlines at end of file on save. & reset cursor position
autocmd BufWritePre * let currPos = getpos(".")
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritePre * %s/\n\+\%$//e
autocmd BufWritePre *.[ch] %s/\%$/\r/e " add trailing newline for ANSI C standard
autocmd BufWritePre *neomutt* %s/^--$/-- /e " dash-dash-space signature delimiter in emails
autocmd BufWritePre * cal cursor(currPos[1], currPos[2])

" Ensure files are read as what I want:
autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
autocmd BufRead,BufNewFile *.tex set filetype=tex

" Enable Goyo by default for mutt writing
autocmd BufRead,BufNewFile /tmp/neomutt* :Goyo 80 | call feedkeys("jk")
autocmd BufRead,BufNewFile /tmp/neomutt* map ZZ :Goyo!\|x!<CR>
autocmd BufRead,BufNewFile /tmp/neomutt* map ZQ :Goyo!\|q!<CR>
