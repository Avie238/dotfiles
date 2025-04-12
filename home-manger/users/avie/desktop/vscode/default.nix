{
  config,
  pkgs,
  inputs,
  lib,
  desktop,
  ...
}:
{

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default = {
      userSettings = builtins.fromJSON (builtins.readFile ./settings.json);
      keybindings = builtins.fromJSON (builtins.readFile ./keybindings.json);

      extensions =
        (with pkgs.vscode-marketplace; [
          #JS/TS
          anbuselvanrocky.bootstrap5-vscode
          bradlc.vscode-tailwindcss
          christian-kohler.npm-intellisense
          chflick.firecode
          dsznajder.es7-react-js-snippets
          equimper.react-native-react-redux
          ms-vscode.vscode-typescript-next
          wix.glean
          xabikos.javascriptsnippets
          #Python
          donjayamanne.python-extension-pack
          kevinrose.vsc-python-indent
          ms-python.black-formatter
          ms-python.debugpy
          ms-python.isort
          ms-python.python
          ms-python.vscode-pylance
          ms-toolsai.jupyter
          ms-toolsai.jupyter-keymap
          ms-toolsai.jupyter-renderers
          ms-toolsai.vscode-jupyter-cell-tags
          ms-toolsai.vscode-jupyter-slideshow
          percy.vscode-numpy-viewer
          percy.vscode-pydata-viewer
          #C++
          hars.cppsnippets
          jeff-hykin.better-cpp-syntax
          ms-vscode.cpptools
          ms-vscode.cpptools-extension-pack
          ms-vscode.cpptools-themes
          #Java
          vscjava.vscode-gradle
          vscjava.vscode-java-debug
          vscjava.vscode-java-dependency
          vscjava.vscode-java-pack
          vscjava.vscode-java-test
          redhat.java
          #Nix
          jnoortheen.nix-ide
          #Git
          gitlab.gitlab-workflow
          eamodio.gitlens
          #Unity
          tobiah.unity-tools
          yclepticstudios.unity-snippets
          kleber-swf.unity-code-snippets
          #Sql
          mtxr.sqltools
          mtxr.sqltools-driver-mysql
          #General
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
        ])
        ++ (with pkgs.vscode-extensions; [
          #C#
          ms-dotnettools.csdevkit
          ms-dotnettools.csharp
          ms-dotnettools.vscode-dotnet-runtime
          ms-dotnettools.vscodeintellicode-csharp
        ]);

    };
  };

}
