{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./editor
    ./browser
    ./terminal
    ../shell
    ./misc
    ./openmw.nix
    ./gaming.nix
    ./claude.nix
  ];

  home.packages = with pkgs; [
    qbittorrent
    ns-usbloader
    jdk17
    prismlauncher
    cbz_to_webp
    zip
    kdePackages.gwenview
    file-roller
    remmina
    btop
    localsend
    rustdesk-flutter
    libreoffice
    grsync
    hakuneko
    dig
    ludusavi
    rclone
    manga-tui
    filezilla
    retroarch-free
    texliveFull
    proton-vpn
    nix-cleanup
    motrix-next
    jq
    python3
  ];

  xdg.enable = true;
  xdg.desktopEntries = {
    Faugus = {
      name = "Faugus launcher";
      genericName = "Game";
      exec = "faugus-launcher";
      icon = "faugus-launcher";
      terminal = false;
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/terminal" = "kitty.desktop";
      "text/html" = "firefox.desktop";
      "application/pdf" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
      "inode/directory" = "thunar.desktop";
      "text/plain" = "nvim.desktop";
      "text/markdown" = "nvim.desktop";
      "application/json" = "nvim.desktop";
      "image/*" = "gwenview.desktop";
    };
  };
}
