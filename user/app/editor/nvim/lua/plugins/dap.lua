return {
	"mfussenegger/nvim-dap",
    -- stylua: ignore
    keys = {
      { "<leader>dt", function() require('dap').toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<leader>dc", function() require('dap').continue() end, desc = "Continue" },
    },
	opts = function()
		local dap = require("dap")
		dap.configurations.java = {
			{

				javaExec = "java",
				mainClass = "dragonfly.Main",

				-- If using the JDK9+ module system, this needs to be extended
				-- `nvim-jdtls` would automatically populate this property
				name = "Launch YourClassName",
				request = "launch",
				type = "java",
			},
		}
	end,
	dependencies = {
		{
			"mfussenegger/nvim-dap-python",
			config = function()
				require("dap-python").setup("python")
			end,
		},
		{
			"rcarriga/nvim-dap-ui",
			config = function()
				require("dapui").setup()
				local dap, dapui = require("dap"), require("dapui")
				dap.listeners.before.attach.dapui_config = function()
					dapui.open()
				end
				dap.listeners.before.launch.dapui_config = function()
					dapui.open()
				end
				dap.listeners.before.event_terminated.dapui_config = function()
					dapui.close()
				end
				dap.listeners.before.event_exited.dapui_config = function()
					dapui.close()
				end
			end,
		},
	},
}
