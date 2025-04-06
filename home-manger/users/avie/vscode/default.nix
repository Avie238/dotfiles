{
  config,
  pkgs,
  inputs,
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
          anbuselvanrocky.bootstrap5-vscode
          bradlc.vscode-tailwindcss
          chflick.firecode
          christian-kohler.npm-intellisense
          donjayamanne.python-extension-pack
          dsznajder.es7-react-js-snippets
          equimper.react-native-react-redux
          esbenp.prettier-vscode
          formulahendry.code-runner
          gitlab.gitlab-workflow
          graphql.vscode-graphql-syntax
          hars.cppsnippets
          ivhernandez.vscode-plist
          james-yu.latex-workshop
          jeff-hykin.better-cpp-syntax
          kevinrose.vsc-python-indent
          kleber-swf.unity-code-snippets
          mechatroner.rainbow-csv
          misodee.vscode-nbt
          ml.nc-gcode
          ms-azuretools.vscode-docker
          ms-python.debugpy
          ms-python.isort
          ms-python.python
          ms-python.vscode-pylance
          ms-toolsai.jupyter-keymap
          ms-toolsai.jupyter-renderers
          ms-toolsai.vscode-jupyter-cell-tags
          ms-toolsai.vscode-jupyter-slideshow
          ms-vscode.cpptools
          ms-vscode.cpptools-extension-pack
          ms-vscode.cpptools-themes
          ms-vscode.vscode-typescript-next
          mtxr.sqltools
          mtxr.sqltools-driver-mysql
          percy.vscode-numpy-viewer
          percy.vscode-pydata-viewer
          pkief.material-icon-theme
          quicktype.quicktype
          redhat.java
          sergey-tihon.openxml-explorer
          shahilkumar.docxreader
          shd101wyy.markdown-preview-enhanced
          softwaredotcom.swdc-vscode
          tamasfe.even-better-toml
          tobiah.unity-tools
          tomoki1207.pdf
          visualstudioexptteam.intellicode-api-usage-examples
          visualstudioexptteam.vscodeintellicode
          vscjava.vscode-gradle
          vscjava.vscode-java-debug
          vscjava.vscode-java-dependency
          vscjava.vscode-java-pack
          vscjava.vscode-java-test
          wayou.vscode-todo-highlight
          wix.glean
          xabikos.javascriptsnippets
          yclepticstudios.unity-snippets
          zainchen.json
          jnoortheen.nix-ide

        ])
        ++ (with pkgs.vscode-extensions; [
          ms-toolsai.jupyter
          ms-python.black-formatter
          eamodio.gitlens
          ms-dotnettools.csdevkit
          ms-dotnettools.csharp
          ms-dotnettools.vscode-dotnet-runtime
          ms-dotnettools.vscodeintellicode-csharp
        ]);

    };
  };
}
