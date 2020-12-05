set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
"source ~/.vimrc

let mapleader= "\<Space>"
set shell=/bin/bash

" which requires no timeout
set notimeout

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PlugsIns 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin()
" lsps
"Plug 'neovim/nvim-lsp'

" editing/moving around
Plug 'preservim/nerdtree'
Plug 'https://github.com/tpope/vim-surround'
" the missing motion for vim
" to combine with operators, use z instead of s
" since s is taken by surround.vim
Plug 'justinmk/vim-sneak'

" colors / visuals
Plug 'https://github.com/morhetz/gruvbox'
"Plug 'NLKNguyen/papercolor-theme'
Plug 'itchyny/lightline.vim'


" fuzzy find
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" On-demand lazy load
" TODO (soft): learn to use which key if needed
"  https://github.com/liuchengxu/vim-which-key
"Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }

" Semantic language support
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Syntactic language support
Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
Plug 'rust-lang/rust.vim'
Plug 'rhysd/vim-clang-format'
Plug 'dag/vim-fish'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Color Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" deal with colors
if !has('gui_running')
  set t_Co=256
endif

if (match($TERM, "-256color") != -1) && (match($TERM, "screen-256color") == -1)
  " screen does not (yet) support truecolor
  set termguicolors
endif
set background=dark

let g:gruvbox_italic=1
"set bg=light
"colorscheme PaperColor
set bg=dark
colorscheme gruvbox
set termguicolors

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Editor Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set mouse=a

set tabstop=4
set shiftwidth=4
set autoindent
" Makefiles?
set noexpandtab
syntax on

set incsearch
set ignorecase
set smartcase
" by default, substitute all matches on line
set gdefault

" from the help menu: no highlighting after search
augroup vimrc-incsearch-highlight
  autocmd!
  autocmd CmdlineEnter /,\? :set hlsearch
  autocmd CmdlineLeave /,\? :set nohlsearch
augroup END

" again jonhoo(github) / give me centered search results
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz

" line numbers | linenumbers
set number
set relativenumber

" sane window splits
set splitright
set splitbelow

" wildmenu settings
" taken from jonhoo(github)
set wildmenu
set wildmode=list:longest,full
set wildignore=.hg,.svn,*~,*.png,*.jpg,*.gif,*.settings,*min.js,*.swp,*.o,*.hi

" draw sign column
set signcolumn=yes

" find hidden files too
" from:  https://github.com/junegunn/fzf.vim/issues/226

command! -bang -nargs=? -complete=dir HFiles
	\ call fzf#vim#fiels(<q-args>, {'source': 'rg --hidden --ignore .git -g ""'}, <bang>0 )

noremap <leader>rh :HFiles<cr>

noremap <leader>rg :GFiles<cr>
" noremap <leader>s for Rg search
" use with <leader>r? to get preview
" or       <leader>:  for no preview
noremap <leader>r :Rg<cr> 
let g:fzf_layout = { 'down': '~20%' }
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

function! s:list_cmd()
  let base = fnamemodify(expand('%'), ':h:.:S')
  return base == '.' ? 'fd --type file --follow' : printf('fd --type file --follow | proximity-sort %s', shellescape(expand('%')))
endfunction

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, {'source': s:list_cmd(),
  \                               'options': '--tiebreak=index'}, <bang>0)



" Completion
" Better display for messages
set cmdheight=2
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" hasan: general leader key binds

" Ctrl+h to stop searching
vnoremap <C-h> :nohlsearch<cr>
nnoremap <C-h> :nohlsearch<cr>

" Open new file adjacent to current file
nnoremap <leader>e :e <C-R>=expand("%:p:h") . "/" <CR>
nnoremap <leader>w :w<cr>

" Open hotkeys
map <C-p> :Files<CR>
nmap <leader>; :Buffers<CR>
"nnoremap <Leader>o :

" copy paste to sys clipboard
" from: https://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/

"vmap <Leader>y "+y
"vmap <Leader>d "+d
"
"nmap <Leader>p "+p
"nmap <Leader>P "+P
"
"vmap <Leader>p "+p
"vmap <Leader>P "+P

":lua <<END
"local lspconfig = require'lspconfig'
"  lspconfig.rust_analyzer.setup{}
"  lspconfig.ccls.setup{}
"  lspconfig.cmake.setup{}
"  lspconfig.texlab.setup{}
"END
"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" hasan: general keybinds

" get rid of the horrible buffer for previous commands
map q: :q

" move around a line easier
map H ^
map L $

" copy to/from sys clipboard using xsel
noremap <leader>p :read !xsel --clipboard --output<cr>
noremap <leader>c :w !xsel --input --clipboard<cr>

" jump between windows
tnoremap <C-w>h <C-\><C-n><C-w>h
tnoremap <C-w>j <C-\><C-n><C-w>j
tnoremap <C-w>k <C-\><C-n><C-w>k
tnoremap <C-w>l <C-\><C-n><C-w>l


map <C-n> :NERDTreeToggle<CR>
" the most important keybind ever: ESC -> fd  
nnoremap fd <Esc>
inoremap fd <Esc>
vnoremap fd <Esc>
snoremap fd <Esc>
xnoremap fd <Esc>
cnoremap fd <Esc>
onoremap fd <Esc>
lnoremap fd <Esc>
tnoremap fd <Esc>

 " <leader><leader> toggles between buffers
nnoremap <leader><leader> <c-^>

" <leader>q shows stats
nnoremap <leader>q g<c-g>

" Keymap for replacing up to next _ or -
noremap <leader>m ct_

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" " author: jonhoo github
" 'Smart' navigation
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
	  \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-.> to trigger completion.
inoremap <silent><expr> <c-.> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nmap <leader>rn <Plug>(coc-rename)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for selections ranges.
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>

" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>

" Implement methods for trait
nnoremap <silent> <space>i  :call CocActionAsync('codeAction', '', 'Implement missing members')<cr>

" Show actions available at this location
nnoremap <silent> <space>a  :CocAction<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"author: jonhoo
" Lightline
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'filename': 'LightlineFilename',
      \   'cocstatus': 'coc#status'
      \ },
      \ }
function! LightlineFilename()
  return expand('%:t') !=# '' ? @% : '[No Name]'
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Which Key
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"nnoremap <silent> <leader>, :WhichKey '<Space>'<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-rooter config
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:rooter_patterns = [ '.git', 'Makefile', 'Cargo.toml', '_darcs']
