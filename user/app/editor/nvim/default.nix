{
  pkgs,
  lib,
  inputs,
  ...
}: let
  LazyVimNorm = {
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

  LazyVimCustom = {
    enable = true;
    settings.vim = {
      viAlias = true;
      vimAlias = true;

      useSystemClipboard = true;

      spellcheck = {
        enable = true;
      };

      lsp = {
        enable = true;
        formatOnSave = true;
        lspkind.enable = false;
        lightbulb.enable = true;
        lspsaga.enable = false;
        trouble.enable = true;
        lspSignature.enable = false;
        otter-nvim.enable = true;
      };

      #   nvim-dap = {
      #     enable = true;
      #     ui.enable = true;
      #   };
      # };
      binds.whichKey = {
        setupOpts = {
          preset = "helix";
          defaults = {};
          spec = lib.generators.mkLuaInline ''
            {
              {
                mode = { "n", "v" },
                { "<leader><tab>", group = "tabs" },
                { "<leader>c", group = "code" },
                { "<leader>d", group = "debug" },
                { "<leader>dp", group = "profiler" },
                { "<leader>f", group = "file/find" },
                { "<leader>g", group = "git" },
                { "<leader>gh", group = "hunks" },
                { "<leader>q", group = "quit/session" },
                { "<leader>s", group = "search" },
                { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
                { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
                { "[", group = "prev" },
                { "]", group = "next" },
                { "g", group = "goto" },
                { "gs", group = "surround" },
                { "z", group = "fold" },
                {
                  "<leader>b",
                  group = "buffer",
                  expand = function()
                    return require("which-key.extras").expand.buf()
                  end,
                },
                {
                  "<leader>w",
                  group = "windows",
                  proxy = "<c-w>",
                  expand = function()
                    return require("which-key.extras").expand.win()
                  end,
                },
                -- better descriptions
                { "gx", desc = "Open with system app" },
              },
            }'';
        };
        enable = true;
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

      # tabline = {
      #   nvimBufferline.enable = true;
      # };
      # autocomplete = {
      #   blink-cmp.enable = true;
      # };
      utility = {
        motion = {
          # flash-nvim.enable = true;
          # precognition.enable = true;
        };
        snacks-nvim = {
          setupOpts = {
            notifier = {
              enabled = true;
              timeout = 3000;
            };
            explorer = {enabled = true;};
            picker = {enabled = true;};
            dashboard = lib.generators.mkLuaInline ''               {
                   preset = {
                     pick = function(cmd, opts)
                       return LazyVim.pick(cmd, opts)()
                     end,
                     header = [[
                        .-') _   ('-.                     (`-.           _   .-')    
                        ( OO ) )_(  OO)                  _(OO  )_        ( '.( OO )_  
                    ,--./ ,--,'(,------. .-'),-----. ,--(_/   ,. \ ,-.-') ,--.   ,--.)
                    |   \ |  |\ |  .---'( OO'  .-.  '\   \   /(__/ |  |OO)|   `.'   | 
                    |    \|  | )|  |    /   |  | |  | \   \ /   /  |  |  \|         | 
                    |  .     |/(|  '--. \_) |  |\|  |  \   '   /,  |  |(_/|  |'.'|  | 
                    |  |\    |  |  .--'   \ |  | |  |   \     /__),|  |_.'|  |   |  | 
                    |  | \   |  |  `---.   `'  '-'  '    \   /   (_|  |   |  |   |  | 
                    `--'  `--'  `------'     `-----'      `-'      `--'   `--'   `--' 
              ]],
                     -- stylua: ignore
                     ---@type snacks.dashboard.Item[]
                     keys = {
                       { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
                       { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                       { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
                       { icon = " ", key = "p", desc = "Projects", action = ":lua Snacks.picker.projects()" },
                       { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
                       { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
                       { icon = " ", key = "s", desc = "Restore Session", section = "session" },
                       { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
                       { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
                       { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                     },
                   },
                 }'';
          };
          enable = true;
        };
      };

      # autopairs.nvim-autopairs.enable = true;
      # extraPackages = with pkgs; [
      #   ripgrep
      #   ast-grep
      #   unzip
      #   wget
      #   tree-sitter
      #   ghostscript
      #   tectonic
      #   wl-clipboard
      #   gcc
      #   fd
      #   lazygit
      #   fzf
      #   unar
      #   sqlfluff
      #   lua-language-server
      #   stylua
      # ];
      #
      # extraPlugins = {
      #   lazyvim = {
      #     package = pkgs.vimPlugins.lazy-nvim;
      #     setup = let
      #       plugins = with pkgs.vimPlugins; [
      #         friendly-snippets
      #         gitsigns-nvim
      #         grug-far-nvim
      #         lualine-nvim
      #         lazydev-nvim
      #         noice-nvim
      #         nui-nvim
      #         nvim-lint
      #         nvim-lspconfig
      #         nvim-treesitter
      #         nvim-treesitter-textobjects
      #         nvim-ts-autotag
      #         persistence-nvim
      #         plenary-nvim
      #         todo-comments-nvim
      #         tokyonight-nvim
      #         trouble-nvim
      #         which-key-nvim
      #         snacks-nvim
      #         mini-ai
      #         mini-icons
      #         mini-pairs
      #         ts-comments-nvim
      #         {
      #           name = "LuaSnip";
      #           path = luasnip;
      #         }
      #         {
      #           name = "catppuccin";
      #           path = catppuccin-nvim;
      #         }
      #         mini-nvim
      #       ];
      #       mkEntryFromDrv = drv:
      #         if lib.isDerivation drv
      #         then {
      #           name = "${lib.getName drv}";
      #           path = drv;
      #         }
      #         else drv;
      #       lazyPath = pkgs.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);
      #     in ''
      #       require("lazy").setup({
      #         defaults = {
      #           lazy = false,
      #         },
      #         dev = {
      #           -- reuse files from pkgs.vimPlugins.*
      #           path = "${lazyPath}",
      #           patterns = { "" },
      #           -- fallback to download
      #           fallback = true,
      #         },
      #       })
      #     '';
      #   };
      # };
    };
  };
in {
  imports = [
    inputs.nvf.homeManagerModules.default
  ];
  programs.neovim.enable = true;
  programs.nvf = LazyVimCustom;
}
