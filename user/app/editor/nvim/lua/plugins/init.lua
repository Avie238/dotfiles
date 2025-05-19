return {
	{
		"RRethy/base16-nvim",
		config = function()
			require("base16-colorscheme").setup({
				base00 = nixCats.settings.colors.base00,
				base01 = nixCats.settings.colors.base01,
				base02 = nixCats.settings.colors.base02,
				base03 = nixCats.settings.colors.base03,
				base04 = nixCats.settings.colors.base04,
				base05 = nixCats.settings.colors.base05,
				base06 = nixCats.settings.colors.base06,
				base07 = nixCats.settings.colors.base07,
				base08 = nixCats.settings.colors.base08,
				base09 = nixCats.settings.colors.base09,
				base0A = nixCats.settings.colors.base0A,
				base0B = nixCats.settings.colors.base0B,
				base0C = nixCats.settings.colors.base0C,
				base0D = nixCats.settings.colors.base0D,
				base0E = nixCats.settings.colors.base0E,
				base0F = nixCats.settings.colors.base0F,
			})
		end,
	},
	{
		"tris203/precognition.nvim",
		opts = {},
	},
	{ "catppuccin/nvim", enabled = false },
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				basedpyright = {},
				nixd = {
					nixpkgs = {
						expr = "import <nixpkgs> { }",
					},
					options = {
						nixos = {
							expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.k-on.options',
						},
						home_manager = {
							expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."ruixi@k-on".options',
						},
					},
				},
			},
		},
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				nix = { "alejandra" },
				python = { "isort", "black" },
			},
		},
	},
	{
		"snacks.nvim",
		opts = {
			dashboard = {
				preset = {
					pick = function(cmd, opts)
						return LazyVim.pick(cmd, opts)()
					end,
					header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
        -- stylua: ignore
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "p", desc = "Projects", action = ":lua Snacks.picker.projects()" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
				},
				sections = {
					{ section = "header", padding = 1 },
					{
						section = "terminal",
						cmd = "pokemon-colorscripts -n sylveon --no-title; sleep .1",
						indent = 15,
						height = 16,
					},
					{ section = "keys", gap = 1, padding = 1 },
					{ section = "startup" },
				},
			},
		},
	},
}
