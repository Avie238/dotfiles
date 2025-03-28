{ config, pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    profiles.default = {
      userSettings = builtins.fromJSON (builtins.readFile ./settings.json);

      extensions = with pkgs; [
        vscode-marketplace.anbuselvanrocky.bootstrap5-vscode
        vscode-marketplace.bradlc.vscode-tailwindcss
        vscode-marketplace.chflick.firecode
        vscode-marketplace.christian-kohler.npm-intellisense
        vscode-marketplace.donjayamanne.python-extension-pack
        vscode-marketplace.dsznajder.es7-react-js-snippets
        vscode-marketplace.equimper.react-native-react-redux
        vscode-marketplace.esbenp.prettier-vscode
        vscode-marketplace.formulahendry.code-runner
        vscode-marketplace.gitlab.gitlab-workflow
        vscode-marketplace.graphql.vscode-graphql-syntax
        vscode-marketplace.hars.cppsnippets
        vscode-marketplace.ivhernandez.vscode-plist
        vscode-marketplace.james-yu.latex-workshop
        vscode-marketplace.jeff-hykin.better-cpp-syntax
        vscode-marketplace.kevinrose.vsc-python-indent
        vscode-marketplace.kleber-swf.unity-code-snippets
        vscode-marketplace.mechatroner.rainbow-csv
        vscode-marketplace.misodee.vscode-nbt
        vscode-marketplace.ml.nc-gcode
        vscode-marketplace.ms-azuretools.vscode-docker
        vscode-marketplace.ms-python.debugpy
        vscode-marketplace.ms-python.isort
        vscode-marketplace.ms-python.python
        vscode-marketplace.ms-python.vscode-pylance
        vscode-marketplace.ms-toolsai.jupyter
        vscode-marketplace.ms-toolsai.jupyter-keymap
        vscode-marketplace.ms-toolsai.jupyter-renderers
        vscode-marketplace.ms-toolsai.vscode-jupyter-cell-tags
        vscode-marketplace.ms-toolsai.vscode-jupyter-slideshow
        vscode-marketplace.ms-vscode.cpptools
        vscode-marketplace.ms-vscode.cpptools-extension-pack
        vscode-marketplace.ms-vscode.cpptools-themes
        vscode-marketplace.ms-vscode.vscode-typescript-next
        vscode-marketplace.mtxr.sqltools
        vscode-marketplace.mtxr.sqltools-driver-mysql
        vscode-marketplace.percy.vscode-numpy-viewer
        vscode-marketplace.percy.vscode-pydata-viewer
        vscode-marketplace.pkief.material-icon-theme
        vscode-marketplace.quicktype.quicktype
        vscode-marketplace.redhat.java
        vscode-marketplace.sergey-tihon.openxml-explorer
        vscode-marketplace.shahilkumar.docxreader
        vscode-marketplace.shd101wyy.markdown-preview-enhanced
        vscode-marketplace.softwaredotcom.swdc-vscode
        vscode-marketplace.tamasfe.even-better-toml
        vscode-marketplace.tobiah.unity-tools
        vscode-marketplace.tomoki1207.pdf
        vscode-marketplace.visualstudioexptteam.intellicode-api-usage-examples
        vscode-marketplace.visualstudioexptteam.vscodeintellicode
        vscode-marketplace.vscjava.vscode-gradle
        vscode-marketplace.vscjava.vscode-java-debug
        vscode-marketplace.vscjava.vscode-java-dependency
        vscode-marketplace.vscjava.vscode-java-pack
        vscode-marketplace.vscjava.vscode-java-test
        vscode-marketplace.wayou.vscode-todo-highlight
        vscode-marketplace.wix.glean
        vscode-marketplace.xabikos.javascriptsnippets
        vscode-marketplace.yclepticstudios.unity-snippets
        vscode-marketplace.zainchen.json
        vscode-extensions.eamodio.gitlens
        vscode-extensions.ms-dotnettools.csdevkit
        vscode-extensions.ms-dotnettools.csharp
        vscode-extensions.ms-dotnettools.vscode-dotnet-runtime
        vscode-extensions.ms-dotnettools.vscodeintellicode-csharp

      ];

    };
  };
}
