return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'rouge8/neotest-rust',
    'mfussenegger/nvim-dap',
  },
  config = function()
    local neotest = require 'neotest'
    local dap = require 'dap'

    -- Ensure codelldb adapter is configured for DAP
    if not dap.adapters.codelldb then
      local mason_registry = require 'mason-registry'
      local codelldb = mason_registry.get_package 'codelldb'
      local extension_path = codelldb:get_install_path() .. '/extension'
      local codelldb_path = extension_path .. '/adapter/codelldb'

      dap.adapters.codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
          command = codelldb_path,
          args = { '--port', '${port}' },
        },
      }
    end

    -- Configure DAP for Rust
    if not dap.configurations.rust then
      dap.configurations.rust = {
        {
          name = 'Launch',
          type = 'codelldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
        },
      }
    end

    neotest.setup {
      adapters = {
        require 'neotest-rust' {
          args = { '--no-capture' },
          dap_adapter = 'codelldb',
        },
      },
      default_strategy = 'integrated',
      diagnostic = {
        enabled = true,
        severity = 1,
      },
      discovery = {
        concurrent = 1,
        enabled = true,
      },
      floating = {
        border = 'rounded',
        max_height = 0.6,
        max_width = 0.6,
        options = {},
      },
      highlights = {
        adapter_name = 'NeotestAdapterName',
        border = 'NeotestBorder',
        dir = 'NeotestDir',
        expand_marker = 'NeotestExpandMarker',
        failed = 'NeotestFailed',
        file = 'NeotestFile',
        focused = 'NeotestFocused',
        indent = 'NeotestIndent',
        marked = 'NeotestMarked',
        namespace = 'NeotestNamespace',
        passed = 'NeotestPassed',
        running = 'NeotestRunning',
        select_win = 'NeotestWinSelect',
        skipped = 'NeotestSkipped',
        target = 'NeotestTarget',
        test = 'NeotestTest',
        unknown = 'NeotestUnknown',
        watching = 'NeotestWatching',
      },
      icons = {
        child_indent = '│',
        child_prefix = '├',
        collapsed = '─',
        expanded = '╮',
        failed = '✖',
        final_child_indent = ' ',
        final_child_prefix = '╰',
        non_collapsible = '─',
        passed = '✓',
        running = '🗘',
        running_animated = { '/', '|', '\\', '-', '/', '|', '\\', '-' },
        skipped = '↓',
        unknown = '?',
        watching = '👁',
      },
      log_level = 3,
      output = {
        enabled = true,
        open_on_run = 'short',
      },
      output_panel = {
        enabled = true,
        open = 'botright split | resize 15',
      },
      projects = {},
      quickfix = {
        enabled = true,
        open = false,
      },
      run = {
        enabled = true,
      },
      running = {
        concurrent = true,
      },
      status = {
        enabled = true,
        signs = true,
        virtual_text = false,
      },
      strategies = {
        integrated = {
          height = 40,
          width = 120,
        },
      },
      summary = {
        animated = true,
        enabled = true,
        expand_errors = true,
        follow = true,
        mappings = {
          attach = 'a',
          clear_marked = 'M',
          clear_target = 'T',
          debug = 'd',
          debug_marked = 'D',
          expand = { '<CR>', '<2-LeftMouse>' },
          expand_all = 'e',
          help = '?',
          jumpto = 'i',
          mark = 'm',
          next_failed = 'J',
          output = 'o',
          prev_failed = 'K',
          run = 'r',
          run_marked = 'R',
          short = 's',
          stop = 'u',
          target = 't',
          watch = 'w',
        },
        open = 'botright vsplit | vertical resize 50',
      },
      watch = {
        enabled = true,
        symbol_queries = {
          rust = [[(
            (mod_item
              name: (identifier) @namespace.name)
            (function_item
              name: (identifier) @function.name)
            (macro_invocation
              macro: (identifier) @_macro_name
              (token_tree) @_args
              (#eq? @_macro_name "test")
            )
          )]],
        },
      },
    }

    -- Key mappings
    local keymap = vim.keymap.set

    -- Test running
    keymap('n', '<leader>tr', function()
      neotest.run.run()
    end, { desc = 'Run nearest test' })

    keymap('n', '<leader>tf', function()
      neotest.run.run(vim.fn.expand '%')
    end, { desc = 'Run tests in current file' })

    keymap('n', '<leader>td', function()
      neotest.run.run { strategy = 'dap' }
    end, { desc = 'Debug nearest test' })

    keymap('n', '<leader>tl', function()
      neotest.run.run_last()
    end, { desc = 'Run last test' })

    keymap('n', '<leader>ts', function()
      neotest.run.stop()
    end, { desc = 'Stop test' })

    keymap('n', '<leader>ta', function()
      neotest.run.attach()
    end, { desc = 'Attach to test' })

    -- Test output and summary
    keymap('n', '<leader>to', function()
      neotest.output.open { enter = true, auto_close = true }
    end, { desc = 'Show test output' })

    keymap('n', '<leader>tO', function()
      neotest.output_panel.toggle()
    end, { desc = 'Toggle output panel' })

    keymap('n', '<leader>tt', function()
      neotest.summary.toggle()
    end, { desc = 'Toggle test summary' })

    -- Test watching
    keymap('n', '<leader>tw', function()
      neotest.watch.toggle(vim.fn.expand '%')
    end, { desc = 'Toggle watch tests' })

    -- Test navigation
    keymap('n', ']t', function()
      neotest.jump.next { status = 'failed' }
    end, { desc = 'Jump to next failed test' })

    keymap('n', '[t', function()
      neotest.jump.prev { status = 'failed' }
    end, { desc = 'Jump to previous failed test' })
  end,
}
