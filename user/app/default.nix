{
  pkgs,
  inputs,
  lib,
  ...
}: let
  wrapMuvm = {package}: pkgs.writeShellScriptBin "${package}" "${lib.getExe pkgs.muvm} ${lib.getExe pkgs.x86."${package}"}";
in {
  imports = [
    ./editor
    ./browser
    ./terminal
    ../shell
    ./misc
    ./openmw.nix
    ./gaming
  ];

  home.packages = with pkgs; [
    qbittorrent
    ns-usbloader
    jdk17
    prismlauncher
    # calibre
    cbz_to_webp
    zip
    kdePackages.gwenview
    # xfce.thunar-archive-plugin
    # xarchiver
    file-roller
    protonvpn-gui
    remmina
    btop
    gparted
    localsend
    # muvm
    libreoffice
    grsync
    hakuneko
    dig
    wl-clipboard
    # qrookie
    manga-tui
    # retroarch-full
    filezilla
    cemu
    azahar
    jellyfin-desktop
    appimage-run
    android-tools
  ];
  # ++ (with pkgs.x86; [
  #   # steam
  #   protonup-qt
  #   wineWowPackages.full
  #   winetricks
  #   pdfstudioviewer
  # ])
  # ++ (map (x: wrapMuvm {package = x;}) ["lutris"]);

  # openmw-dev.enable = true;
  #
  # xdg.desktopEntries = {
  #   Lutris = {
  #     name = "Lutris";
  #     genericName = "Game";
  #     exec = "lutris";
  #     terminal = false;
  #   };
  #   Adobe = {
  #     name = "Adobe Acrobat";
  #     genericName = "PDF";
  #     exec = "muvm env WINEPREFIX=/home/avie/Prefixes/Adobe/ wine \"/home/avie/Downloads/Adobe Acrobat Pro DC 2025.001.20937 x64 Portable 7997/Acrobat Pro/AcrobatProPortable.exe\"";
  #     terminal = false;
  #   };
  # };

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
