-- Marksman LSP for markdown files, configured to play nice with obsidian.nvim.
-- Native nvim-0.11+ API (vim.lsp.config/enable) to avoid the deprecated
-- `require('lspconfig')` framework.

-- True when the buffer's file lives inside an Obsidian vault (a `.obsidian/`
-- dir somewhere up the tree). Inside a vault obsidian.nvim owns completion.
local function in_obsidian_vault(bufnr)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  if fname == '' then
    return false
  end
  local found = vim.fs.find('.obsidian', {
    path = vim.fs.dirname(fname),
    upward = true,
    type = 'directory',
  })
  return #found > 0
end

local function marksman_on_attach(client, bufnr)
  -- Inside an Obsidian vault, let obsidian.nvim provide completion and silence
  -- marksman's duplicate [[link]]/#tag items. Outside a vault keep full
  -- marksman completion. Diagnostics, symbols, goto and references stay active.
  if in_obsidian_vault(bufnr) then
    client.server_capabilities.completionProvider = nil
  end

  local opts = { buffer = bufnr, silent = true }
  vim.keymap.set('n', '<leader>mo', '<cmd>Telescope lsp_document_symbols<CR>', vim.tbl_extend('force', opts, { desc = '[M]arkdown [O]utline' }))
  vim.keymap.set('n', '<leader>mr', '<cmd>Telescope lsp_references<CR>', vim.tbl_extend('force', opts, { desc = '[M]arkdown [R]eferences' }))
  vim.keymap.set('n', '<leader>md', vim.lsp.buf.definition, vim.tbl_extend('force', opts, { desc = '[M]arkdown [D]efinition' }))
  vim.keymap.set('n', '<leader>mh', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = '[M]arkdown [H]over' }))
  vim.keymap.set('n', '<leader>ms', '<cmd>Telescope lsp_dynamic_workspace_symbols<CR>', vim.tbl_extend('force', opts, { desc = '[M]arkdown [S]ymbols' }))
end

-- Register marksman once; vim.lsp.enable auto-starts it for markdown buffers.
if not vim.g._marksman_configured and vim.fn.executable 'marksman' == 1 then
  vim.g._marksman_configured = true

  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { 'documentation', 'detail', 'additionalTextEdits' },
  }

  -- Merges over the config bundled in nvim-lspconfig's lsp/marksman.lua.
  vim.lsp.config('marksman', {
    capabilities = capabilities,
    root_markers = { '.obsidian', '.marksman.toml', '.git' },
    settings = {
      marksman = {
        completion = { wiki = { enabled = true } },
        documentSymbol = { enabled = true },
        hover = { enabled = true },
        references = { enabled = true },
      },
    },
    on_attach = marksman_on_attach,
  })

  vim.lsp.enable 'marksman'
end
