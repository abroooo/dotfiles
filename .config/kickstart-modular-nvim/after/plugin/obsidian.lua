-- Obsidian
require('lazy').load({plugins = {'obsidian.nvim'}})
vim.keymap.set('n', '<leader>os', ':ObsidianQuickSwitch<CR>', { desc = '[O]bsidian file search', silent = true, noremap = true })
vim.keymap.set('n', '<leader>on', ':ObsidianNew<CR>', { desc = '[O]bsidian new note', silent = true, noremap = true })
vim.keymap.set('n', '<leader>og', ':ObsidianSearch<CR>', { desc = '[O]bsidian file grep', silent = true, noremap = true })
vim.keymap.set('n', '<leader>od', ':ObsidianToday<CR>', { desc = '[O]bisian To[d]ay' })
vim.keymap.set('n', '<leader>oy', ':ObsidianYesterday<CR>', { desc = '[O]bisian [Y]esterday' })
