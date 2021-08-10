set timeoutlen=200
" >> load plugins
call plug#begin(stdpath('data') . 'vimplug')
    " Telescope
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-telescope/telescope.nvim'

    " LSP and dev
    Plug 'neovim/nvim-lspconfig'
    Plug 'kabouzeid/nvim-lspinstall'
    Plug 'glepnir/lspsaga.nvim'
    Plug 'hrsh7th/nvim-compe'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-treesitter/nvim-treesitter-textobjects'
    Plug 'nvim-treesitter/playground'
    Plug 'liuchengxu/vista.vim'
    Plug 'rhysd/vim-clang-format'
    Plug 'nvim-lua/lsp-status.nvim'
    Plug 'tomtom/tcomment_vim'

    " Rest
    Plug 'glepnir/galaxyline.nvim', { 'branch': 'main' }
    Plug 'kyazdani42/nvim-web-devicons'  " needed for galaxyline icons

    " colorschemes
    Plug 'NLKNguyen/papercolor-theme'
    Plug 'gruvbox-community/gruvbox'
    Plug 'nikvdp/neomux'

    " utils
    Plug 'justinmk/vim-sneak'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'p00f/nvim-ts-rainbow'

"    Plug 'tpope/vim-ragtag'
"    Plug 'tpope/vim-surround'
"    Plug 'tpope/vim-unimpaired'

    Plug 'tpope/vim-eunuch'
    Plug 'tpope/vim-fugitive'
    Plug 'vimwiki/vimwiki'

    Plug 'abecodes/tabout.nvim'
    Plug 'airblade/vim-rooter'
    Plug 'sindrets/diffview.nvim'
call plug#end()

" #################################################
" basic settings
" #################################################
syntax on
set number
set relativenumber
set ignorecase      " ignore case
set smartcase     " but don't ignore it, when search string contains uppercase letters
set nocompatible
set incsearch        " do incremental searching
set visualbell
set tabstop=4 shiftwidth=4 expandtab
set ruler
set smartindent
set hlsearch
set virtualedit=all
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set autoindent
set mouse=a  " mouse support
set hidden
set undodir=~/.nvim/undodir
set undofile
set colorcolumn=120
set cursorline
set noswapfile
" set nobackup => do I need this?
" set pastetoggle=<F2> => obsolete
"
" code formatting
let g:clang_format#detect_style_file

" setting with vim-lsp
if executable('clangd')
   au User lsp_setup call lsp#register_server({
      \ 'name': 'clangd',
      \ 'cmd': {server_info->['ccls']},
      \ 'root_uri': {server_info->lsp#utils#path_to_uri(
      \   lsp#utils#find_nearest_parent_file_directory(
      \     lsp#utils#get_buffer_path(), ['.clangd', 'compile_commands.json', '.git/']))},
      \ 'initialization_options': {
      \   'highlight': { 'lsRanges' : v:true },
      \   'cache': {'directory': stdpath('cache') . '/ccls' },
      \ },
      \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
      \ })
endif


" #################################################
" color scheme
" #################################################
"colorscheme PaperColor
let g:gruvbox_material_background = 'hard'
let g:airline_theme = 'gruvbox'
let g:gruvbox_contrast_dark = 'hard'
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
let g:gruvbox_invert_selection='0'
colorscheme gruvbox


autocmd FileType py set tabstop=4 softtabstop=0 expandtab
autocmd FileType yaml set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab

" #################################################
" Plugin settings
" #################################################

" --------------
" Sneak settings
" --------------
let g:sneak#label = 1
let g:sneak#label = 1

" case insensitive sneak
let g:sneak#use_ic_scs = 1

" immediately move to the next instance of search, if you move the cursor sneak is back to default behavior
let g:sneak#s_next = 1

" remap so I can use , and ; with f and t                                                                                                                                                                                                        
map gS <Plug>Sneak_,
map gs <Plug>Sneak_;

" Change the colors
highlight Sneak guifg=black guibg=#00C7DF ctermfg=black ctermbg=cyan
highlight SneakScope guifg=red guibg=yellow ctermfg=red ctermbg=yellow

" Cool prompts
let g:sneak#prompt = '🕵'
let g:sneak#prompt = '🔎'


" set leader key to ,
let g:mapleader=" "

" ---------
" Telescope
" ---------

" >> Telescope bindings
nnoremap <Leader>pp :lua require'telescope.builtin'.builtin{}<CR>
nnoremap <Leader>w :lua require'telescope.builtin'.lsp_dynamic_workspace_symbols()<CR>

" most recentuly used files
nnoremap <Leader>m :lua require'telescope.builtin'.oldfiles{}<CR>

" find buffer
nnoremap ; :lua require'telescope.builtin'.buffers{}<CR>

" find in current buffer
nnoremap <Leader>/ :lua require'telescope.builtin'.current_buffer_fuzzy_find{}<CR>

" bookmarks
nnoremap <Leader>' :lua require'telescope.builtin'.marks{}<CR>

" git files
nnoremap <Leader>f :lua require'telescope.builtin'.git_files{}<CR>

" all files
nnoremap <Leader><space> :lua require'telescope.builtin'.find_files{}<CR>

" ripgrep like grep through dir
nnoremap <C-a> :lua require'telescope.builtin'.live_grep{}<CR>

" pick color scheme
nnoremap <Leader>cs :lua require'telescope.builtin'.colorscheme{}<CR>

" -------------------
" >> Lsp key bindings
" -------------------
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <C-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gi    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> K     <cmd>Lspsaga hover_doc<CR>
nnoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <C-p> <cmd>Lspsaga diagnostic_jump_prev<CR>
nnoremap <silent> <C-n> <cmd>Lspsaga diagnostic_jump_next<CR>
nnoremap <silent> gf    <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> gn    <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> ga    <cmd>Lspsaga code_action<CR>
xnoremap <silent> ga    <cmd>Lspsaga range_code_action<CR>
nnoremap <silent> gs    <cmd>Lspsaga signature_help<CR>


" >> setup nerdcomment key bindings
let g:NERDCreateDefaultMappings = 0
let g:NERDSpaceDelims = 1

xnoremap <Leader>ci :call NERDComment('n', 'toggle')<CR>
nnoremap <Leader>ci :call NERDComment('n', 'toggle')<CR>                                                                                                                                                                                      


lua <<EOF
require("lsp")
require("treesitter")
require("statusbar")
require("completion")
require("config_diffview")
require'lspconfig'.pyright.setup{}

-- require('tabout').setup {
--     tabkey = '<Tab>', -- key to trigger tabout
--     backwards_tabkey = '<S-Tab>', -- key to trigger backwards tabout
--     act_as_tab = true, -- shift content if tab out is not possible
--     act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
--     enable_backwards = true, -- well ...
--     completion = true, -- if the tabkey is used in a completion pum
--     tabouts = {
--       {open = "'", close = "'"},
--       {open = '"', close = '"'},
--       {open = '`', close = '`'},
--       {open = '(', close = ')'},
--       {open = '[', close = ']'},
--       {open = '{', close = '}'}
--     },
--     ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
--     exclude = {} -- tabout will ignore these filetypes
-- }


EOF



" Jenkins syntax highlighting
au BufNewFile,BufRead Jenkinsfile setf groovy


" #############################################################################
"vimwiki config start
" #############################################################################
" vimwiki with markdown support
let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
let wiki_1 = {}
let wiki_1.path = '~/git/personal_notes2.wiki/'
let wiki_1.syntax = 'markdown'
let wiki_1.ext = '.md'
let wiki_1.index = 'Home'
let wiki_1.path_html = '~/personal_notes.html'
let wiki_1.custom_wiki2html = '~/dotfiles/wiki2html.sh'
let wiki_1.diary_rel_path = '.'
let g:vimwiki_list = [wiki_1]
" nmap <leader><space> <Plug>VimwikiNextLink
" nmap <leader>. <Plug>VimwikiPrevLink
" Free <tab> in insert mode to make UltiSnips work
" https://github.com/vimwiki/vimwiki/issues/357
let g:vimwiki_table_mappings = 0
"let g:vimwiki_list = [{'path': ‘/home/alex/wiki',
"  \ 'path_html': ‘/home/alex/wiki_html’,
"  \ 'syntax': 'markdown',
"  \ 'ext': '.md',
"  \ 'custom_wiki2html': ‘/home/alex/wiki2html.sh'}]

" helppage -> :h vimwiki-syntax

" vim-instant-markdown - Instant Markdown previews from Vim
" https://github.com/suan/vim-instant-markdown
let g:instant_markdown_autostart = 0  " disable autostart
map <leader>md :InstantMarkdownPreview<CR>
map <leader>ch :!sh generateHtml.sh execute

:autocmd BufWritePost ~/git/personal_notes2.wiki/* execute '!git add -A && git commit -m % && git push origin master'
:autocmd BufReadPre ~/git/personal_notes2.wiki/* execute '!git pull'
"vimwiki config end

:nnoremap <Leader>pp :lua require'telescope.builtin'.current_buffer_fuzzy_find()<CR>
:inoremap <leader>cd <C-R>=strftime("## %Y%m%d")<CR>

" #############################################################################
" Mappings
" #############################################################################
"let mapleader="<Space>"

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Better indenting
vnoremap < <gv
vnoremap > >gv

" Use alt + hjkl to resize windows
nnoremap <silent> <A-j>    :resize -2<CR>
nnoremap <silent> <A-k>    :resize +2<CR>
nnoremap <silent> <A-h>    :vertical resize -2<CR>
nnoremap <silent> <A-l>    :vertical resize +2<CR>

"Insert mode
imap <C-h> <C-w>h
imap <C-j> <C-w>j
imap <C-k> <C-w>k
imap <C-l> <C-w>l

"Moving text
"-----------
"move selection up/down
vnoremap J :m '>+1<CR>gv=gv             
vnoremap K :m '<-2<CR>gv=gv
"move line up/down while in insert mode
inoremap <C-j> <esc>:m .+1<CR>==a
inoremap <C-k> <esc>:m .-2<CR>==a
" move single line one line up/down
nnoremap <leader>j :m .+1<CR>==
nnoremap <leader>k :m .-2<CR>==

autocmd VimEnter * nnoremap <TAB> :bnext<cr>
autocmd VimEnter * nnoremap <S-TAB> :bprevious<cr>

" markdown linebreak
inoremap <leader><cr> <br><cr>

function! CentreCursor()
    let pos = getpos(".")
    normal! zz
    call setpos(".", pos)
endfunction

:autocmd CursorMoved,CursorMovedI * call CentreCursor()
