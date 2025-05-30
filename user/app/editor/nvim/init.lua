require("nixCatsUtils").setup({
	non_nix_value = true,
})

local function getlockfilepath()
	if require("nixCatsUtils").isNixCats and type(nixCats.settings.unwrappedCfgPath) == "string" then
		return nixCats.settings.unwrappedCfgPath .. "/lazy-lock.json"
	else
		return vim.fn.stdpath("config") .. "/lazy-lock.json"
	end
end
local lazyOptions = {
	lockfile = getlockfilepath(),
}

-- NOTE: this the lazy wrapper. Use it like require('lazy').setup() but with an extra
-- argument, the path to lazy.nvim as downloaded by nix, or nil, before the normal arguments.
require("nixCatsUtils.lazyCat").setup(nixCats.pawsible({ "allPlugins", "start", "lazy.nvim" }), {
	{ "LazyVim/LazyVim", import = "lazyvim.plugins", opts = { colorscheme = function() end } },

	-- disable mason.nvim while using nix
	-- precompiled binaries do not agree with nixos, and we can just make nix install this stuff for us.
	{ "williamboman/mason-lspconfig.nvim", enabled = require("nixCatsUtils").lazyAdd(true, false) },
	{ "williamboman/mason.nvim", enabled = require("nixCatsUtils").lazyAdd(true, false) },
	{
		"nvim-treesitter/nvim-treesitter",
		build = require("nixCatsUtils").lazyAdd(":TSUpdate"),
		opts_extend = require("nixCatsUtils").lazyAdd(nil, false),
		opts = {
			-- nix already ensured they were installed, and we would need to change the parser_install_dir if we wanted to use it instead.
			-- so we just disable install and do it via nix.
			ensure_installed = require("nixCatsUtils").lazyAdd(
				{ "bash", "c", "diff", "html", "lua", "luadoc", "markdown", "vim", "vimdoc" },
				false
			),
			auto_install = require("nixCatsUtils").lazyAdd(true, false),
		},
	},
	{
		"folke/lazydev.nvim",
		opts = {
			library = {
				{ path = (nixCats.nixCatsPath or "") .. "/lua", words = { "nixCats" } },
			},
		},
	},
	-- import/override with your plugins
	{ import = "plugins" },
}, lazyOptions)
