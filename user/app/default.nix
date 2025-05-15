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
    ns-usbloader
  ];
}
