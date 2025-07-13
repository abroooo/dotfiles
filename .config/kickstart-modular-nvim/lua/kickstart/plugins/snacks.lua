return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      animate = { enabled = true },
      bigfile = { enabled = true },
      dashboard = {
        enabled = true,
        sections = vim.tbl_filter(function(item)
          return item ~= nil
        end, {
          { section = 'header' },
          { section = 'keys', gap = 1, padding = 1 },

          -- Obsidian integration sections (controlled by environment variables)
          vim.env.DASHBOARD_SHOW_DAILY_NOTE ~= '0'
              and function()
                local today = os.date '%Y-%m-%d'
                local notes_dir = vim.env.NOTES or vim.fn.expand '~/notes'
                return {
                  pane = 2,
                  icon = ' ',
                  title = "Today's Note",
                  section = 'terminal',
                  cmd = string.format(
                    "if [ -f %s/journals/%s.md ]; then echo 'Daily note: %s'; else echo 'No daily note yet - press [d] to create'; fi",
                    notes_dir,
                    today,
                    today
                  ),
                  height = 2,
                  padding = 1,
                  ttl = 60, -- Cache for 1 minute
                }
              end
            or nil,

          vim.env.DASHBOARD_SHOW_TASKS ~= '0'
              and function()
                local notes_dir = vim.env.NOTES or vim.fn.expand '~/notes'
                local tasks_dir = vim.env.DASHBOARD_TASKS_DIR or '0_inbox'
                return {
                  pane = 2,
                  icon = '󰸞 ',
                  title = 'Incomplete Tasks',
                  section = 'terminal',
                  cmd = string.format(
                    "grep -r '- \\[ \\]' %s 2>/dev/null | head -5 | sed 's/.*://' | sed 's/^[[:space:]]*//' || echo 'No incomplete tasks found'",
                    notes_dir .. '/' .. tasks_dir
                  ),
                  height = 6,
                  padding = 1,
                  ttl = 5 * 60, -- Cache for 5 minutes
                }
              end
            or nil,

          vim.env.DASHBOARD_SHOW_RECENT ~= '0'
              and function()
                local notes_dir = vim.env.NOTES or vim.fn.expand '~/notes'
                return {
                  pane = 2,
                  icon = ' ',
                  title = 'Recent Notes',
                  section = 'terminal',
                  cmd = string.format(
                    "find %s -name '*.md' -type f -exec ls -t {} + 2>/dev/null | head -5 | xargs -I {} basename {} .md || echo 'No notes found'",
                    notes_dir
                  ),
                  height = 6,
                  padding = 1,
                  ttl = 2 * 60, -- Cache for 2 minutes
                }
              end
            or nil,

          vim.env.DASHBOARD_SHOW_IDEAS ~= '0'
              and function()
                local notes_dir = vim.env.NOTES or vim.fn.expand '~/notes'
                local idea_tag = vim.env.DASHBOARD_IDEA_TAG or 'idea'
                return {
                  pane = 2,
                  icon = '💡',
                  title = 'Idea Notes',
                  section = 'terminal',
                  cmd = string.format(
                    "find %s -name '*.md' -type f -exec grep -l '^tags:.*%s' {} \\; 2>/dev/null | xargs -I {} basename {} .md | sed 's/^/💡 /' || echo 'No idea notes found'",
                    notes_dir,
                    idea_tag
                  ),
                  height = 12,
                  padding = 1,
                  ttl = 5 * 60, -- Cache for 5 minutes
                  indent = 2,
                }
              end
            or nil,

          { section = 'startup' },
        }),

        preset = {
          header = [[
                                                     
       ∩───∩                                        
      (  ◕   ◕ )     ╭─────────────────────────╮    
       ○_____○       │    Welcome to Neovim!   │    
                     ╰─────────────────────────╯    
           ∩─────∩                                  
          ( ◉     ◉)                               
           ○─────○                                  
                                                     
    ～～～～～～～～～～～～～～～～～～～～～～～～～    
                                                     ]],
          keys = vim.tbl_filter(function(item)
            return item ~= nil
          end, {
            { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
            vim.env.DASHBOARD_SHOW_OBSIDIAN_KEYS ~= '0' and { icon = ' ', key = 'o', desc = 'Open Vault', action = ':ObsidianQuickSwitch' } or nil,
            vim.env.DASHBOARD_SHOW_OBSIDIAN_KEYS ~= '0' and { icon = ' ', key = 'd', desc = 'Daily Note', action = ':ObsidianToday' } or nil,
            vim.env.DASHBOARD_SHOW_OBSIDIAN_KEYS ~= '0' and { icon = ' ', key = 's', desc = 'Search Notes', action = ':ObsidianSearch' } or nil,
            vim.env.DASHBOARD_SHOW_OBSIDIAN_KEYS ~= '0' and { icon = ' ', key = 'n', desc = 'New Note', action = ':ObsidianNew' } or nil,
            vim.env.DASHBOARD_SHOW_IDEAS ~= '0' and {
              icon = '💡',
              key = 'i',
              desc = 'Idea Notes',
              action = function()
                local notes_dir = vim.env.NOTES or vim.fn.expand '~/notes'
                local idea_tag = vim.env.DASHBOARD_IDEA_TAG or 'idea'
                local cmd = string.format("find %s -name '*.md' -type f -exec grep -l '^tags:.*%s' {} \\; 2>/dev/null", notes_dir, idea_tag)
                local handle = io.popen(cmd)
                local result = handle:read '*a'
                handle:close()

                local files = {}
                for file in result:gmatch '[^\r\n]+' do
                  table.insert(files, file)
                end

                if #files == 0 then
                  vim.notify('No idea notes found', vim.log.levels.INFO)
                  return
                end

                vim.ui.select(files, {
                  prompt = 'Select idea note:',
                  format_item = function(item)
                    return '💡 ' .. vim.fn.fnamemodify(item, ':t:r')
                  end,
                }, function(choice)
                  if choice then
                    vim.cmd('edit ' .. vim.fn.fnameescape(choice))
                  end
                end)
              end,
            } or nil,
            { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = ' ', key = 'g', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = ' ', key = 'c', desc = 'Config', action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = '󰒲 ', key = 'L', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
            { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
          }),
        },
      },
      image = { enabled = false, inline = true, float = false },
      indent = { enabled = true },
      input = { enabled = true, icon = ' ', icon_hl = 'SnacksInputIcon', win = { style = 'input' }, expand = true },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      git = { enabled = true },
      quickfile = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      styles = {
        notification = {
          -- wo = { wrap = true } -- Wrap notifications
        },
      },
    },
    keys = {
      {
        '<leader>z',
        function()
          Snacks.zen()
        end,
        desc = 'Toggle Zen Mode',
      },
      {
        '<leader>Z',
        function()
          Snacks.zen.zoom()
        end,
        desc = 'Toggle Zoom',
      },
      {
        '<leader>.',
        function()
          Snacks.scratch()
        end,
        desc = 'Toggle Scratch Buffer',
      },
      {
        '<leader>S',
        function()
          Snacks.scratch.select()
        end,
        desc = 'Select Scratch Buffer',
      },
      {
        '<leader>n',
        function()
          Snacks.notifier.show_history()
        end,
        desc = 'Notification History',
      },
      {
        '<leader>bd',
        function()
          Snacks.bufdelete()
        end,
        desc = 'Delete Buffer',
      },
      {
        '<leader>cR',
        function()
          Snacks.rename.rename_file()
        end,
        desc = 'Rename File',
      },
      {
        '<leader>gB',
        function()
          Snacks.gitbrowse()
        end,
        desc = 'Git Browse',
      },
      {
        '<leader>gb',
        function()
          Snacks.git.blame_line()
        end,
        desc = 'Git Blame Line',
      },
      {
        '<leader>gf',
        function()
          Snacks.lazygit.log_file()
        end,
        desc = 'Lazygit Current File History',
      },
      {
        '<leader>gg',
        function()
          Snacks.lazygit()
        end,
        desc = 'Lazygit',
      },
      {
        '<leader>gl',
        function()
          Snacks.lazygit.log()
        end,
        desc = 'Lazygit Log (cwd)',
      },
      {
        '<leader>un',
        function()
          Snacks.notifier.hide()
        end,
        desc = 'Dismiss All Notifications',
      },
      {
        '<c-/>',
        function()
          Snacks.terminal()
        end,
        desc = 'Toggle Terminal',
      },
      {
        '<c-_>',
        function()
          Snacks.terminal()
        end,
        desc = 'which_key_ignore',
      },
      {
        ']]',
        function()
          Snacks.words.jump(vim.v.count1)
        end,
        desc = 'Next Reference',
        mode = { 'n', 't' },
      },
      {
        '[[',
        function()
          Snacks.words.jump(-vim.v.count1)
        end,
        desc = 'Prev Reference',
        mode = { 'n', 't' },
      },
      {
        '<leader>N',
        desc = 'Neovim News',
        function()
          Snacks.win {
            file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1],
            width = 0.6,
            height = 0.6,
            wo = {
              spell = false,
              wrap = false,
              signcolumn = 'yes',
              statuscolumn = ' ',
              conceallevel = 3,
            },
          }
        end,
      },
    },
    init = function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>us'
          Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>uw'
          Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>uL'
          Snacks.toggle.diagnostics():map '<leader>ud'
          Snacks.toggle.line_number():map '<leader>ul'
          Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map '<leader>uc'
          Snacks.toggle.treesitter():map '<leader>uT'
          Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map '<leader>ub'
          Snacks.toggle.inlay_hints():map '<leader>uh'
          Snacks.toggle.indent():map '<leader>ug'
          Snacks.toggle.dim():map '<leader>uD'
        end,
      })
    end,
  },
}
