-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to force a plugin to be loaded.
  --

  -- modular approach: using `require 'path/name'` will
  -- include a plugin definition from file lua/path/name.lua
  {
    'aaronhallaert/advanced-git-search.nvim',
    cmd = { 'AdvancedGitSearch' },
    config = function()
      -- optional: setup telescope before loading the extension
      require('telescope').setup {
        -- move this to the place where you call the telescope setup function
        extensions = {
          advanced_git_search = {
            -- See Config
          },
        },
      }

      require('telescope').load_extension 'advanced_git_search'
    end,
    dependencies = {
      --- See dependencies
    },
    {
      'saecki/crates.nvim',
      tag = 'stable',
      config = function()
        require('crates').setup()
      end,
    },
  },
  -- rustacean.nvim configuration is handled in lua/kickstart/plugins/rustacean.lua
  require 'kickstart/plugins/rustacean',

  {
    'Bekaboo/dropbar.nvim',
    -- optional, but required for fuzzy finder support
    dependencies = {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
    },
    config = function()
      local dropbar_api = require 'dropbar.api'
      vim.keymap.set('n', '<Leader>;', dropbar_api.pick, { desc = 'Pick symbols in winbar' })
      vim.keymap.set('n', '[;', dropbar_api.goto_context_start, { desc = 'Go to start of current context' })
      vim.keymap.set('n', '];', dropbar_api.select_next_context, { desc = 'Select next context' })
    end,
  },

  {
    'sunaku/tmux-navigate',
    config = function()
      vim.g.tmux_navigator_no_mappings = 1 -- Disable default keybindings to avoid conflict with Neovim
    end,
  },
  {
    '3rd/image.nvim',
    opts = {},
    cond = function()
      -- Check if the `magick` command is available
      return vim.fn.executable 'magick' == 1
    end,
  },
  -- },
  -- {
  -- rocks = {
  --   hererocks = true, -- recommended if you do not have global installation of Lua 5.1.
  -- },
  { 'github/copilot.vim' },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'github/copilot.vim' }, -- or zbirenbaum/copilot.lua
      { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
    },
    build = 'make tiktoken', -- Only on MacOS or Linux
    opts = {
      -- See Configuration section for options
    },
    -- See Commands section for default commands if you want to lazy load on them
  },

  {
    'rebelot/kanagawa.nvim',
  },
  { 'nvim-treesitter/nvim-treesitter-context' },
  require 'kickstart/plugins/gitsigns',
  require 'kickstart/plugins/avante',

  require 'kickstart/plugins/which-key',

  require 'kickstart/plugins/telescope',

  require 'kickstart/plugins/lspconfig',

  require 'kickstart/plugins/conform',

  require 'kickstart/plugins/cmp',
  { 'catppuccin/nvim', name = 'catppuccin', priority = 1000 },

  require 'kickstart/plugins/tokyonight',

  require 'kickstart/plugins/todo-comments',

  require 'kickstart/plugins/mini',

  require 'kickstart/plugins/treesitter',

  require 'kickstart/plugins/nvimtree',
  require 'kickstart/plugins/noice',
  require 'kickstart/plugins/snacks',
  require 'kickstart/plugins/trouble',
  require 'kickstart/plugins/neogit',
  require 'kickstart/plugins/obsidian',
  require 'kickstart/plugins/lualine',
  require 'kickstart/plugins/flash',
  require 'kickstart/plugins/diffview',
  require 'kickstart/plugins/neotest',

  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {},
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  },
  { 'mbbill/undotree' },
  {
    'hedyhli/outline.nvim',
    config = function()
      -- Example mapping to toggle outline
      vim.keymap.set('n', '<leader>ol', '<cmd>Outline<CR>', { desc = 'Toggle Outline' })

      require('outline').setup {
        outline_window = {
          position = 'right',
          width = 25,
          relative_width = true,
          auto_close = false,
          auto_jump = false,
          jump_highlight_duration = 300,
          center_on_jump = true,
          show_numbers = false,
          show_relative_numbers = false,
          wrap = false,
          show_cursorline = true,
          hide_cursor = false,
          focus_on_open = false,
          winhl = '',
        },
        outline_items = {
          show_symbol_details = true,
          show_symbol_lineno = false,
          highlight_hovered_item = true,
          auto_set_cursor = true,
          auto_unfold_hover = true,
          fold_markers = { '', '' },
          guide_markers = { '│', '└' },
        },
        symbol_folding = {
          autofold_depth = 1,
          auto_unfold = {
            hovered = true,
            only = true,
          },
          markers = { '', '' },
        },
        preview_window = {
          auto_preview = false,
          open_hover_on_preview = false,
          width = 50,
          min_width = 50,
          relative_width = true,
          border = 'single',
          winhl = 'NormalFloat:',
          winblend = 0,
          live = false,
        },
        keymaps = {
          show_help = '?',
          close = {'<Esc>', 'q'},
          goto_location = '<Cr>',
          peek_location = 'o',
          goto_and_close = '<S-Cr>',
          restore_location = '<C-g>',
          hover_symbol = '<C-space>',
          toggle_preview = 'K',
          rename_symbol = 'r',
          code_actions = 'a',
          fold = 'h',
          unfold = 'l',
          fold_toggle = '<Tab>',
          fold_toggle_all = '<S-Tab>',
          fold_all = 'W',
          unfold_all = 'E',
          fold_reset = 'R',
          down_and_jump = '<C-j>',
          up_and_jump = '<C-k>',
        },
        providers = {
          priority = { 'lsp', 'coc', 'markdown', 'norg' },
          lsp = {
            blacklist_clients = {},
          },
        },
        symbols = {
          icons = {
            File = { icon = '󰈙', hl = 'Identifier' },
            Module = { icon = '󰆧', hl = 'Include' },
            Namespace = { icon = '󰅪', hl = 'Include' },
            Package = { icon = '󰏗', hl = 'Include' },
            Class = { icon = '𝓒', hl = 'Type' },
            Method = { icon = 'ƒ', hl = 'Function' },
            Property = { icon = '', hl = 'Identifier' },
            Field = { icon = '󰆨', hl = 'Identifier' },
            Constructor = { icon = '', hl = 'Special' },
            Enum = { icon = 'ℰ', hl = 'Type' },
            Interface = { icon = '󰜰', hl = 'Type' },
            Function = { icon = '', hl = 'Function' },
            Variable = { icon = '', hl = 'Constant' },
            Constant = { icon = '', hl = 'Constant' },
            String = { icon = '𝓐', hl = 'String' },
            Number = { icon = '#', hl = 'Number' },
            Boolean = { icon = '⊨', hl = 'Boolean' },
            Array = { icon = '󰅪', hl = 'Constant' },
            Object = { icon = '⦿', hl = 'Type' },
            Key = { icon = '🔐', hl = 'Type' },
            Null = { icon = 'NULL', hl = 'Type' },
            EnumMember = { icon = '', hl = 'Identifier' },
            Struct = { icon = '𝓢', hl = 'Structure' },
            Event = { icon = '🗲', hl = 'Type' },
            Operator = { icon = '+', hl = 'Identifier' },
            TypeParameter = { icon = '𝙏', hl = 'Identifier' },
            Component = { icon = '󰅴', hl = 'Function' },
            Fragment = { icon = '󰅴', hl = 'Constant' },
            TypeAlias = { icon = ' ', hl = 'Type' },
            Parameter = { icon = ' ', hl = 'Identifier' },
            StaticMethod = { icon = ' ', hl = 'Function' },
            Macro = { icon = ' ', hl = 'Function' },
          },
        },
      }
    end,
  },

  { 'ThePrimeagen/git-worktree.nvim' },
  { 'akinsho/toggleterm.nvim', version = '*', config = true },
  { 'kevinhwang91/nvim-ufo', dependencies = 'kevinhwang91/promise-async' },
  { 'preservim/vim-pencil' },
  { 'folke/twilight.nvim' },
  { 'aliou/bats.vim' },
  { 'f-person/git-blame.nvim' },
  { 'theprimeagen/harpoon' },
  { -- TODO: need to configure this!
    'ray-x/lsp_signature.nvim',
  },
  {
    'folke/zen-mode.nvim',
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  -- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
  -- require 'kickstart.plugins.autopairs',
  -- require 'kickstart.plugins.neo-tree',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  -- { import = 'custom.plugins' },
  --
  -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
  -- Or use telescope!
  -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
  -- you can continue same window with `<space>sr` which resumes last telescope search
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- Note: rust-analyzer is handled by rustacean.nvim, not by lspconfig directly
-- This configuration is handled in the rustacean.nvim setup above

local function check_imagemagick()
  local handle = io.popen 'which identify'
  local result = handle:read '*a'
  handle:close()
  return result ~= ''
end
