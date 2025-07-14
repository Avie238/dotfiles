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
    vlc
    jdk17
    prismlauncher
    dolphin-emu
    virtualhere
  ];
  openmw-dev.enable = true;
}
