-- Marksman LSP specific configuration for markdown files
-- This ensures marksman works well alongside obsidian and other markdown plugins

local function setup_marksman_lsp()
  -- Check if marksman is available
  if not vim.fn.executable('marksman') then
    return
  end

  -- Get LSP capabilities with enhanced markdown support
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  
  -- Enhanced capabilities for markdown
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { 'documentation', 'detail', 'additionalTextEdits' }
  }

  -- Configure marksman specifically for this buffer
  local lspconfig = require('lspconfig')
  
  -- Only start marksman if it's not already attached
  local clients = vim.lsp.get_clients({ bufnr = 0, name = 'marksman' })
  if #clients == 0 then
    lspconfig.marksman.setup({
      capabilities = capabilities,
      filetypes = { 'markdown' },
      root_dir = function(fname)
        -- Try to find project root, fallback to file directory
        return lspconfig.util.find_git_ancestor(fname) 
            or lspconfig.util.find_package_json_ancestor(fname)
            or vim.fn.fnamemodify(fname, ':p:h')
      end,
      settings = {
        marksman = {
          completion = {
            wiki = {
              enabled = true,
            },
          },
          -- Enable document symbols for outline
          documentSymbol = {
            enabled = true,
          },
          -- Enable hover information
          hover = {
            enabled = true,
          },
          -- Enable cross-references
          references = {
            enabled = true,
          },
        },
      },
      on_attach = function(client, bufnr)
        -- Markdown-specific LSP keymaps
        local opts = { buffer = bufnr, silent = true }
        
        -- Document outline
        vim.keymap.set('n', '<leader>mo', '<cmd>Telescope lsp_document_symbols<CR>', 
          vim.tbl_extend('force', opts, { desc = '[M]arkdown [O]utline' }))
        
        -- Find references
        vim.keymap.set('n', '<leader>mr', '<cmd>Telescope lsp_references<CR>', 
          vim.tbl_extend('force', opts, { desc = '[M]arkdown [R]eferences' }))
        
        -- Go to definition (for links)
        vim.keymap.set('n', '<leader>md', vim.lsp.buf.definition, 
          vim.tbl_extend('force', opts, { desc = '[M]arkdown [D]efinition' }))
        
        -- Hover for link information
        vim.keymap.set('n', '<leader>mh', vim.lsp.buf.hover, 
          vim.tbl_extend('force', opts, { desc = '[M]arkdown [H]over' }))
        
        -- Workspace symbols (across all markdown files)
        vim.keymap.set('n', '<leader>ms', '<cmd>Telescope lsp_dynamic_workspace_symbols<CR>', 
          vim.tbl_extend('force', opts, { desc = '[M]arkdown [S]ymbols' }))

        print("Marksman LSP attached to markdown buffer")
      end,
    })
    
    -- Start the LSP client for this buffer
    vim.cmd('LspStart marksman')
  end
end

-- Set up marksman with proper timing
vim.defer_fn(setup_marksman_lsp, 200)

-- Also set up on BufEnter in case the first attempt fails
vim.api.nvim_create_autocmd('BufEnter', {
  buffer = 0,
  once = true,
  callback = function()
    local clients = vim.lsp.get_clients({ bufnr = 0, name = 'marksman' })
    if #clients == 0 then
      setup_marksman_lsp()
    end
  end,
})