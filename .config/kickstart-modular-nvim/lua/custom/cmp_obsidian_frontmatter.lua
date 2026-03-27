-- Custom nvim-cmp source for obsidian tags and hubs in YAML frontmatter
local source = {}

-- Cache for tags and hubs
local cache = {
  tags = {},
  hubs = {},
  last_update = 0,
}

-- Cache duration in seconds
local CACHE_DURATION = 60

-- Get all directories in hubs folder
local function get_hubs()
  local notes_path = vim.env.NOTES
  if not notes_path then
    return {}
  end

  local hubs_path = notes_path .. '/hubs'
  local handle = vim.loop.fs_scandir(hubs_path)
  if not handle then
    return {}
  end

  local hubs = {}
  while true do
    local name, type = vim.loop.fs_scandir_next(handle)
    if not name then
      break
    end
    if type == 'directory' then
      table.insert(hubs, name)
    end
  end

  table.sort(hubs)
  return hubs
end

-- Extract tags from all markdown files in the vault
local function get_tags()
  local notes_path = vim.env.NOTES
  if not notes_path then
    return {}
  end

  -- Use ripgrep to find all tags in frontmatter
  local tags_output = vim.fn.systemlist(string.format("rg --no-heading --no-filename '^tags: \\[(.+)\\]' -r '$1' %s -g '*.md'", vim.fn.shellescape(notes_path)))

  -- Parse tags
  local tags_set = {}
  for _, line in ipairs(tags_output) do
    -- Split by comma and extract individual tags
    for tag in string.gmatch(line, '([^,]+)') do
      tag = tag:match '^%s*(.-)%s*$' -- trim whitespace
      if tag and tag ~= '' then
        tags_set[tag] = true
      end
    end
  end

  -- Convert set to array
  local tags = {}
  for tag in pairs(tags_set) do
    table.insert(tags, tag)
  end

  table.sort(tags)
  return tags
end

-- Update cache
local function update_cache()
  local current_time = os.time()
  if current_time - cache.last_update < CACHE_DURATION then
    return
  end

  cache.tags = get_tags()
  cache.hubs = get_hubs()
  cache.last_update = current_time
end

-- Check if cursor is inside tags or hub array in frontmatter
local function get_completion_type()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]

  -- Check if we're in frontmatter (first 20 lines)
  local row = vim.api.nvim_win_get_cursor(0)[1]
  if row > 20 then
    return nil
  end

  -- Check if cursor is inside tags: [...]
  if line:match '^tags:%s*%[' then
    local before_cursor = line:sub(1, col)
    local after_cursor = line:sub(col + 1)
    if before_cursor:match '%[' and not before_cursor:match '%]' then
      return 'tags'
    end
    if before_cursor:match '%[' and after_cursor:match '%]' then
      return 'tags'
    end
  end

  -- Check if cursor is inside hub: [...]
  if line:match '^hub:%s*%[' then
    local before_cursor = line:sub(1, col)
    local after_cursor = line:sub(col + 1)
    if before_cursor:match '%[' and not before_cursor:match '%]' then
      return 'hubs'
    end
    if before_cursor:match '%[' and after_cursor:match '%]' then
      return 'hubs'
    end
  end

  return nil
end

source.new = function()
  return setmetatable({}, { __index = source })
end

source.get_trigger_characters = function()
  return { '[', '{', ',' }
end

source.is_available = function()
  return vim.bo.filetype == 'markdown'
end

source.complete = function(self, params, callback)
  local completion_type = get_completion_type()

  if not completion_type then
    callback { items = {}, isIncomplete = false }
    return
  end

  -- Update cache
  update_cache()

  local items = {}
  local candidates = completion_type == 'tags' and cache.tags or cache.hubs

  local kind_text = completion_type == 'tags' and 'tag' or 'hub'

  for _, item in ipairs(candidates) do
    table.insert(items, {
      label = item,
      kind = require('cmp').lsp.CompletionItemKind.Keyword,
      insertText = item,
      data = {
        kind_text = kind_text,
      },
    })
  end

  callback { items = items, isIncomplete = false }
end

return source
