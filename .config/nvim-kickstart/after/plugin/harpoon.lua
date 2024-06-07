local mark = require 'harpoon.mark'
local ui = require 'harpoon.ui'

vim.keymap.set('n', '<leader>ha', mark.add_file, { desc = '[H]arpoon add file', silent = true, noremap = true })
vim.keymap.set('n', '<leader>hh', ui.toggle_quick_menu, { desc = '[H]arpoon [T]oggle menu', silent = true, noremap = true })
vim.keymap.set('n', '<leader>hc', ui.toggle_quick_menu, { desc = '[H]arpoon clear all', silent = true, noremap = true })
vim.keymap.set('n', '<leader>hn', ui.nav_next, { desc = '[H]arpoon [n]ext', silent = true, noremap = true })
vim.keymap.set('n', '<leader>hp', ui.nav_prev, { desc = '[H]arpoon [p]revious', silent = true, noremap = true })
