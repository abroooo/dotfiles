-- lsp setup
-- Set Default Prefix.
-- Note: You can set a prefix per lsp server in the lv-globals.lua file
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {
      prefix = "",
      spacing = 0,
    },
    signs = true,
    underline = true,
  }
)
-- symbols for autocomplete
vim.lsp.protocol.CompletionItemKind = {
    "   (Text) ",
    "   (Method)",
    "   (Function)",
    "   (Constructor)",
    " ﴲ  (Field)",
    "[] (Variable)",
    "   (Class)",
    " ﰮ  (Interface)",
    "   (Module)",
    " 襁 (Property)",
    "   (Unit)",
    "   (Value)",
    " 練 (Enum)",
    "   (Keyword)",
    "   (Snippet)",
    "   (Color)",
    "   (File)",
    "   (Reference)",
    "   (Folder)",
    "   (EnumMember)",
    " ﲀ  (Constant)",
    " ﳤ  (Struct)",
    "   (Event)",
    "   (Operator)",
    "   (TypeParameter)"
}

local function documentHighlight(client, bufnr)
-- Set autocommands conditional on server_capabilities
if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec(
        [[
  hi LspReferenceRead cterm=bold ctermbg=red guibg=#464646
  hi LspReferenceText cterm=bold ctermbg=red guibg=#464646
  hi LspReferenceWrite cterm=bold ctermbg=red guibg=#464646
  augroup lsp_document_highlight
    autocmd! * <buffer>
    autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
    autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
  augroup END
]],
        false
    )
end
end


local lsp_installer_servers = require'nvim-lsp-installer.servers'

local server_available, requested_server = lsp_installer_servers.get_server("yamlls, rust_analyzer, pyright, clangd")
if server_available then
requested_server:on_ready(function ()
    local opts = {}
    requested_server:setup(opts)
end)
if not requested_server:is_installed() then
    -- Queue the server to be installed
    requested_server:install()
end
end
-- require'lspinstall'.setup() -- important
-- 
-- 
-- 
-- 
-- local lsp_config = {}
-- 
-- function lsp_config.common_on_attach(client, bufnr)
--     documentHighlight(client, bufnr)
-- end
-- function lsp_config.tsserver_on_attach(client, bufnr)
--     lsp_config.common_on_attach(client, bufnr)
--     client.resolved_capabilities.document_formatting = false
-- end
-- 
-- local function setup_servers()
--   require'lspinstall'.setup()
--   local servers = require'lspinstall'.installed_servers()
--   for _, server in pairs(servers) do
--     require'lspconfig'[server].setup{}
--   end
-- end
-- 
-- setup_servers()
-- 
-- -- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
-- require'lspinstall'.post_install_hook = function ()
--   setup_servers() -- reload installed servers
--   vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
-- end



local sumneko_root_path = '/home/theprimeagen/personal/lua-language-server'
local sumneko_binary = sumneko_root_path .. "/bin/Linux/lua-language-server"

local function on_attach()
-- TODO: TJ told me to do this and I should do it because he is Telescopic
-- "Big Tech" "Cash Money" Johnson
end

require'lspconfig'.tsserver.setup{ on_attach=on_attach }
require'lspconfig'.clangd.setup {
on_attach = on_attach,
root_dir = function() return vim.loop.cwd() end
}


--require'lspconfig'.pyls.setup{ on_attach=on_attach }
require'lspconfig'.pylsp.setup{}

require'lspconfig'.svelte.setup{}

require'lspconfig'.yamlls.setup{}

require'lspconfig'.gopls.setup{
on_attach=on_attach,
cmd = {"gopls", "serve"},
settings = {
    gopls = {
        analyses = {
            unusedparams = true,
        },
        staticcheck = true,
    },
},
}
-- who even uses this?
require'lspconfig'.rust_analyzer.setup{ on_attach=on_attach }

local opts = {
-- whether to highlight the currently hovered symbol
-- disable if your cpu usage is higher than you want it
-- or you just hate the highlight
-- default: true
highlight_hovered_item = true,

-- whether to show outline guides
-- default: true
show_guides = true,
}

require'lspconfig'.clangd.setup {
--    on_attach = on_attach,
--    root_dir = function() return vim.loop.cwd() end
--    on_attach = require'completion'.on_attach;
    capabilities = snippetSupport,
    cmd = { "clangd", "--background-index", "--cross-file-rename", "--compile-commands-dir=./build"},
   filetypes = { "c", "cpp", "objc", "objcpp" },
--    on_init = function to handle changing offsetEncoding
--   root_dir = root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
   root_dir = require'lspconfig'.util.root_pattern("./build/compile_commands.json", "compile_flags.txt", ".git"),
}


-- ##################################################################
-- cmp
-- ##################################################################
local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
  return
end

local kind_icons = require("user.icons").kind

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_snipmate").lazy_load()

local check_backspace = function()
  local col = vim.fn.col "." - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

-- find more here: https://www.nerdfonts.com/cheat-sheet

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = {
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<C-j>"] = cmp.mapping.select_next_item(),
    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ["<C-e>"] = cmp.mapping {
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    },
    -- Accept currently selected item. If none selected, `select` first item.
    -- Set `select` to `false` to only confirm explicitly selected items.
    ["<CR>"] = cmp.mapping.confirm { select = true },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expandable() then
        luasnip.expand()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif check_backspace() then
        fallback()
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
  },
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      -- Kind icons
      vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
      -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
      -- This concatonates the icons with the name of the item kind
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        luasnip = "[Snippet]",
        buffer = "[Buffer]",
        path = "[Path]",
      })[entry.source.name]
      return vim_item
    end,
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  },
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },
  window = {
    documentation = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    }
  },
  experimental = {
    ghost_text = false,
    native_menu = false,
  },
}
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
