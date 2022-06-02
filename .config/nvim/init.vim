set timeoutlen=200
" >> load plugins
call plug#begin(stdpath('data') . 'vimplug')
    " Telescope
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-telescope/telescope.nvim'

    " LSP and dev
    Plug 'neovim/nvim-lspconfig'
"    Plug 'kabouzeid/nvim-lspinstall'
    Plug 'williamboman/nvim-lsp-installer'
    Plug 'glepnir/lspsaga.nvim'
    Plug 'hrsh7th/nvim-compe'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-treesitter/nvim-treesitter-textobjects'
    Plug 'nvim-treesitter/playground'
    Plug 'liuchengxu/vista.vim'
    Plug 'rhysd/vim-clang-format'
    Plug 'nvim-lua/lsp-status.nvim'
"    Plug 'hrsh7th/vim-vsnip'
"    Plug 'rafamadriz/friendly-snippets'
"    Plug 'hrsh7th/vim-vsnip-integ'
    Plug 'sbdchd/neoformat'
    Plug 'weilbith/nvim-code-action-menu'
    Plug 'TimUntersberger/neogit'
    Plug 'p00f/nvim-ts-rainbow'
    Plug 'ahmedkhalf/lsp-rooter.nvim'
    Plug 'simrat39/symbols-outline.nvim'
    Plug 'numToStr/Comment.nvim'
    Plug 'chipsenkbeil/distant.nvim'

    " Rest
    Plug 'glepnir/galaxyline.nvim', { 'branch': 'main' }
    Plug 'kyazdani42/nvim-web-devicons'  " needed for galaxyline icons
    Plug 'kyazdani42/nvim-tree.lua'
    Plug 'sunjon/shade.nvim'

    " colorschemes
    Plug 'NLKNguyen/papercolor-theme'
    Plug 'gruvbox-community/gruvbox'
    Plug 'nikvdp/neomux'
    Plug 'phanviet/vim-monokai-pro'
    Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
    Plug 'shaunsingh/nord.nvim'
    Plug 'navarasu/onedark.nvim'
    Plug 'tomasiser/vim-code-dark'
    Plug 'rebelot/kanagawa.nvim'

    " utils
    Plug 'justinmk/vim-sneak'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'p00f/nvim-ts-rainbow'
    Plug 'voldikss/vim-floaterm'
    Plug 'ThePrimeagen/harpoon'
    Plug 'tveskag/nvim-blame-line'
"    Plug 'rmagatti/auto-session'

"    Plug 'tpope/vim-ragtag'
"    Plug 'tpope/vim-surround'
"    Plug 'tpope/vim-unimpaired'

    Plug 'tpope/vim-eunuch'
    Plug 'tpope/vim-fugitive'
    Plug 'junegunn/gv.vim'
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
set laststatus=3
highlight WinSeperator guibg=None
" set nobackup => do I need this?
" set pastetoggle=<F2> => obsolete
"
" code formatting
let g:clang_format#detect_style_file

autocmd FileType markdown noremap <leader>r i---<CR>title:<Space><++><CR>author:<Space>"Brodie Robertson"<CR>geometry:<CR>-<Space>top=30mm<CR>-<Space>left=20mm<CR>-<Space>right=20mm<CR>-<Space>bottom=30mm<CR>header-includes:<Space>\|<CR><Tab>\usepackage{float}<CR>\let\origfigure\figure<CR>\let\endorigfigure\endfigure<CR>\renewenvironment{figure}[1][2]<Space>{<CR><Tab>\expandafter\origfigure\expandafter[H]<CR><BS>}<Space>{<CR><Tab>\endorigfigure<CR><BS>}<CR><BS>---<CR><CR>

autocmd FileType markdown inoremap ,i ![](<++>){#fig:<++>}<Space><CR><CR><++><Esc>kkF]i

autocmd FileType markdown inoremap ,a [](<++>)<Space><++><Esc>F]i

autocmd FileType markdown inoremap ,1 #<Space><CR><CR><++><Esc>2k<S-a>

autocmd FileType markdown inoremap ,2 ##<Space><CR><CR><++><Esc>2k<S-a>

autocmd FileType markdown inoremap ,3 ###<Space><CR><CR><++><Esc>2k<S-a>

autocmd FileType markdown inoremap ,4 ####<Space><CR><CR><++><Esc>2k<S-a>

autocmd FileType markdown inoremap ,5 #####<Space><CR><CR><++><Esc>2k<S-a>

autocmd FileType markdown inoremap ,u +<Space><CR><++><Esc>1k<S-a>

autocmd FileType markdown inoremap ,o 1.<Space><CR><++><Esc>1k<S-a>

autocmd FileType markdown inoremap ,f +@fig:
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
colorscheme kanagawa


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
nnoremap <silent> gh    <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> K     <cmd>Lspsaga hover_doc<CR>
nnoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <C-p> <cmd>Lspsaga diagnostic_jump_prev<CR>
nnoremap <silent> <C-n> <cmd>Lspsaga diagnostic_jump_next<CR>
nnoremap <silent> gf    <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> gn    <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> ga    <cmd>Lspsaga code_action<CR>
xnoremap <silent> ga    <cmd>Lspsaga range_code_action<CR>
nnoremap <silent> gs    <cmd>Lspsaga signature_help<CR>

" --------------
" Treesitter
" --------------
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

" >> setup nerdcomment key bindings
let g:NERDCreateDefaultMappings = 0
let g:NERDSpaceDelims = 1

xnoremap <Leader>ci :call NERDComment('n', 'toggle')<CR>
nnoremap <Leader>ci :call NERDComment('n', 'toggle')<CR>                                                                                                                                                                                      


lua <<EOF
require("lsp")
require('distant').setup {
      -- Applies Chip's personal settings to every machine you connect to
      --
      -- 1. Ensures that distant servers terminate with no connections
      -- 2. Provides navigation bindings for remote directories
      -- 3. Provides keybinding to jump into a remote file's parent directory
      ['*'] = require('distant.settings').chip_default()
    }
require('onedark').setup {
    style = 'darker'
}
require('onedark').load()

require'shade'.setup({
  overlay_opacity = 50,
  opacity_step = 1,
  keys = {
    brightness_up    = '<C-Up>',
    brightness_down  = '<C-Down>',
    toggle           = '<Leader>s',
  }
})

require('Comment').setup({






    ---Add a space b/w comment and the line
    ---@type boolean
    padding = true,

    ---Whether the cursor should stay at its position
    ---NOTE: This only affects NORMAL mode mappings and doesn't work with dot-repeat
    ---@type boolean
    sticky = true,

    ---Lines to be ignored while comment/uncomment.
    ---Could be a regex string or a function that returns a regex string.
    ---Example: Use '^$' to ignore empty lines
    ---@type string|fun():string
    ignore = nil,

    ---LHS of toggle mappings in NORMAL + VISUAL mode
    ---@type table
    toggler = {
        ---Line-comment toggle keymap
        line = 'gcc',
        ---Block-comment toggle keymap
        block = 'gbc',
    },

    ---LHS of operator-pending mappings in NORMAL + VISUAL mode
    ---@type table
    opleader = {
        ---Line-comment keymap
        line = 'gc',
        ---Block-comment keymap
        block = 'gb',
    },

    ---LHS of extra mappings
    ---@type table
    extra = {
        ---Add comment on the line above
        above = 'gcO',
        ---Add comment on the line below
        below = 'gco',
        ---Add comment at the end of line
        eol = 'gcA',
    },

    ---Create basic (operator-pending) and extended mappings for NORMAL + VISUAL mode
    ---@type table
    mappings = {
        ---Operator-pending mapping
        ---Includes `gcc`, `gbc`, `gc[count]{motion}` and `gb[count]{motion}`
        ---NOTE: These mappings can be changed individually by `opleader` and `toggler` config
        basic = true,
        ---Extra mapping
        ---Includes `gco`, `gcO`, `gcA`
        extra = true,
        ---Extended mapping
        ---Includes `g>`, `g<`, `g>[count]{motion}` and `g<[count]{motion}`
        extended = false,
    },

    ---Pre-hook, called before commenting the line
    ---@type fun(ctx: Ctx):string
    pre_hook = nil,

    ---Post-hook, called after commenting is done
    ---@type fun(ctx: Ctx)
    post_hook = nil,




















})
-- require("symbols-outline.lua")
require("treesitter")
require("statusbar")
require("completion")
require("config_diffview")
require'lspconfig'.pyright.setup{}
require'nvim-treesitter.configs'.setup {
  rainbow = {
    enable = true,
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
    -- colors = {}, -- table of hex strings
    -- termcolors = {} -- table of colour name strings
  }
}
require'nvim-treesitter.configs'.setup{
  rainbow = {
    -- Setting colors
    colors = {
      -- Colors here
    },
    -- Term colors
    termcolors = {
      -- Term colors here
    }
  },
}
local neogit = require('neogit')

neogit.setup {}

-- ThePrimeagen harpoon
require("harpoon").setup({
    global_settings = {
        save_on_toggle = false,
        save_on_change = true,
        enter_on_sendcmd = false,
        tmux_autoclose_windows = false,
        excluded_filetypes = { "harpoon" }
    },
 --   ... your other configs ...
})


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

-- nvim tree
-- vim.g["nvim_tree_disable_window_picker"] = 1 => deprecated
-- following options are the default
-- each of these are documented in `:help nvim-tree.OPTION_NAME`
require'nvim-tree'.setup {
  disable_netrw       = true,
  hijack_netrw        = true,
  open_on_setup       = false,
  ignore_ft_on_setup  = {},
  auto_close          = false,
  open_on_tab         = false,
  hijack_cursor       = false,
  update_cwd          = false,
  update_to_buf_dir   = {
    enable = true,
    auto_open = true,
  },
  diagnostics = {
    enable = false,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    }
  },
  update_focused_file = {
    enable      = false,
    update_cwd  = false,
    ignore_list = {}
  },
  system_open = {
    cmd  = nil,
    args = {}
  },
  filters = {
    dotfiles = false,
    custom = {}
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 500,
  },
  view = {
    width = 30,
    height = 30,
    hide_root_folder = false,
    side = 'left',
    auto_resize = false,
    mappings = {
      custom_only = false,
      list = {}
    },
    number = false,
    relativenumber = false
  },
  trash = {
    cmd = "trash",
    require_confirm = true
  }
}

-- lsp rooter
  require("lsp-rooter").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
vim.treesitter.set_query("python", "folds", [[
  (function_definition (block) @fold)
  (class_definition (block) @fold)
]])


EOF



" Jenkins syntax highlighting
au BufNewFile,BufRead Jenkinsfile setf groovy

" #############################################################################
" nvim tree configuration
" #############################################################################
"let g:nvim_tree_auto_open = 1
"let g:nvim_tree_disable_window_picker = 1

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
" configure vnsip
" #############################################################################
"
" NOTE: You can use other key to expand snippet.

"" Expand
"imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
"smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
"
"" Expand or jump
"imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
"smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
"
"" Jump forward or backward
""imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
""smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
""imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
""smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
"
"
"
"" Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
"" See https://github.com/hrsh7th/vim-vsnip/pull/50
"nmap        s   <Plug>(vsnip-select-text)
"xmap        s   <Plug>(vsnip-select-text)
"nmap        S   <Plug>(vsnip-cut-text)
"xmap        S   <Plug>(vsnip-cut-text)

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

" custom setting for clangformat
let g:neoformat_cpp_clangformat = {
    \ 'exe': 'clang-format-11',
    \ 'args': ['--style=file']
\}
let g:neoformat_enabled_cpp = ['clangformat']
let g:neoformat_enabled_c = ['clangformat']

"augroup fmt
"  autocmd!
"  autocmd BufWritePre *.cpp Neoformat
"augroup END

