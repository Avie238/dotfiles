{
  config,
  lib,
  inputs,
  ...
}:
let
  utils = inputs.nixCats.utils;
in
{
  imports = [
    inputs.nixCats.homeModule
  ];
  config = {
    nixCats = {
      enable = true;
      addOverlays = # (import ./overlays inputs) ++
        [
          (utils.standardPluginOverlay inputs)
        ];
      packageNames = [ "myHomeModuleNvim" ];

      luaPath = ./.;

      categoryDefinitions.replace = (
        {
          pkgs,
          settings,
          categories,
          extra,
          name,
          mkPlugin,
          ...
        }@packageDef:
        {
          lspsAndRuntimeDeps = {
            general = with pkgs; [
              universal-ctags
              curl
              (pkgs.writeShellScriptBin "lazygit" ''
                exec ${pkgs.lazygit}/bin/lazygit --use-config-file ${pkgs.writeText "lazygit_config.yml" ""} "$@"
              '')
              ripgrep
              fd
              stdenv.cc.cc
              lua-language-server
              nil # I would go for nixd but lazy chooses this one idk
              stylua
              wl-clipboard
              nixfmt-rfc-style
            ];

          };

          startupPlugins = {
            general = with pkgs.vimPlugins; [
              lazy-nvim
              LazyVim
              bufferline-nvim
              lazydev-nvim
              conform-nvim
              flash-nvim
              friendly-snippets
              gitsigns-nvim
              grug-far-nvim
              noice-nvim
              lualine-nvim
              nui-nvim
              nvim-lint
              nvim-lspconfig
              nvim-treesitter-textobjects
              nvim-ts-autotag
              ts-comments-nvim
              blink-cmp
              nvim-web-devicons
              persistence-nvim
              plenary-nvim
              telescope-fzf-native-nvim
              telescope-nvim
              todo-comments-nvim
              tokyonight-nvim
              trouble-nvim
              vim-illuminate
              vim-startuptime
              which-key-nvim
              snacks-nvim
              nvim-treesitter-textobjects
              nvim-treesitter.withAllGrammars
              # This is for if you only want some of the grammars
              # (nvim-treesitter.withPlugins (
              #   plugins: with plugins; [
              #     nix
              #     lua
              #   ]
              # ))

              {
                plugin = catppuccin-nvim;
                name = "catppuccin";
              }
              {
                plugin = mini-ai;
                name = "mini.ai";
              }
              {
                plugin = mini-icons;
                name = "mini.icons";
              }
              {
                plugin = mini-pairs;
                name = "mini.pairs";
              }
              {
                plugin = mini-base16;
                name = "mini.base16";
              }
              {
                plugin = base16-nvim;
                name = "base16-colorscheme";
              }

            ];
          };

          python3.libraries = {
            test = [ (_: [ ]) ];
          };

          extraLuaPackages = {
            test = [ (_: [ ]) ];
          };

        }
      );

      # see :help nixCats.flake.outputs.packageDefinitions
      packageDefinitions.replace = {
        # These are the names of your packages
        # you can include as many as you wish.
        myHomeModuleNvim =
          { pkgs, name, ... }:
          {
            # they contain a settings set defined above
            # see :help nixCats.flake.outputs.settings
            settings = {
              suffix-path = true;
              suffix-LD = true;
              wrapRc = true;
              aliases = [
                "vim"
                "homeVim"
                "nvim"
              ];
              hosts.python3.enable = true;
              hosts.node.enable = true;
              colors = with config.lib.stylix.colors.withHashtag; {
                base00 = base00;
                base01 = base01;
                base02 = base02;
                base03 = base03;
                base04 = base04;
                base05 = base05;
                base06 = base06;
                base07 = base07;
                base08 = base08;
                base09 = base09;
                base0A = base0A;
                base0B = base0B;
                base0C = base0C;
                base0D = base0D;
                base0E = base0E;
                base0F = base0F;
              };
            };

            categories = {
              general = true;
              test = false;
            };
            extra = { };
          };
      };
    };
  };
}
