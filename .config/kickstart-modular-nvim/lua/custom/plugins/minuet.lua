return {
  {
    'milanglacier/minuet-ai.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'hrsh7th/nvim-cmp' },
    event = 'InsertEnter',
    config = function()
      vim.env.LLAMA_SWAP_API_KEY = vim.env.LLAMA_SWAP_API_KEY or 'dummy'

      require('minuet').setup {
        provider = 'openai_fim_compatible',
        n_completions = 1,
        context_window = 2048,
        provider_options = {
          openai_fim_compatible = {
            api_key = 'LLAMA_SWAP_API_KEY',
            name = 'llama-swap',
            end_point = 'http://localhost:9292/v1/completions',
            model = 'qwen-coder-fim-fast',
            optional = { max_tokens = 128, top_p = 0.9 },
          },
        },
        virtualtext = {
          auto_trigger_ft = { '*' },
          keymap = {
            accept = '<C-y>',
            accept_line = '<A-l>',
            prev = '<A-[>',
            next = '<A-]>',
            dismiss = '<A-e>',
          },
        },
      }
    end,
  },
}
