-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<C-s>', ':w<CR>', { desc = '[O]bsidian file search', silent = true, noremap = true })

vim.keymap.set('n', '<M-h>', [[<cmd>vertical resize +5<cr>]]) -- make the window biger vertically
vim.keymap.set('n', '<M-j>', [[<cmd>vertical resize -5<cr>]]) -- make the window smaller vertically
vim.keymap.set('n', '<M-k>', [[<cmd>horizontal resize +2<cr>]]) -- make the window bigger horizontally by pressing shift and =
vim.keymap.set('n', '<M-l>', [[<cmd>horizontal resize -2<cr>]]) -- make the window smaller horizontally by pressing shift and -
-- Moving text
-- -----------
-- move selection up/down
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

vim.keymap.set('i', '<C-j>', '<esc>:m .+1<CR>==a')
vim.keymap.set('i', '<C-k>', '<esc>:m .-2<CR>==a')

vim.keymap.set('n', '<leader>j', ':m .+1<CR>==')
vim.keymap.set('n', '<leader>k', ':m .-2<CR>==')

-- Obsidian
vim.keymap.set('n', '<leader>os', ':ObsidianQuickSwitch<CR>', { desc = '[O]bsidian file search', silent = true, noremap = true })
vim.keymap.set('n', '<leader>on', ':ObsidianNew<CR>', { desc = '[O]bsidian new note', silent = true, noremap = true })
vim.keymap.set('n', '<leader>og', ':ObsidianSearch<CR>', { desc = '[O]bsidian file grep', silent = true, noremap = true })
vim.keymap.set('n', '<leader>od', ':ObsidianToday<CR>', { desc = '[O]bisian To[d]ay' })
vim.keymap.set('n', '<leader>oz', ':ZenMode | Pencil<CR>', { desc = '[O]bisian To[d]ay' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- vim: ts=2 sts=2 sw=2 et
