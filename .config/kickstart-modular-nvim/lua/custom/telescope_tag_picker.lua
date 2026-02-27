local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local sorters = require 'telescope.sorters'
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local previewers = require 'telescope.previewers'
local scan = require 'plenary.scandir'
local Path = require 'plenary.path'

local function extract_tags(filepath)
  local file = io.open(filepath, 'r')
  if not file then
    return nil
  end

  local content = file:read '*all'
  file:close()

  local tags = content:match 'tags:%s*%[(.-)%]' -- Extract tags inside [ ]
  if not tags then
    return {}
  end

  local tag_list = {}
  for tag in tags:gmatch '[^,%s]+' do
    tag = tag:gsub('["\']', '') -- Remove quotes
    table.insert(tag_list, tag)
  end

  return tag_list
end

local function get_notes_with_tags(directory)
  local notes = {}

  -- Scan for markdown notes
  scan.scan_dir(directory, {
    depth = 2, -- Adjust depth based on your folder structure
    search_pattern = '%.md$', -- Only search Markdown files
    on_insert = function(filepath)
      local tags = extract_tags(filepath)
      if tags then
        notes[filepath] = tags
      end
    end,
  })

  return notes
end

local function tag_picker(directory)
  local notes = get_notes_with_tags(directory)
  local entries = {}

  for filepath, tags in pairs(notes) do
    for _, tag in ipairs(tags) do
      table.insert(entries, { tag = tag, filepath = filepath })
    end
  end

  pickers
    .new({}, {
      prompt_title = 'Search Notes by Tag',
      finder = finders.new_table {
        results = entries,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry.tag .. ' → ' .. Path:new(entry.filepath):make_relative(directory),
            ordinal = entry.tag,
            path = entry.filepath,
          }
        end,
      },
      sorter = sorters.get_generic_fuzzy_sorter(),
      previewer = previewers.vim_buffer_cat.new {},
      -- previewer = previewers.
      -- .new_termopen_previewer {
      -- get_command = function(entry)
      --   return { 'bat', '--style=plain', '--color=always', entry.path }
      -- end,
      -- },
      attach_mappings = function(prompt_bufnr, map)
        map('i', '<CR>', function()
          local selection = action_state.get_selected_entry()
          if selection then
            actions.close(prompt_bufnr)
            vim.cmd('edit ' .. selection.path)
          end
        end)
        return true
      end,
    })
    :find()
end

vim.api.nvim_set_keymap(
  'n',
  '<leader>ft',
  ":lua require('custom.telescope_tag_picker').tag_picker('/home/alex/git/notes')<CR>",
  { noremap = true, silent = true }
)
return {
  tag_picker = tag_picker,
}
