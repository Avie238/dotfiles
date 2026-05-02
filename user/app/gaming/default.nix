{pkgs, ...}: {
  home.packages = with pkgs; [
    # faugus-launcher
    protonplus
    lutris
    mangohud
    # gamescope
    heroic
    # alvr
    umu-launcher
    jackify
    protontricks
    # eden
    # rpcs3
    (retroarch.withCores (
      cores:
        with cores; [
          mgba
        ]
    ))
  ];

  programs.distrobox.enable = true;
}
