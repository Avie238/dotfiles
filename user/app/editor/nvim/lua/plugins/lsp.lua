return {
	"neovim/nvim-lspconfig",
	opts = {
		servers = {
			jinja_lsp = {},
			jdtls = {},
			vtsls = {},
			texlab = {},
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
		setup = {
			jdtls = function()
				return true -- avoid duplicate servers
			end,
		},
	},
}
