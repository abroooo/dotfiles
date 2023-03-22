vim.g.mapleader = " "
vim.g.maplocalleader = "/"
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)


-- easy buffer switching
vim.keymap.set("n", "<Tab>", vim.cmd.bnext)
vim.keymap.set("n", "<S-Tab>", vim.cmd.bprev)

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        if opts.desc then
            opts.desc = "keymaps.lua: " .. opts.desc
        end
        options = vim.tbl_extend('force', options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

-- here some of my mappings:
-- -- jump to the last changed spot
 map("n", "gl", "`.", { desc = "Jump to the last change in the file"})
-- map("n", "<C-h>", "<C-w>h", { desc = "Jump to the last change in the file"})
-- home assistant confif as sambda share

-- Moving text
-- -----------
-- move selection up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("i", "<C-j>", "<esc>:m .+1<CR>==a")
vim.keymap.set("i", "<C-k>", "<esc>:m .-2<CR>==a")

vim.keymap.set("n", "<leader>j", ":m .+1<CR>==")
vim.keymap.set("n", "<leader>k", ":m .-2<CR>==")
