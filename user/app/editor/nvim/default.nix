{pkgs, ...}: {
  programs.neovim.enable = true;

  programs.nvf = {
    enable = true;
    settings.vim = {
      lsp = {
        formatOnSave = true;
        lspkind.enable = false;
        lightbulb.enable = true;
        lspsaga.enable = false;
        trouble.enable = true;
        lspSignature.enable = true;
      };

      languages = {
        enableLSP = true;
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
        python.enable = true;
        tailwind.enable = false;
      };

      extraPackages = with pkgs; [
        ripgrep
        ast-grep
        unzip
        wget
        tree-sitter
        ghostscript
        tectonic
        mermaid-cli
        wl-clipboard
        gcc
        fd
        lazygit
        fzf
        unar
        sqlfluff
      ];

      luaConfigRC.myconfig = ''
        local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
        if not (vim.uv or vim.loop).fs_stat(lazypath) then
          local lazyrepo = "https://github.com/folke/lazy.nvim.git"
          local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
          if vim.v.shell_error ~= 0 then
            vim.api.nvim_echo({
              { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
              { out, "WarningMsg" },
              { "\nPress any key to exit..." },
            }, true, {})
            vim.fn.getchar()
            os.exit(1)
          end
        end
        vim.opt.rtp:prepend(lazypath)

        require("lazy").setup({
          spec = {
            -- add LazyVim and import its plugins
            { "LazyVim/LazyVim", import = "lazyvim.plugins", opts = { colorscheme = function() end } },
            -- import/override with your plugins
            -- { import = "plugins" },
          },
          defaults = {
            -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
            -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
            lazy = false,
            -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
            -- have outdated releases, which may break your Neovim install.
            version = false, -- always use the latest git commit
            -- version = "*", -- try installing the latest stable version for plugins that support semver
          },
          install = { colorscheme = { "tokyonight", "habamax" } },
          checker = {
            enabled = true, -- check for plugin updates periodically
            notify = false, -- notify on update
          }, -- automatically check for plugin updates
          performance = {
            rtp = {
              -- disable some rtp plugins
              disabled_plugins = {
                "gzip",
                -- "matchit",
                -- "matchparen",
                -- "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
              },
            },
          },
        })
      '';
    };
  };
}
