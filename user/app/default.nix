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
    ns-usbloader
  ];
}
