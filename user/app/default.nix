{pkgs, ...}: {
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
  ];
}
