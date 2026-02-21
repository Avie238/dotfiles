{pkgs, ...}: {
  home.packages = with pkgs; [
    faugus-launcher
    protonplus
    lutris
    mangohud
    # gamescope
    heroic
    # alvr
    umu-launcher
    jackify
    protontricks
  ];

  programs.distrobox.enable = true;
}
