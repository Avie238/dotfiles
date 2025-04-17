{
  pkgs,
  lib,
  config,
  userSettings,
  ...
}:

{

  options = {
    vscode.js = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };
    vscode.python = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };
    vscode.C = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };
    vscode.Java = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };
    vscode.Unity = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };
    vscode.SQL = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };
    vscode.CSharp = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };
    vscode.Git = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf (userSettings.editor == "vscode") {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      mutableExtensionsDir = false;
      profiles.default = {
        userSettings = builtins.fromJSON (builtins.readFile ./settings.json);
        keybindings = builtins.fromJSON (builtins.readFile ./keybindings.json);

        extensions =
          (with pkgs.vscode-marketplace; [
            #Nix
            jnoortheen.nix-ide
            # General
            esbenp.prettier-vscode
            formulahendry.code-runner
            graphql.vscode-graphql-syntax
            ivhernandez.vscode-plist
            james-yu.latex-workshop
            mechatroner.rainbow-csv
            misodee.vscode-nbt
            ml.nc-gcode
            ms-azuretools.vscode-docker
            pkief.material-icon-theme
            quicktype.quicktype
            sergey-tihon.openxml-explorer
            shahilkumar.docxreader
            shd101wyy.markdown-preview-enhanced
            softwaredotcom.swdc-vscode
            tamasfe.even-better-toml
            tomoki1207.pdf
            visualstudioexptteam.intellicode-api-usage-examples
            visualstudioexptteam.vscodeintellicode
            wayou.vscode-todo-highlight
            zainchen.json
            christian-kohler.path-intellisense
          ])
          ++ (
            with pkgs.vscode-marketplace;
            # JS/TS
            lib.optionals config.vscode.js [
              anbuselvanrocky.bootstrap5-vscode
              bradlc.vscode-tailwindcss
              christian-kohler.npm-intellisense
              chflick.firecode
              dsznajder.es7-react-js-snippets
              equimper.react-native-react-redux
              ms-vscode.vscode-typescript-next
              wix.glean
              xabikos.javascriptsnippets
            ]
            #Python
            ++ lib.optionals config.vscode.python [
              ms-python.black-formatter
              ms-python.debugpy
              ms-python.isort
              ms-python.python
              detachhead.basedpyright
              kevinrose.vsc-python-indent
              ms-toolsai.jupyter-keymap
              ms-toolsai.jupyter-renderers
              ms-toolsai.vscode-jupyter-cell-tags
              ms-toolsai.vscode-jupyter-slideshow
              percy.vscode-numpy-viewer
              percy.vscode-pydata-viewer
            ]
            #C++
            ++ lib.optionals config.vscode.C [
              hars.cppsnippets
              jeff-hykin.better-cpp-syntax
              ms-vscode.cpptools
              ms-vscode.cpptools-extension-pack
              ms-vscode.cpptools-themes
            ]
            #Java
            ++ lib.optionals config.vscode.Java [
              redhat.java
              vscjava.vscode-gradle
              vscjava.vscode-java-debug
              vscjava.vscode-java-dependency
              vscjava.vscode-java-pack
              vscjava.vscode-java-test
            ]
            #Unity
            ++ lib.optionals config.vscode.Unity [
              tobiah.unity-tools
              yclepticstudios.unity-snippets
              kleber-swf.unity-code-snippets
            ]
            #SQL
            ++ lib.optionals config.vscode.SQL [
              mtxr.sqltools
              mtxr.sqltools-driver-mysql
            ]

          )
          ++ (
            with pkgs.vscode-extensions;
            #C#
            lib.optionals config.vscode.CSharp [
              ms-dotnettools.csdevkit
              ms-dotnettools.csharp
              ms-dotnettools.vscode-dotnet-runtime
              ms-dotnettools.vscodeintellicode-csharp
            ]
            #Git
            ++ lib.optionals config.vscode.Git [

              gitlab.gitlab-workflow
              eamodio.gitlens
            ]
          );

      };
    };
  };
}
