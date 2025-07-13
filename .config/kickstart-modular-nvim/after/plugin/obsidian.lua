-- Obsidian
require('lazy').load { plugins = { 'obsidian.nvim' } }
vim.keymap.set('n', '<leader>os', ':Obsidian quick_switch<CR>', { desc = '[O]bsidian file search', silent = true, noremap = true })
vim.keymap.set('n', '<leader>on', ':Obsidian new<CR>', { desc = '[O]bsidian new note', silent = true, noremap = true })
vim.keymap.set('n', '<leader>og', ':Obsidian search<CR>', { desc = '[O]bsidian file grep', silent = true, noremap = true })
vim.keymap.set('n', '<leader>od', ':Obsidian today<CR>', { desc = '[O]bisian To[d]ay' })
vim.keymap.set('n', '<leader>oy', ':Obsidian yesterday<CR>', { desc = '[O]bisian [Y]esterday' })
