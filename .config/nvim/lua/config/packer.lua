-- This file can be loaded by calling `lua require('plugins')` from your init.vim
-- print("hello form packer config")

 -- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {'norcalli/nvim-colorizer.lua'}
    use {
	    'nvim-telescope/telescope.nvim', tag = '0.1.4',
	    -- or                            , branch = '0.1.x',
	    requires = { {'nvim-lua/plenary.nvim'} }
    }
    use({
	    'rose-pine/neovim',
	    as = 'rose-pine',
	    config = function()
		    vim.cmd('colorscheme rose-pine')
	    end
    })
    use ( 'folke/tokyonight.nvim' )
    use { "catppuccin/nvim", as = "catppuccin" }
    use { "folke/twilight.nvim"}

    use ( 'sunaku/tmux-navigate' )
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    }
    use ( 'nvim-treesitter/playground')
    use ( 'nvim-treesitter/nvim-treesitter-context')
    use ( 'stsewd/tree-sitter-comment')
    use ( 'aliou/bats.vim')
    use ( 'theprimeagen/harpoon')
    use ( 'mbbill/undotree')
	use {"akinsho/toggleterm.nvim", tag = '*', config = function()
		require("toggleterm").setup()
	end}
    use {
        'VonHeikemen/fine-cmdline.nvim',
        requires = {
            {'MunifTanjim/nui.nvim'}
        }
    }

    use {
        "ahmedkhalf/project.nvim",
        config = function()
            require("project_nvim").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    }

    use 'simrat39/symbols-outline.nvim'
    use({
        "epwalsh/obsidian.nvim",
        tag = "*",  -- recommended, use latest release instead of latest commit
        requires = {
            -- Required.
            "nvim-lua/plenary.nvim",

            -- see below for full list of optional dependencies 👇
        },
        config = function()
            require("obsidian").setup({
                workspaces = {
                    {
                        name = "personal",
                        path = "~/git/personal_notes2.wiki_logseq",
                    },
                },

                -- see below for full list of options 👇
            })
        end,
    })
    use {
	    'VonHeikemen/lsp-zero.nvim',
	    requires = {
		    -- LSP Support
		    {'neovim/nvim-lspconfig'},
		    {'williamboman/mason.nvim'},
		    {'williamboman/mason-lspconfig.nvim'},

		    -- Autocompletion
		    {'hrsh7th/nvim-cmp'},
		    {'hrsh7th/cmp-buffer'},
		    {'hrsh7th/cmp-path'},
		    {'saadparwaiz1/cmp_luasnip'},
		    {'hrsh7th/cmp-nvim-lsp'},
		    {'hrsh7th/cmp-nvim-lua'},
		    {'hrsh7th/cmp-nvim-lsp-signature-help'},

		    -- Snippets
		    {'L3MON4D3/LuaSnip'},
		    {'rafamadriz/friendly-snippets'},
	    }

    }
    use {'folke/todo-comments.nvim',
    requires = { 'nvim-lua/plenary.nvim'},
    -- config = function()
    -- end
    }
    use {'folke/trouble.nvim',
    requires = { 'nvim-tree/nvim-web-devicons'}
    }
    use {'simrat39/rust-tools.nvim'}
    use {'tpope/vim-fugitive'}
    use {'junegunn/gv.vim',
        requires = { 'tpope/vim-fugitive'}
    }
    use "sindrets/diffview.nvim"
    use "ThePrimeagen/git-worktree.nvim"
    use {
        'lewis6991/gitsigns.nvim',
        -- tag = 'release' -- To use the latest release (do not use this if you run Neovim nightly or dev builds!)
        config = function()
            require('gitsigns').setup()
        end
    }
    use { "anuvyklack/windows.nvim",
    requires = {
        "anuvyklack/middleclass",
        "anuvyklack/animation.nvim"
    },
    config = function()
        vim.o.winwidth = 10
        vim.o.winminwidth = 10
        vim.o.equalalways = false
        require('windows').setup()
    end
}
	use {
		'nvim-tree/nvim-tree.lua',
		requires = {
			'nvim-tree/nvim-web-devicons', -- optional, for file icons
		},
		tag = 'nightly' -- optional, updated every week. (see issue #1193)
	}
    use {
        'numToStr/Navigator.nvim',
        config = function()
            require('Navigator').setup()
        end
    }
	use {
		"ahmedkhalf/lsp-rooter.nvim",
		config = function()
			require("lsp-rooter").setup {
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			}
		end
	}
	-- TODO: need to configure this!
	use {
		"ray-x/lsp_signature.nvim",
	}
	use {'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async'}
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }
	use {'ggandor/leap.nvim', requires = 'tpope/vim-repeat', }

--     use {
--         "nvim-neorg/neorg",
--         config = function()
--             require('neorg').setup {
--                 load = {
--                     ["core.defaults"] = {}, -- Loads default behaviour
--                     ["core.norg.concealer"] = {}, -- Adds pretty icons to your documents
--                     ["core.norg.dirman"] = { -- Manages Neorg workspaces
--                     config = {
--                         workspaces = {
--                             notes = "~/notes",
--                         },
--                     },
--                 },
--             },
--         }
--     end,
--     run = ":Neorg sync-parsers",
--     requires = "nvim-lua/plenary.nvim",
--     }
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }
    use { "alexghergh/nvim-tmux-navigation" }
    use {'rcarriga/nvim-notify'}
    use { "David-Kunz/gen.nvim" }
    use {
        'cameron-wags/rainbow_csv.nvim',
        config = function()
            require 'rainbow_csv'.setup()
        end,
        -- optional lazy-loading below
        module = {
            'rainbow_csv',
            'rainbow_csv.fns'
        },
        ft = {
            'csv',
            'tsv',
            'csv_semicolon',
            'csv_whitespace',
            'csv_pipe',
            'rfc_csv',
            'rfc_semicolon'
        }
    }
    -- sadads https://github.com/nvim-treesitter/nvim-treesitter/wiki/Installation sadad
    --
      use {
    'folke/noice.nvim',
    event = "VimEnter",
    requires = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("noice").setup({
        views = {
          cmdline_popup = {
            border = {
              style = "none",
              padding = { 2, 3 },
            },
            filter_options = {},
            win_options = {
              winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
            },
          },
        },
        routes = {
          {
            filter = {
              event = "cmdline",
              find = "^%s*[/?]",
            },
            view = "cmdline",
          },
        },
      })
    end
  }

end)
