{pkgs, ...}: {
  imports = [
    ./editor
    ./browser
    ./terminal
    ../shell
    ./misc
  ];

  home.packages = with pkgs; [
    qbittorrent
    nixd
    nodejs_23
    python310
    ns-usbloader
  ];
}
