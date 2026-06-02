return {
	"nvim-mini/mini.surround",
	version = false,
	config = function(_, opts)
		require("mini.surround").setup(opts)
	end,
	keys = {
		{ "gsa", desc = "Add Surrounding", mode = { "n", "x" } },
		{ "gsd", desc = "Delete Surrounding" },
		{ "gsf", desc = "Find Right Surrounding" },
		{ "gsF", desc = "Find Left Surrounding" },
		{ "gsh", desc = "Highlight Surrounding" },
		{ "gsr", desc = "Replace Surrounding" },
	},
	-- keys = function(_, keys, opts)
	-- 	-- Populate the keys based on the user's options
	-- 	local mappings = {
	-- 		{ opts.mappings.add, desc = "Add Surrounding", mode = { "n", "x" } },
	-- 		{ opts.mappings.delete, desc = "Delete Surrounding" },
	-- 		{ opts.mappings.find, desc = "Find Right Surrounding" },
	-- 		{ opts.mappings.find_left, desc = "Find Left Surrounding" },
	-- 		{ opts.mappings.highlight, desc = "Highlight Surrounding" },
	-- 		{ opts.mappings.replace, desc = "Replace Surrounding" },
	-- 		{ opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
	-- 	}
	-- 	mappings = vim.tbl_filter(function(m)
	-- 		return m[1] and #m[1] > 0
	-- 	end, mappings)
	-- 	return vim.list_extend(mappings, keys)
	-- end,
	-- No need to copy this inside `setup()`. Will be used automatically.
	-- No need to copy this inside `setup()`. Will be used automatically.
	opts = {
		-- Add custom surroundings to be used on top of builtin ones. For more
		-- information with examples, see `:h MiniSurround.config`.
		custom_surroundings = nil,

		-- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
		highlight_duration = 500,

		-- Module mappings. Use `''` (empty string) to disable one.
		mappings = {
			add = "gsa", -- Add surrounding in Normal and Visual modes
			delete = "gsd", -- Delete surrounding
			find = "gsf", -- Find surrounding (to the right)
			find_left = "gsF", -- Find surrounding (to the left)
			highlight = "gsh", -- Highlight surrounding
			replace = "gsr", -- Replace surrounding

			suffix_last = "l", -- Suffix to search with "prev" method
			suffix_next = "n", -- Suffix to search with "next" method
		},

		-- Number of lines within which surrounding is searched
		n_lines = 20,

		-- Whether to respect selection type:
		-- - Place surroundings on separate lines in linewise mode.
		-- - Place surroundings on each line in blockwise mode.
		respect_selection_type = false,

		-- How to search for surrounding (first inside current line, then inside
		-- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
		-- 'cover_or_nearest', 'next', 'prev', 'nearest'. For more details,
		-- see `:h MiniSurround.config`.
		search_method = "cover",

		-- Whether to disable showing non-error feedback
		-- This also affects (purely informational) helper messages shown after
		-- idle time if user input is required.
		silent = false,
	},
}
