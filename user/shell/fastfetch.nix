{
  pkgs,
  userSettings,
  ...
}: {
  home.packages = [
    (import (userSettings.dotfilesDir + "/scripts/pokefetch.nix") {inherit pkgs;})
  ];

  programs.fastfetch = {
    enable = true;
    settings = builtins.fromJSON ''
          {
        "logo": {
          "type": "builtin",
          "height": 15,
          "width": 15,
          "padding": {
            "top": 2,
            "left": 2
          }
        },
        "modules": [
          "break",
          {
            "type": "custom",
            "format": "\u001b[90m┌──────────────────────Hardware──────────────────────┐"
          },
          {
            "type": "host",
            "key": " PC",
            "keyColor": "green"
          },
          {
            "type": "cpu",
            "key": "│ ├",
            "keyColor": "green"
          },
          {
            "type": "gpu",
            "key": "│ ├󰍛",
            "keyColor": "green"
          },
          {
            "type": "memory",
            "key": "│ ├",
            "keyColor": "green"
          },
          {
            "type": "disk",
            "key": "└ └",
            "keyColor": "green"
          },
          {
            "type": "custom",
            "format": "\u001b[90m└────────────────────────────────────────────────────┘"
          },
          "break",
          {
            "type": "custom",
            "format": "\u001b[90m┌──────────────────────Software──────────────────────┐"
          },
          {
            "type": "os",
            "key": " OS",
            "keyColor": "yellow"
          },
          {
            "type": "packages",
            "key": "│ ├󰏖",
            "keyColor": "yellow"
          },
          {
            "type": "shell",
            "key": "└ └",
            "keyColor": "yellow"
          },
          "break",

          {
            "type": "wm",
            "key": " WM",
            "keyColor": "blue"
          },
          {
            "type": "terminal",
            "key": "└ └",
            "keyColor": "blue"
          },
          {
            "type": "custom",
            "format": "\u001b[90m└────────────────────────────────────────────────────┘"
          },
          "break",
          {
            "type": "custom",
            "format": "\u001b[90m┌────────────────────Uptime / Age────────────────────┐"
          },
          {
            "type": "command",
            "key": "  OS Age ",
            "keyColor": "magenta",
            "text": "birth_install=$(stat -c %W /); current=$(date +%s); time_progression=$((current - birth_install)); days_difference=$((time_progression / 86400)); echo $days_difference days"
          },
          {
            "type": "uptime",
            "key": "  Uptime ",
            "keyColor": "magenta"
          },
          {
            "type": "custom",
            "format": "\u001b[90m└────────────────────────────────────────────────────┘"
          }
        ]
      }
    '';
  };
}
