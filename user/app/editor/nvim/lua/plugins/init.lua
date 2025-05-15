return {
	{
		"echasnovski/mini.base16",
		config = function()
			require("mini.base16").setup({
				palette = {
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
				},
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
				nil_ls = {},
				-- nixd = {
				-- 	nixpkgs = {
				-- 		expr = "import <nixpkgs> { }",
				-- 	},
				-- 	options = {
				-- 		nixos = {
				-- 			expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.k-on.options',
				-- 		},
				-- 		home_manager = {
				-- 			expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."ruixi@k-on".options',
				-- 		},
				-- 	},
				-- },
			},
		},
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				nix = { "alejandra" },
			},
		},
	},
}
