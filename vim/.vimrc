:imap fd <Esc>
set tabstop=4
set shiftwidth=4
set autoindent
set expandtab
syntax on

tnoremap <C-w>h <C-\><C-n><C-w>h
tnoremap <C-w>j <C-\><C-n><C-w>j
tnoremap <C-w>k <C-\><C-n><C-w>k
tnoremap <C-w>l <C-\><C-n><C-w>l

" automatically install vim-plug if not installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" line nums
set number
set relativenumber

call plug#begin('~/.vim/plugged')
Plug 'https://github.com/morhetz/gruvbox'
Plug 'preservim/nerdtree'
Plug 'https://github.com/tpope/vim-surround'
call plug#end()

map <C-n> :NERDTreeToggle<CR>
" set Vim-specific sequences for RGB colors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" Make background dark
:set bg=dark
let g:gruvbox_italic=1
colorscheme gruvbox

