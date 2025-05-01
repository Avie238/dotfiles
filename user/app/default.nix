{pkgs, ...}: {
  imports = [
    ./editor
    ./browser
    ./terminal
    ../shell
    ./misc
  ];

  home.packages = with pkgs; [
    jetbrains.idea-ultimate
    qbittorrent
    nixd
    nodejs_23
    python310
    ns-usbloader
  ];
}
