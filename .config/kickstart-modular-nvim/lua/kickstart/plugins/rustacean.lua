return {
  'mrcjkb/rustaceanvim',
  version = '^5',
  lazy = false,
  ft = { 'rust' },
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    local capabilities = vim.tbl_deep_extend(
      'force',
      vim.lsp.protocol.make_client_capabilities(),
      require('cmp_nvim_lsp').default_capabilities()
    )
    
    vim.g.rustaceanvim = {
      server = {
        capabilities = capabilities,
        -- Use the stable toolchain's rust-analyzer, not Mason's stale standalone
        -- binary. Stable RA (1.98+) is >= every toolchain's proc-macro server
        -- (incl. the esp fork), so it loads proc-macros without ABI mismatch.
        -- cargo is still selected per-project by the rustup proxy on PATH.
        cmd = { 'rustup', 'run', 'stable', 'rust-analyzer' },
        on_attach = function(client, bufnr)
          vim.keymap.set('n', '<leader>cR', function()
            vim.cmd.RustLsp('codeAction')
          end, { desc = 'Code Action', buffer = bufnr })
          vim.keymap.set('n', '<leader>dr', function()
            vim.cmd.RustLsp('debuggables')
          end, { desc = 'Rust Debuggables', buffer = bufnr })
        end,
        default_settings = {
          ['rust-analyzer'] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            checkOnSave = {
              allFeatures = true,
              command = 'clippy',
              extraArgs = { '--no-deps' },
            },
            procMacro = {
              enable = true,
              ignored = {
                ['async-trait'] = { 'async_trait' },
                ['napi-derive'] = { 'napi' },
                ['async-recursion'] = { 'async_recursion' },
              },
            },
          },
        },
      },
    }
    
    if vim.fn.executable('rust-analyzer') == 0 then
      vim.notify(
        'rust-analyzer not found in PATH, please install it.\nhttps://rust-analyzer.github.io/manual.html#installation',
        vim.log.levels.ERROR
      )
    end
  end,
}