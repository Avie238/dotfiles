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
    ./firefox.nix
  ];

  programs.firefox.enable = true;
  xdg.autostart.enable = true;

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
    gnumake
    anydesk
  ];

  home.file.".hushlogin" = {
    text = "";
  };

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
