-- Custom keymaps

-- Insert new log section with today's date and prepare list item
vim.keymap.set('n', '<leader>tt', function()
  local lines = {}

  local date = os.date '%Y-%m-%d'
  table.insert(lines, '### ' .. date)
  table.insert(lines, '- ')

  vim.api.nvim_put(lines, 'l', true, true)
  vim.schedule(function()
    vim.cmd 'normal! $'
    vim.cmd 'startinsert!'
  end)
end, { desc = '[T]ime[T]amp log section' })
