return {
  {
    'NeogitOrg/neogit',
    'nvim-lua/plenary.nvim', -- required
    dependencies = {
      'sindrets/diffview.nvim', -- optional - Diff integration

      -- Only one of these is needed.
      'nvim-telescope/telescope.nvim', -- optional
      'ibhagwan/fzf-lua', -- optional
      'echasnovski/mini.pick', -- optional
    },
    config = true,
  },
}
