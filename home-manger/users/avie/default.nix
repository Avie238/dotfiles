{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./zsh
    ./fastfetch.nix
    ./git.nix
    ./vscode
  ];

  programs.firefox.enable = true;
  xdg.autostart = {
    enable = true;

    entries = [
      "${pkgs.firefox}/share/applications/firefox.desktop"
    ];

  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        show-battery-percentage = true;
      };
    };
  };

  home.username = "avie";
  home.homeDirectory = "/home/avie";

  home.packages = with pkgs; [
    meslo-lgs-nf
    jetbrains-mono
    sops
    vscodium
    gnumake
  ];

  home.file.".hushlogin" = {
    text = "";
  };

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
