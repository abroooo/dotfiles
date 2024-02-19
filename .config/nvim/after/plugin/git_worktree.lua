require("git-worktree").setup()
-- require("git-worktree").setup({
--     -- change_directory_command = <str> -- default: "cd",
--     -- update_on_change = <boolean> -- default: true,
--     -- update_on_change_command = <str> -- default: "e .",
--     -- clearjumps_on_change = <boolean> -- default: true,
--     -- autopush = <boolean> -- default: false,
-- })
require("telescope").load_extension("git_worktree")
vim.keymap.set("n", "<leader>sf","<CMD>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>", {})
-- vim.keymap.set("n", "ws","<CMD>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>", {})
vim.keymap.set("n", "<leader>wa","<CMD>lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>", {})

