require('lazy').setup {
  {
    'stevearc/conform.nvim',
    config = function()
      require('conform').setup {
        formatters_by_ft = {
          markdown = { 'prettier' },
          python = { 'black' },
          lua = { 'stylua' },
          rust = { 'rustfmt' },
          cpp = { 'clang_format' },
          c = { 'clang_format' },
        },
      }

      -- Auto-format on save
      vim.api.nvim_create_augroup('FormatOnSave', {})
      vim.api.nvim_create_autocmd('BufWritePost', {
        group = 'FormatOnSave',
        pattern = { '*.md', '*.py', '*.lua', '*.rs', '*.cpp', '*.hpp' },
        callback = function()
          require('conform').format { async = true }
        end,
      })
    end,
  },
}
