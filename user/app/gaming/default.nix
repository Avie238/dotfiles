{pkgs, ...}: {
  home.packages = with pkgs; [
    # faugus-launcher
    protonplus
    # lutris
    mangohud
    # gamescope
    heroic
    # alvr
    umu-launcher
    jackify
    protontricks
    # eden
    cemu
    rpcs3
    (retroarch.withCores (
      cores:
        with cores; [
          mgba
          beetle-psx-hw
        ]
    ))
  ];

  programs.distrobox.enable = true;
}
