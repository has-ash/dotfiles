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
" editing/moving around
Plug 'preservim/nerdtree'
Plug 'https://github.com/tpope/vim-surround'
" the missing motion for vim
" to combine with operators, use z instead of s
" since s is taken by surround.vim
" Plug 'justinmk/vim-sneak'

" colors / visuals
Plug 'https://github.com/morhetz/gruvbox'
"Plug 'NLKNguyen/papercolor-theme'
Plug 'itchyny/lightline.vim'


" fuzzy find
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Semantic language support
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neovim/nvim-lspconfig'

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

" syntax highlighting for flex, lex, yacc and bison
Plug 'https://github.com/justinmk/vim-syntax-extra'

" comment code using gcc
Plug 'https://tpope.io/vim/commentary.git'

" tree sitter for highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

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

set tabstop=2
set shiftwidth=2
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

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"author: jonhoo
" Lightline
function! LightlineFilename()
  return expand('%:t') !=# '' ? @% : '[No Name]'
endfunction


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


"""""""""""" treesitter config
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
	highlight = {
	enable = true,
	},
	indent = {
	enable = true
	}
}
EOF

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LSP CONFIG
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'pyright', 'rust_analyzer', 'clangd' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
EOF
