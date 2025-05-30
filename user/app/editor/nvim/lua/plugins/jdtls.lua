return {
	"mfussenegger/nvim-jdtls",
	ft = { "java" },

    -- stylua: ignore
    keys = {
      { "<leader>dj", function() require("jdtls").test_class() end, desc = "Debug class" },
    },

	config = function(_, opts)
		local function attach_jdtls()
			local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
			local data_dir = ".cache/nvim/jdtls/" .. project_name .. "/workspace"
			local fname = vim.api.nvim_buf_get_name(0)

			local config = {
				cmd = { "jdtls", "-data", data_dir },
				-- root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew" }),
				root_dir = opts.root_dir(fname),

				-- root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
			}
			-- Existing server will be reused if the root_dir matches.
			require("jdtls").start_or_attach(config)
		end

		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "java" },
			callback = attach_jdtls,
		})

		attach_jdtls()
	end,
}
