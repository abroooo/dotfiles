-- Obsidian
require('lazy').load { plugins = { 'obsidian.nvim' } }
vim.keymap.set('n', '<leader>os', ':Obsidian quick_switch<CR>', { desc = '[O]bsidian file search', silent = true, noremap = true })
vim.keymap.set('n', '<leader>on', ':Obsidian new<CR>', { desc = '[O]bsidian new note', silent = true, noremap = true })
vim.keymap.set('n', '<leader>og', ':Obsidian search<CR>', { desc = '[O]bsidian file grep', silent = true, noremap = true })
vim.keymap.set('n', '<leader>od', ':Obsidian today<CR>', { desc = '[O]bisian To[d]ay' })
vim.keymap.set('n', '<leader>oy', ':Obsidian yesterday<CR>', { desc = '[O]bisian [Y]esterday' })
vim.keymap.set('n', '<leader>os', ':ObsidianQuickSwitch<CR>', { desc = '[O]bsidian file search', silent = true, noremap = true })
vim.keymap.set('n', '<leader>on', ':ObsidianNew<CR>', { desc = '[O]bsidian new note', silent = true, noremap = true })
vim.keymap.set('n', '<leader>og', ':ObsidianSearch<CR>', { desc = '[O]bsidian file grep', silent = true, noremap = true })
vim.keymap.set('n', '<leader>od', ':ObsidianToday<CR>', { desc = '[O]bisian To[d]ay' })
vim.keymap.set('n', '<leader>oy', ':ObsidianYesterday<CR>', { desc = '[O]bisian [Y]esterday' })

-- Journal files telescope search
vim.keymap.set('n', '<leader>oj', function()
  local notes_path = vim.env.NOTES
  require('telescope.builtin').find_files {
    prompt_title = 'Journal Files',
    cwd = notes_path .. '/journals',
    hidden = true,
    find_command = { 'rg', '--files', '--sortr', 'path' },
  }
end, { desc = '[O]bsidian [J]ournal files' })

-- Find Jira issues sorted by modification time
vim.keymap.set('n', '<leader>op', function()
  local notes_path = vim.env.NOTES
  require('telescope.builtin').find_files {
    prompt_title = 'Jira Issues',
    cwd = notes_path,
    hidden = true,
    find_command = { 'rg', '--files', '--sortr', 'modified', '--glob', 'prg_*' },
  }
end, { desc = '[O]bsidian [P]RG issues' })

-- Create Jira issue note
vim.keymap.set('n', '<leader>oi', function()
  local issue_number = vim.fn.input 'Jira Issue Number (without PRG prefix): '
  if issue_number == '' then
    return
  end

  local title = vim.fn.input 'Issue Title: '
  if title == '' then
    return
  end

  local formatted_title = string.lower(string.gsub(title, '%s+', '_'))
  local filename = string.format('prg_%s_%s', issue_number, formatted_title)

  local cmd = string.format('ObsidianNewFromTemplate %s new_jira_issue.md', filename)
  vim.cmd(cmd)
end, { desc = '[O]bsidian Jira [I]ssue' })
