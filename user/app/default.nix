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
  ];

  home.packages =
    (with pkgs; [
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
      gparted
      localsend
      muvm
      libreoffice
      grsync
      hakuneko
      dig
      ludusavi
      rclone
      manga-tui
      filezilla
      retroarch-free
      claude-code
      texliveFull
      proton-vpn
    ])
    ++ (with pkgs.x86; [
      steam
      protonplus
      winetricks
    ])
    ++ (map (x: wrapMuvm {package = x;}) ["faugus-launcher" "gamescope"]);

  xdg.enable = true;
  xdg.desktopEntries = {
    Faugus = {
      name = "Faugus launcher";
      genericName = "Game";
      exec = "faugus-launcher";
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
