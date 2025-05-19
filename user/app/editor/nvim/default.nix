{
  config,
  inputs,
  ...
}: let
  utils = inputs.nixCats.utils;
in {
  imports = [
    inputs.nixCats.homeModule
  ];
  config = {
    nixCats = {
      enable = true;
      addOverlays = [
        (utils.standardPluginOverlay inputs)
      ];
      packageNames = ["nvim"];

      luaPath = ./.;

      categoryDefinitions.replace = (
        {pkgs, ...}: {
          lspsAndRuntimeDeps = with pkgs; {
            general = [
              universal-ctags
              curl
              (pkgs.writeShellScriptBin "lazygit" ''
                exec ${pkgs.lazygit}/bin/lazygit --use-config-file ${pkgs.writeText "lazygit_config.yml" ""} "$@"
              '')
              ripgrep
              fd
              stdenv.cc.cc
              lua-language-server
              stylua
              wl-clipboard

              pokemon-colorscripts
            ];

            nix = [
              nixd
              alejandra
            ];

            python = [
              basedpyright
              isort
              black
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
              precognition-nvim
              base16-nvim
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
            ];
          };
        }
      );

      packageDefinitions.replace = {
        nvim = {
          pkgs,
          name,
          ...
        }: {
          settings = {
            suffix-path = true;
            suffix-LD = true;
            wrapRc = true;
            aliases = [
              "vim"
              "vi"
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
            python = true;
            nix = true;
          };
          extra = {};
        };
      };
    };
  };
}
