return {
	"mfussenegger/nvim-dap",
    -- stylua: ignore
    keys = {
      { "<leader>dt", function() require('dap').toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<leader>dc", function() require('dap').continue() end, desc = "Continue" },
      { "<F5>", function () require("dap").continue() end, desc = "Continue" },
      { "<F6>", function () require("dap").step_over() end, desc = "Step over" },
      { "<F7>", function () require("dap").step_into() end, desc = "Step into" },
      { "<F8>", function () require("dap").step_out() end, desc = "Step out" },
    },
	-- opts = function()
	-- 	-- Simple configuration to attach to remote java debug process
	-- 	-- Taken directly from https://github.com/mfussenegger/nvim-dap/wiki/Java
	-- 	local dap = require("dap")
	-- 	dap.configurations.java = {
	-- 		{
	-- 			type = "java",
	-- 			request = "attach",
	-- 			name = "Attach to the process",
	-- 			hostName = "localhost",
	-- 			port = "5005",
	-- 		},
	-- 	}
	-- end,
	-- config = function() end,
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
