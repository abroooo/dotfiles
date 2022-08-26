-- vim.o.completeopt = "menuone,noselect"
--
-- require'compe'.setup {
--     enabled = true,
--     autocomplete = true,
--     debug = false,
--     min_length = 1,
--     preselect = 'enable',
--     throttle_time = 80,
--     source_timeout = 200,
--     incomplete_delay = 400,
--     max_abbr_width = 100,
--     max_kind_width = 100,
--     max_menu_width = 100,
--     documentation = true,
--
--     source = {
--         path = {kind = "   (Path)"},
--         buffer = {kind = "   (Buffer)"},
--         calc = {kind = "   (Calc)"},
--         vsnip = {kind = "   (Snippet)"},
--         nvim_lsp = {kind = "   (LSP)"},
--         -- nvim_lua = {kind = "  "},
-- 		nvim_lua = false,
--         spell = {kind = "   (Spell)"},
--         tags = false,
--         vim_dadbod_completion = true,
--         -- snippets_nvim = {kind = "  "},
--         -- ultisnips = {kind = "  "},
--         treesitter = {kind = "  "},
--         emoji = {kind = " ﲃ  (Emoji)", filetypes={"markdown", "text"}}
--         -- for emoji press : (idk if that in compe tho)
--     }
-- }
--
-- local t = function(str)
--     return vim.api.nvim_replace_termcodes(str, true, true, true)
-- end
--
-- local check_back_space = function()
--     local col = vim.fn.col('.') - 1
--     if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
--         return true
--     else
--         return false
--     end
-- end
--
-- -- Use (s-)tab to:
-- --- move to prev/next item in completion menuone
-- --- jump to prev/next snippet's placeholder
-- _G.tab_complete = function()
--   if vim.fn.pumvisible() == 1 then
--     return t "<C-n>"
--   elseif vim.fn.call("vsnip#available", {1}) == 1 then
--     return t "<Plug>(vsnip-expand-or-jump)"
--   elseif check_back_space() then
--     return t "<Tab>"
--   else
--     return vim.fn['compe#complete']()
--   end
-- end
-- _G.s_tab_complete = function()
--   if vim.fn.pumvisible() == 1 then
--     return t "<C-p>"
--   elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
--     return t "<Plug>(vsnip-jump-prev)"
--   else
--     return t "<S-Tab>"
--   end
-- end
--
-- -- vim.api.nvim_set_keymap.map("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
-- -- vim.api.nvim_set_keymap.map("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
-- -- vim.api.nvim_set_keymap.map("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
-- -- vim.api.nvim_set_keymap.map("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
-- -- vim.api.nvim_set_keymap.map( 'i', '<Tab>', 'v:lua.tab_complete()', {  noremap = false })
-- -- vim.api.nvim_set_keymap.map( 'i', '<S-Tab>', 'v:lua.s_tab_complete()', {  noremap = false })
-- vim.api.nvim_set_keymap( 'i' , '<Tab>', 'v:lua.tab_complete()', { expr = true, noremap = false })
-- vim.api.nvim_set_keymap( 's' , '<Tab>', 'v:lua.tab_complete()', { expr = true, noremap = false })
-- vim.api.nvim_set_keymap( 'i' , '<S-Tab>', 'v:lua.s_tab_complete()', { expr = true, noremap = false })
-- vim.api.nvim_set_keymap( 's' , '<S-Tab>', 'v:lua.s_tab_complete()', { expr = true, noremap = false })
--
-- local function t(str)
--     return vim.api.nvim_replace_termcodes(str, true, true, true)
-- end
--
-- function _G.smart_tab()
--     return vim.fn.pumvisible() == 1 and t'<C-n>' or t'<Tab>'
-- end
--
-- --vim.api.nvim_set_keymap({'s', 'i'}, '<Tab>', 'v:lua.smart_tab()', {expr = true, noremap = true})
--
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
    { name = "path" }
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

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})
--     
-- Setup nvim-cmp.
local status_ok, npairs = pcall(require, "nvim-autopairs")
if not status_ok then
  return
end

npairs.setup {
  check_ts = true,
  ts_config = {
    lua = { "string", "source" },
    javascript = { "string", "template_string" },
    java = false,
  },
  disable_filetype = { "TelescopePrompt", "spectre_panel" },
  fast_wrap = {
    map = "<M-e>",
    chars = { "{", "[", "(", '"', "'" },
    pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
    offset = 0, -- Offset from pattern match
    end_key = "$",
    keys = "qwertyuiopzxcvbnmasdfghjkl",
    check_comma = true,
    highlight = "PmenuSel",
    highlight_grey = "LineNr",
  },
}

local cmp_autopairs = require "nvim-autopairs.completion.cmp"
local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  return
end
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })

-- if vim.g.snippets ~="luasnip" then
--     return
-- end
--
-- local ls = require "luasnip"
-- local types = require "luasnip.util.types"
--
-- -- source ("/home/admin/.config/nvim/after/plugin/luasnip.lua")
--
-- ls.config.set_config{
--     history = true,
--
--     updateevents = "TextChanged, TextChangedI",
--
--     enable_autosnippets = true
-- }
--
--
-- vim.keymap.set("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/after/plugin/luasnip.lua<CR>")
--
local ls = require("luasnip") --{{{

-- require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })
require("luasnip").config.setup({ store_selection_keys = "<A-p>" })

vim.cmd([[command! LuaSnipEdit :lua require("luasnip.loaders.from_lua").edit_snippet_files()]]) --}}}

-- Virtual Text{{{
local types = require("luasnip.util.types")
ls.config.set_config({
	history = true, --keep around last snippet local to jump back
	updateevents = "TextChanged,TextChangedI", --update changes as you type
	enable_autosnippets = true,
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { "●", "GruvboxOrange" } },
			},
		},
		-- [types.insertNode] = {
		-- 	active = {
		-- 		virt_text = { { "●", "GruvboxBlue" } },
		-- 	},
		-- },
	},
}) --}}}

-- Key Mapping --{{{

vim.keymap.set({ "i", "s" }, "<c-s>", "<Esc>:w<cr>")
vim.keymap.set({ "i", "s" }, "<c-u>", '<cmd>lua require("luasnip.extras.select_choice")()<cr><C-c><C-c>')

vim.keymap.set({ "i", "s" }, "<a-p>", function()
	if ls.expand_or_jumpable() then
		ls.expand()
	end
end, { silent = true })
-- vim.keymap.set({ "i", "s" }, "<C-k>", function()
-- 	if ls.expand_or_jumpable() then
-- 		ls.expand_or_jump()
-- 	end
-- end, { silent = true })
-- vim.keymap.set({ "i", "s" }, "<C-j>", function()
-- 	if ls.jumpable() then
-- 		ls.jump(-1)
-- 	end
-- end, { silent = true })

vim.keymap.set({ "i", "s" }, "<A-y>", "<Esc>o", { silent = true })

vim.keymap.set({ "i", "s" }, "<a-k>", function()
	if ls.jumpable(1) then
		ls.jump(1)
	end
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<a-j>", function()
	if ls.jumpable(-1) then
		ls.jump(-1)
	end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<a-l>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	else
		-- print current time
		local t = os.date("*t")
		local time = string.format("%02d:%02d:%02d", t.hour, t.min, t.sec)
		print(time)
	end
end)
vim.keymap.set({ "i", "s" }, "<a-h>", function()
	if ls.choice_active() then
		ls.change_choice(-1)
	end
end) --}}}

-- More Settings --

vim.keymap.set("n", "<Leader><CR>", "<cmd>LuaSnipEdit<cr>", { silent = true, noremap = true })
vim.cmd([[autocmd BufEnter */snippets/*.lua nnoremap <silent> <buffer> <CR> /-- End Refactoring --<CR>O<Esc>O]])
-- source ("/home/admin/.config/nvim/after/plugin/luasnip.lua")
local ls = require"luasnip"
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local fmt = require("luasnip.extras.fmt").fmt
local m = require("luasnip.extras").m
local lambda = require("luasnip.extras").l
local postfix = require("luasnip.extras.postfix").postfix
ls.add_snippets("all", {
	s("ternary", {
		-- equivalent to "${1:cond} ? ${2:then} : ${3:else}"
		i(1, "cond"), t(" ? "), i(2, "then"), t(" : "), i(3, "else")
	}),
	s("cout", {
		-- equivalent to "${1:cond} ? ${2:then} : ${3:else}"
		i(1, "cond"), t(" ? "), i(2, "then"), t(" : "), i(3, "else")
	})
})
