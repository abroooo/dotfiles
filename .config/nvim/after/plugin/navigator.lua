require('Navigator').setup()

vim.keymap.set({'n', 't'}, '<A-h>', 'vim.cmd.NavigatorLeft')
vim.keymap.set({'n', 't'}, '<A-l>', 'vim.cmd.NavigatorRight')
vim.keymap.set({'n', 't'}, '<A-k>', 'vim.cmd.NavigatorUp')
vim.keymap.set({'n', 't'}, '<A-j>', 'vim.cmd.NavigatorDown')
vim.keymap.set({'n', 't'}, '<A-p>', 'vim.cmd.NavigatorPrevious')
vim.keymap.set("n", "<Tab>", vim.cmd.bnext)
