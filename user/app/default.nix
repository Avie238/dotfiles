{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./editor
    ./browser
    ./terminal
    ../shell
    ./misc
    ./openmw.nix
  ];

  home.packages = with pkgs; [
    qbittorrent
    ns-usbloader
    jdk17
    prismlauncher
    calibre
    cbz_to_webp
    zip
    (pkgs.extend inputs.nixos-mmuvm-fex.overlays.default).muvm
    kdePackages.gwenview
    xfce.thunar-archive-plugin
    xarchiver
    protonvpn-gui
  ];
  openmw-dev.enable = true;

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
