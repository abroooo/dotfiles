--vim.opt.guicursor = ""
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.nvim/undodir" vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 999 -- keep the cursor centered
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.opt.laststatus = 3 -- statusbar 3: always and ONLY the last window
	

-- mine
vim.opt.ruler = true
-- vim.opt.backspace=indent,eol,start -- allow backspacing over everything in insert mode
vim.opt.cursorline = true
