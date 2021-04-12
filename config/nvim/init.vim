set shell=/bin/bash

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
"scurce ~/.vimrc

let mapleader= "\<Space>"

" set timeout for which key
set timeoutlen=500
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
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }

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

" which-key for my sanity
Plug 'liuchengxu/vim-which-key', { 'on' : ['WhichKey', 'WhichKey!'] }

call plug#end()

" create which_map
" register descriptions for which_key
autocmd! User vim-which-key call which_key#register('<Space>', "g:which_key_map")

nnoremap <silent> <leader>  :<c-u>WhichKey '<Space>'<cr>
nnoremap <silent> <localleader>  :<c-u>WhichKeyVisual '<Space>',<cr>
let g:which_key_map = {}
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
	\ call fzf#vim#grep(<q-args>, {'source': 'rg --hidden --ignore .git -g ""'}, <bang>0 )

let g:which_key_map.r = {'name':'+fzf'}

noremap <leader>rh :HFiles<cr>
let g:which_key_map.r.h = 'hidden-files'

noremap <leader>rg :GFiles<cr>
let g:which_key_map.r.h = 'git-ls files'

" noremap <leader>s for Rg search
" use with <leader>r? to get preview
" or       <leader>:  for no preview
noremap <leader>rs :Rg<cr> 
let g:which_key_map.r.h = 'rip-grep(?|:)'

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

" Open hotkeys
map <C-p> :Files<CR>

noremap <leader>rf :FZF<cr>
let g:which_key_map.r.f = 'fzf-files-curr'

noremap <leader>rF :FZF ~<cr>
let g:which_key_map.r.F = 'fzf-files-home'

nmap <leader>rb :Buffers<CR>
let g:which_key_map.r.b = 'curr-buffers'

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

let g:which_key_map.f = {'name' : '+file'} 
" Open new file adjacent to current file
nnoremap <leader>fe :e <C-R>=expand("%:p:h") . "/" <CR>
let g:which_key_map.f.e = 'edit-in-curr-dir'

nnoremap <leader>fs :w<cr>
let g:which_key_map.f.s = 'save-file'

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" "
let g:which_key_map.l = {'name' : '+lsp'} 

"author: jonhoo github (mostly with some additions by me)
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


" also add leader based keys - discoverability?
nmap <silent> <leader>ld <Plug>(coc-definition)
nmap <silent> <leader>ly <Plug>(coc-type-definition)
nmap <silent> <leader>li <Plug>(coc-implementation)
nmap <silent> <leader>lb <Plug>(coc-references)
nmap <silent> <leader>ln <Plug>(coc-diagnostic-next)
nmap <silent> <leader>lp <Plug>(coc-diagnostic-prev)

let g:which_key_map.l.d = 'coc-definition' 
let g:which_key_map.l.y = 'coc-type-def' 
let g:which_key_map.l.i = 'coc-impl' 
let g:which_key_map.l.b = 'coc-refs' 
let g:which_key_map.l.n = 'coc-diag-next' 
let g:which_key_map.l.p = 'coc-diag-prev' 

nmap <leader>lr <Plug>(coc-rename)
let g:which_key_map.l.r = 'coc-rename' 

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" TODO: what does TAB do here?
" Use <TAB> for selections ranges.
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Find symbol of current document.
nnoremap <silent> <leader>lo  :<C-u>CocList outline<cr>
let g:which_key_map.l.o = 'find-in-curr-doc' 

" Search workspace symbols.
nnoremap <silent> <leader>ls  :<C-u>CocList -I symbols<cr>
let g:which_key_map.l.s = 'find-in-workspace' 

" TODO
" Implement methods for trait
nnoremap <silent> <space>i  :call CocActionAsync('codeAction', '', 'Implement missing members')<cr>

" Show actions available at this location
nnoremap <silent> <leader>la  :CocAction<cr>
let g:which_key_map.l.a = 'show-actions' 

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"author: jonhoo
" Lightline
function! LightlineFilename()
  return expand('%:t') !=# '' ? @% : '[No Name]'
endfunction

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
" Use auocmd to force lightline update.
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-rooter config
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:rooter_patterns = [ '.git', 'Makefile', 'Cargo.toml', '_darcs']


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" which key config
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Buffer commands
let g:which_key_map.b = {'name' : '+buffers'}

noremap <silent> <leader>bn :bn<cr>
noremap <silent> <leader>bp :bp<cr>
let g:which_key_map.b.n = 'next buffer'
let g:which_key_map.b.p = 'previcus buffer'

" mappings based on existing maps
" dict for which-key
let g:which_key_map['w'] = {
			\ 'name' : '+windows',
			\ 'w' : ['<C-W>w' , 'other-window'] ,
			\ 'd' : ['<C-W>c' , 'delete-window'] ,
			\ '-' : ['<C-W>s' , 'split-window-below'] ,
			\ '|' : ['<C-W>v' , 'split-window-right'] ,
			\ 'h' : ['<C-W>h' , 'window-left'] ,
			\ 'j' : ['<C-W>j' , 'window-below'] ,
			\ 'k' : ['<C-W>k' , 'window-up'] ,
			\ 'l' : ['<C-W>l' , 'window-right'] ,
			\ 'H' : ['<C-W>H' , 'expand-window-left'] ,
			\ 'J' : ['<C-W>J' , 'expand-window-below'] ,
			\ 'K' : ['<C-W>K' , 'expand-window-up'] ,
			\ 'L' : ['<C-W>L' , 'expand-window-right'] ,
			\ '=' : ['<C-W>=' , 'balance-window'] ,
			\ '?' : ['Windows' , 'fzf-window'] ,
			\}
