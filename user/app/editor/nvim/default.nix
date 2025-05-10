{
  pkgs,
  lib,
  ...
}: {
  programs.neovim.enable = true;
  programs.nvf = {
    enable = true;
    settings.vim = {
      useSystemClipboard = true;
      lsp = {
        enable = true;
        formatOnSave = true;
        lspkind.enable = false;
        lightbulb.enable = true;
        lspsaga.enable = false;
        trouble.enable = true;
        lspSignature.enable = true;
        otter-nvim.enable = true;
      };

      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;

        nix.enable = true;
        markdown.enable = true;
        bash.enable = true;
        css.enable = true;
        html.enable = true;
        sql.enable = true;
        java.enable = true;
        ts.enable = true;
        lua.enable = true;
        python = {
          enable = true;
          format.type = "black-and-isort";
        };
      };

      extraPackages = with pkgs; [
        ripgrep
        ast-grep
        unzip
        wget
        tree-sitter
        ghostscript
        tectonic
        wl-clipboard
        gcc
        fd
        lazygit
        fzf
        unar
        sqlfluff
        lua-language-server
        stylua
      ];

      extraPlugins = {
        lazyvim = {
          package = pkgs.vimPlugins.lazy-nvim;
          setup = let
            plugins = with pkgs.vimPlugins; [
              LazyVim
              bufferline-nvim
              blink-cmp
              conform-nvim
              flash-nvim
              friendly-snippets
              gitsigns-nvim
              grug-far-nvim
              lualine-nvim
              lazydev-nvim
              noice-nvim
              nui-nvim
              nvim-lint
              nvim-lspconfig
              nvim-treesitter
              nvim-treesitter-textobjects
              nvim-ts-autotag
              persistence-nvim
              plenary-nvim
              precognition-nvim
              todo-comments-nvim
              tokyonight-nvim
              trouble-nvim
              which-key-nvim
              snacks-nvim
              mini-ai
              mini-icons
              mini-pairs
              ts-comments-nvim
              {
                name = "LuaSnip";
                path = luasnip;
              }
              {
                name = "catppuccin";
                path = catppuccin-nvim;
              }
              mini-nvim
            ];
            mkEntryFromDrv = drv:
              if lib.isDerivation drv
              then {
                name = "${lib.getName drv}";
                path = drv;
              }
              else drv;
            lazyPath = pkgs.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);
          in ''
            require("lazy").setup({
              defaults = {
                lazy = false,
              },
              dev = {
                -- reuse files from pkgs.vimPlugins.*
                path = "${lazyPath}",
                patterns = { "" },
                -- fallback to download
                fallback = true,
              },
              spec = {
                { "LazyVim/LazyVim", import = "lazyvim.plugins", opts = { colorscheme = function() end } },
                {"tris203/precognition.nvim", opts = {}},
                { "nvim-treesitter/nvim-treesitter", enabled = false },
                { "williamboman/mason-lspconfig.nvim", enabled = false },
                { "williamboman/mason.nvim", enabled = false },
              },
            })
          '';
        };
      };
    };
  };
}
