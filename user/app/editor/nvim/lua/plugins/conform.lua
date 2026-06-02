return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			nix = { "alejandra" },
			-- python = { "isort", "black" },
			xml = { "xmlstarlet" },
			java = { "google-java-format" },
			tex = { "latexindent" },
			-- javascript = { "prettierd" },
		},
	},
}
