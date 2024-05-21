local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader><leader>', builtin.find_files, {})
-- vim.keymap.set('n', '<leader>a', function()
-- 	builtin.grep_string({ search = vim.fn.input("Grep > ") });
-- end)  
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
-- vim.keymap.set('n', '<C-a>', builtin.live_grep, {})
vim.keymap.set('n', ';', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>f;', ':lua require\'telescope.builtin\'.current_buffer_fuzzy_find()<CR>', {})
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })


-- start telescope live-grep and auto-fillin current word selection
local default_opts = {noremap = true, silent = true}
vim.keymap.set('v', '<C-q>', 'y<ESC>:Telescope live_grep default_text=<c-r>0<CR>', default_opts)

-- Diffviewer
local telescope_pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local previewers = require("telescope.previewers")
local putils = require("telescope.previewers.utils")
local from_entry = require("telescope.from_entry")
local conf = require("telescope.config").values

local branch_diff = function(opts)
	return previewers.new_buffer_previewer({
		title = "Git Branch Diff Preview",
		get_buffer_by_name = function(_, entry)
			return entry.value
		end,

		define_preview = function(self, entry, _)
			local file_name = entry.value
			local get_git_status_command = "git status -s -- " .. file_name
			local git_status = io.popen(get_git_status_command):read("*a")
			local git_status_short = string.sub(git_status, 1, 1)
			if git_status_short ~= "" then
				local p = from_entry.path(entry, true)
				if p == nil or p == "" then
					return
				end
				conf.buffer_previewer_maker(p, self.state.bufnr, {
					bufname = self.state.bufname,
					winid = self.state.winid,
				})
			else
				putils.job_maker(
					{ "git", "--no-pager", "diff", opts.base_branch .. "..HEAD", "--", file_name },
					self.state.bufnr,
					{
						value = file_name,
						bufname = self.state.bufname,
					}
				)
				putils.regex_highlighter(self.state.bufnr, "diff")
			end
		end,
	})
end

vim.api.nvim_create_user_command("TelescopeDiffMaster", function()
	local command = "git diff --name-only --relative $(git merge-base master HEAD)"

	local previewer = branch_diff({ base_branch = "master" })
	local entry_maker = function(entry)
		return {
			value = entry,
			display = entry,
			ordinal = entry,
		}
	end

	local handle = io.popen(command)

	if handle == nil then
		print("could not run specified command:" .. command)
		return
	end

	local result = handle:read("*a")

	handle:close()

	local files = {}

	for token in string.gmatch(result, "[^%c]+") do
		table.insert(files, token)
	end
	local opts = {
		prompt_title = "changes from master_files",
		finder = finders.new_table({
			results = files,
			entry_maker = entry_maker,
		}),
		previewer = previewer,
	}

	telescope_pickers.new(opts):find()
end, {})
