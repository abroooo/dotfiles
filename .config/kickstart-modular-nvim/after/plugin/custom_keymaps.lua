-- Custom keymaps

-- Insert new log section with today's date and prepare list item
vim.keymap.set('n', '<leader>tt', function()
  local lines = {}

  local date = os.date '%Y-%m-%d'
  table.insert(lines, '### ' .. date)
  table.insert(lines, '- ')

  vim.api.nvim_put(lines, 'l', true, true)
  vim.schedule(function()
    vim.cmd 'normal! $'
    vim.cmd 'startinsert!'
  end)
end, { desc = '[T]ime[T]amp log section' })

-- Add log line to daily log
--
-- Insert a new journal log line at the top of today's log section
vim.keymap.set('n', '<leader>ll', function()
  local vault = '/home/alex/git/notes/journals/'
  local daily_path = vault .. os.date('%Y-%m-%d') .. '.md'

  -- Open today's note if we're not already on it
  if vim.fn.expand('%:p') ~= daily_path then
    vim.cmd('edit ' .. vim.fn.fnameescape(daily_path))
  end

  -- Locate the log region and the "### Log" header inside it.
  -- Plain equality, NOT find(): "-" is a Lua pattern metachar, so
  -- find('<!-- ... -->') can never match.
  local start, end_ = -1, -1
  for i, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
    if line == '<!-- START OF LOG -->' then
      start = i
    elseif start > 0 and line == '<!-- END OF LOG -->' then
      end_ = i
    end
  end

  local header = -1
  if start > 0 and end_ > 0 then
    for i = start, end_ do
      if vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]:match('^### Log%s*$') then
        header = i
        break
      end
    end
  end

  if header == -1 then
    vim.notify('No "### Log" section found in today\'s daily note', vim.log.levels.WARN)
    return
  end

  local text = '- ' .. os.date('%H%M') .. ' #journal '
  -- Insert the new line directly below "### Log" (latest on top).
  -- Empty replace range [header, header] (0-indexed) = pure insertion.
  vim.api.nvim_buf_set_lines(0, header, header, false, { text })

  -- Put cursor at end of the new line and drop into insert mode.
  vim.fn.cursor(header + 1, #text + 1)
  vim.cmd('startinsert!')
end, { desc = '[L]og [L]ine (new journal entry)' })

--
--
-- <leader>lc — auto-resolve git merge conflicts in a daily note's log section.
-- Rules (using git's common ancestor, stage 1 of the unmerged index):
--   * entry added on only one side                -> keep
--   * identical line on both sides                -> keep once
--   * ancestor entry missing/reduced on a side    -> changed/deleted -> ask you
local resolve_log_conflicts = function()
  local auto_stage = true -- write + `git add` when every hunk was auto-resolved

  local file = vim.fn.expand('%:p')
  if file == '' then
    vim.notify('No file is open in this buffer', vim.log.levels.WARN)
    return
  end

  -- Must be an unmerged file, otherwise git has no common ancestor to diff against.
  local stages_raw = vim.fn.system({ 'git', 'ls-files', '--unmerged', '--', file })
  if type(stages_raw) ~= 'string' or stages_raw == '' then
    vim.notify('File is not in a git merge conflict', vim.log.levels.WARN)
    return
  end

  -- Parse stage records: "<mode> <sha> <stage>\t<path>". Stage 1 = common ancestor.
  local ancestor_sha, nstages = nil, 0
  for line in stages_raw:gmatch('[^\n]+') do
    local _, sha, stage = line:match('^([%x]+)%s+([%x]+)%s+([%d])')
    if stage and sha then
      nstages = nstages + 1
      if stage == '1' then ancestor_sha = sha end
    end
  end
  -- If we can't read the stages, never guess: leave everything to you.
  if nstages == 0 then
    vim.notify('Could not read git merge stages - left untouched', vim.log.levels.ERROR)
    return
  end

  -- Ancestor copy counts per line (nil ancestor = add/add conflict => all additions).
  local cA = {}
  if ancestor_sha then
    local out = vim.fn.system({ 'git', 'cat-file', '-p', ancestor_sha })
    if type(out) ~= 'string' then out = '' end
    for l in out:gmatch('[^\r\n]+') do
      cA[l] = (cA[l] or 0) + 1
    end
  end

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  -- Log section bounds. Plain '=': "-" is a Lua pattern metachar!
  local log_start, log_end = -1, -1
  for i, l in ipairs(lines) do
    if l == '<!-- START OF LOG -->' then
      log_start = i
    elseif log_start > 0 and l == '<!-- END OF LOG -->' then
      log_end = i
    end
  end

  -- Locate conflict hunks
  local hunks = {}
  for i = 1, #lines do
    if lines[i]:match('^<<<<<<< ') then
      local h = { start = i }
      for j = i + 1, #lines do
        if lines[j] == '=======' then h.mid = j break end
      end
      if h.mid then
        for j = h.mid + 1, #lines do
          if lines[j]:match('^>>>>>>> ') then h.last = j break end
        end
      end
      if h.mid and h.last then table.insert(hunks, h) end
    end
  end

  if #hunks == 0 then
    vim.notify('No conflict markers in this buffer', vim.log.levels.WARN)
    return
  end

  local function entry_time(l)
    local d = l:match('^%s*%-[^0-9]*(%d%d%d%d)') -- "- HHMM" / "- [x] HHMM"
    return d and tonumber(d) or nil
  end

  local function counts(list)
    local m = {}
    for _, l in ipairs(list) do m[l] = (m[l] or 0) + 1 end
    return m
  end

  local resolved, manual = 0, {}
  for k = #hunks, 1, -1 do -- bottom-up so line numbers stay valid
    local h = hunks[k]
    if h.start < log_start or h.last > log_end then
      table.insert(manual, 'line ' .. h.start .. ': outside the log section')
    else
      local ours, theirs = {}, {}
      for i = h.start + 1, h.mid - 1 do table.insert(ours, lines[i]) end
      for i = h.mid + 1, h.last - 1 do table.insert(theirs, lines[i]) end
      local cO, cT = counts(ours), counts(theirs)

      -- Changed/deleted: a line present in the ancestor is now missing (or reduced)
      -- on one side. User decides those.
      local bad, why = false, nil
      for l in pairs(cO) do
        if cA[l] and (cT[l] or 0) < cA[l] then
          bad, why = true, ('entry changed/deleted: "%s"'):format(l:sub(1, 60))
        end
      end
      if not bad then
        for l in pairs(cT) do
          if cA[l] and (cO[l] or 0) < cA[l] then
            bad, why = true, ('entry changed/deleted: "%s"'):format(l:sub(1, 60))
          end
        end
      end

      if bad then
        table.insert(manual, 'line ' .. h.start .. ': ' .. why)
      else
        -- Keep all of our copies plus only the EXTRA theirs copies (dedup identical).
        local items = {}
        for idx, l in ipairs(ours) do
          table.insert(items, { t = entry_time(l), n = idx, l = l })
        end
        local taken = {}
        for idx, l in ipairs(theirs) do
          local keep = cT[l] - math.min(cO[l] or 0, cT[l])
          taken[l] = taken[l] or 0
          if taken[l] < keep then
            table.insert(items, { t = entry_time(l), n = 10000 + idx, l = l })
            taken[l] = taken[l] + 1
          end
        end
        table.sort(items, function(a, b)
          if (a.t or -1) ~= (b.t or -1) then return (a.t or -1) > (b.t or -1) end
          return a.n < b.n
        end)
        local result = {}
        for _, it in ipairs(items) do table.insert(result, it.l) end
        vim.api.nvim_buf_set_lines(0, h.start - 1, h.last, false, result)
        resolved = resolved + 1
      end
    end
  end

  if #manual == 0 and auto_stage then
    vim.cmd('w')
    vim.cmd('silent! !git add ' .. vim.fn.fnameescape(file))
  end

  local msg = resolved .. ' hunk(s) auto-resolved, ' .. #manual .. ' need manual review'
  for _, m in ipairs(manual) do msg = msg .. '\n  * ' .. m end
  vim.notify(msg, #manual > 0 and vim.log.levels.WARN or vim.log.levels.INFO)

  if #manual > 0 then
    local first = math.huge
    for _, m in ipairs(manual) do
      local n = tonumber(m:match('^line (%d+)'))
      if n and n < first then first = n end
    end
    if first ~= math.huge then vim.fn.cursor(first, 1) end
  end
end

vim.keymap.set('n', '<leader>lc', resolve_log_conflicts, { desc = '[L]og [C]onflict resolve' })

--
--
-- <leader>lm — alternative resolver: rebuild the log section from git's merge
-- stages instead of parsing in-buffer conflict markers.
--   stage 1 = common ancestor (base), 2 = ours, 3 = theirs
-- Rules:
--   * entry added on either/both sides        -> keep (union, identical dedup)
--   * entries sharing a timestamp              -> keep both (distinct lines)
--   * ancestor entry changed/deleted on a side -> ask you (manual)
--   * anything conflicting outside the log     -> ask you (manual)
local resolve_log_from_stages = function()
  local file = vim.fn.expand('%:p')
  if file == '' then
    vim.notify('No file is open in this buffer', vim.log.levels.WARN)
    return
  end
  local dir = vim.fn.fnamemodify(file, ':h')

  -- Collect the unmerged stage SHAs (base/ours/theirs) for this file.
  local raw = vim.fn.system({ 'git', '-C', dir, 'ls-files', '-u', '--', file })
  if vim.v.shell_error ~= 0 or raw == '' then
    vim.notify('File is not in a git merge conflict', vim.log.levels.WARN)
    return
  end
  local sha = {}
  for mode, s, st in raw:gmatch('(%x+)%s+(%x+)%s+(%d)\t') do
    local _ = mode
    sha[st] = s
  end
  if not (sha['2'] and sha['3']) then
    vim.notify('Add/delete conflict (missing a side) - resolve manually', vim.log.levels.WARN)
    return
  end

  local function blob(s)
    if not s then return nil end
    local out = vim.fn.system({ 'git', '-C', dir, 'cat-file', '-p', s })
    if vim.v.shell_error ~= 0 then return nil end
    local ls = vim.split(out, '\n', { plain = true })
    if ls[#ls] == '' then ls[#ls] = nil end
    return ls
  end

  -- Split a file into pre | log-body | post around the LOG markers.
  -- Plain '==': "-" is a Lua pattern metachar, so find() can't match the markers.
  local function split(ls)
    local s, e
    for i, l in ipairs(ls) do
      if l == '<!-- START OF LOG -->' then s = i
      elseif s and l == '<!-- END OF LOG -->' then e = i break end
    end
    if not (s and e) then return nil end
    local pre, body, post = {}, {}, {}
    for i = 1, s do pre[#pre + 1] = ls[i] end
    for i = s + 1, e - 1 do body[#body + 1] = ls[i] end
    for i = e, #ls do post[#post + 1] = ls[i] end
    return pre, body, post
  end

  local base_ls, ours_ls, theirs_ls = blob(sha['1']), blob(sha['2']), blob(sha['3'])
  if not (ours_ls and theirs_ls) then
    vim.notify('Could not read git merge stages - left untouched', vim.log.levels.ERROR)
    return
  end
  local bP, bB, bPost
  if base_ls then bP, bB, bPost = split(base_ls) end
  local oP, oB, oPost = split(ours_ls)
  local tP, tB, tPost = split(theirs_ls)
  if not (oP and tP) then
    vim.notify('LOG markers missing in a merge stage - resolve manually', vim.log.levels.WARN)
    return
  end

  local function eq(a, b) return a and b and table.concat(a, '\n') == table.concat(b, '\n') end
  -- 3-way pick for the non-log regions: auto when at most one side changed.
  local function merge3(bs, o, t)
    if eq(o, t) then return o end
    if bs and eq(o, bs) then return t end
    if bs and eq(t, bs) then return o end
    return nil
  end
  local pre = merge3(bP, oP, tP)
  local post = merge3(bPost, oPost, tPost)
  if not pre or not post then
    vim.notify('Conflicting change outside the log section - resolve manually', vim.log.levels.WARN)
    return
  end

  local function etime(l)
    local d = l:match('^%s*%-[^0-9]*(%d%d%d%d)') -- "- HHMM" / "- [x] HHMM"
    return d and tonumber(d) or nil
  end
  local function entries(body)
    local list, set = {}, {}
    for _, l in ipairs(body or {}) do
      if etime(l) then list[#list + 1] = l; set[l] = true end
    end
    return list, set
  end

  local oList, oSet = entries(oB)
  local tList, tSet = entries(tB)
  local _, bSet = entries(bB)

  -- Any ancestor entry gone from a side = changed/deleted -> you decide.
  for l in pairs(bSet) do
    if not oSet[l] or not tSet[l] then
      vim.notify('Log entry changed/deleted - resolve manually:\n  * ' .. l:sub(1, 70), vim.log.levels.WARN)
      return
    end
  end

  -- Union (identical lines dedup), newest timestamp first.
  local merged, seen = {}, {}
  for _, l in ipairs(oList) do if not seen[l] then seen[l] = true; merged[#merged + 1] = l end end
  for _, l in ipairs(tList) do if not seen[l] then seen[l] = true; merged[#merged + 1] = l end end
  table.sort(merged, function(a, b)
    local ta, tb = etime(a) or -1, etime(b) or -1
    if ta ~= tb then return ta > tb end
    return a < b
  end)

  -- Rebuild the body: keep ours' structural lines, drop its entries, splice
  -- merged entries right below the "### Log" header.
  local newbody, inserted = {}, false
  for _, l in ipairs(oB) do
    if not etime(l) then
      newbody[#newbody + 1] = l
      if l:match('^###%s+Log%s*$') then
        for _, m in ipairs(merged) do newbody[#newbody + 1] = m end
        inserted = true
      end
    end
  end
  if not inserted then
    for _, m in ipairs(merged) do newbody[#newbody + 1] = m end
  end

  local out = {}
  for _, l in ipairs(pre) do out[#out + 1] = l end
  for _, l in ipairs(newbody) do out[#out + 1] = l end
  for _, l in ipairs(post) do out[#out + 1] = l end

  vim.api.nvim_buf_set_lines(0, 0, -1, false, out)
  vim.cmd('write')
  vim.fn.system({ 'git', '-C', dir, 'add', '--', file })
  vim.notify((#merged) .. ' log entr(y/ies) merged, conflict resolved', vim.log.levels.INFO)
end

vim.keymap.set('n', '<leader>lm', resolve_log_from_stages, { desc = '[L]og [M]erge (stage-based resolve)' })
