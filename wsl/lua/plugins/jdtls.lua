return {
	"mfussenegger/nvim-jdtls",
	ft = { "java" },

	config = function(_, opts)
		local function attach_jdtls()
			local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
			local data_dir = os.getenv("XDG_CACHE_HOME") .. "nvim/jdtls/" .. project_name .. "/workspace"

			local config = {
				cmd = { "jdtls", "-data", data_dir },

				root_dir = vim.fn.getcwd(),
				init_options = {
					bundles = {
						vim.fn.glob(
							"/home/avie/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-0.53.2.jar"
						),
					},
				},
			}

			config["on_attach"] = function(client, bufnr)
				require("jdtls").setup_dap({ hotcodereplace = "auto" })
			end

			-- Existing server will be reused if the root_dir matches.
			require("jdtls").start_or_attach(config)
		end

		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "java" },
			callback = attach_jdtls,
		})

		-- vim.api.nvim_create_autocmd("LspAttach", {
		-- 	callback = function(args)
		-- 		-- custom init for Java debugger
		-- 		require("jdtls").setup_dap()
		-- 		require("jdtls.dap").setup_dap_main_class_configs()
		-- 	end,
		-- })
		local key_map = function(mode, key, result)
			vim.api.nvim_set_keymap(mode, key, result, { noremap = true, silent = true })
		end

		function get_javafx_runner(debug)
			local debug_param = ""
			if debug then
				debug_param = "@debug"
			end

			return "mvn javafx:run" .. debug_param
		end

		function run_javafx(debug)
			vim.cmd("term " .. get_javafx_runner(debug))
		end

		vim.keymap.set("n", "<F9>", function()
			run_javafx()
		end)
		vim.keymap.set("n", "<F10>", function()
			run_javafx(true)
		end)

		-- setup debug
		key_map("n", "<leader>b", ':lua require"dap".toggle_breakpoint()<CR>')
		key_map("n", "<leader>B", ':lua require"dap".set_breakpoint(vim.fn.input("Condition: "))<CR>')
		key_map("n", "<leader>bl", ':lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log: "))<CR>')
		key_map("n", "<leader>dr", ':lua require"dap".repl.open()<CR>')

		-- view informations in debug
		function show_dap_centered_scopes()
			local widgets = require("dap.ui.widgets")
			widgets.centered_float(widgets.scopes)
		end
		key_map("n", "gs", ":lua show_dap_centered_scopes()<CR>")

		-- move in debug
		key_map("n", "<F5>", ':lua require"dap".continue()<CR>')
		key_map("n", "<F6>", ':lua require"dap".step_over()<CR>')
		key_map("n", "<F7>", ':lua require"dap".step_into()<CR>')
		key_map("n", "<F8>", ':lua require"dap".step_out()<CR>')

		function attach_to_debug()
			local dap = require("dap")
			dap.configurations.java = {
				{
					type = "java",
					request = "attach",
					name = "Attach to the process",
					hostName = "localhost",
					port = "5005",
				},
			}
			dap.continue()
		end

		key_map("n", "<leader>da", ":lua attach_to_debug()<CR>")

		attach_jdtls()
	end,
}
