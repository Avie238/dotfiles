{ config, pkgs, ... }:

{
  imports = [
    ./zsh
    ./fastfetch
    ./git.nix
    ./vscode
  ];

  programs.firefox.enable = true;
  xdg.autostart = {
    enable = true;

    # entries = [
    #   "${pkgs.evolution}/share/applications/org.gnome.Evolution.desktop"
    # ];

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
    cloud-utils
    sops
  ];

  home.file.".hushlogin" = {
    text = "";
  };

  gtk = {
    enable = true;
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
