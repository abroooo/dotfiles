local lsp_zero = require("lsp-zero")

lsp_zero.preset("recommended")


require('mason').setup({})
require('mason-lspconfig').setup({
    -- Replace the language servers listed here 
    -- with the ones you want to install
    ensure_installed = {
	'tsserver',
	'eslint',
	'lua_ls',
	'rust_analyzer',
	'clangd',
	'pyright',
    'bashls',
},
    handlers = {
        lsp_zero.default_setup,
    },
})


require'cmp'.setup {
  sources = {
    { name = 'nvim_lsp_signature_help' },
    { name = 'nvim_lsp' },
    { name = 'buffer' }
  }
}
local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp_zero.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ["<C-Space>"] = cmp.mapping.complete(),
})
-- disable completion with tab
-- this helps with copilot setup
cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp_zero.setup_nvim_cmp({
  mapping = cmp_mappings,
  -- sources = {
  --   { name = 'nvim_lsp_signature_help' }}
})

lsp_zero.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

-- lsp_zero.on_attach(function(client, bufnr)
--     -- see :help lsp-zero-keybindings
--     -- to learn the available actions
--     lsp_zero.default_keymaps({buffer = bufnr})
-- end)
lsp_zero.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

  if client.name == "eslint" then
      vim.cmd.LspStop('eslint')
      return
  end

  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "L", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
  vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
  vim.keymap.set("i", "<C-w>", vim.lsp.buf.signature_help, opts)
end)

-- }}}
lsp_zero.configure('clangd', {
    capabilities = capabilities,
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders"
    },
    init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        clangdFileStatus = true
    },
    on_attach = on_attach,
    flags = {debounce_text_changes = 150}
})
lsp_zero.setup()

vim.diagnostic.config({
    virtual_text = true,
})

