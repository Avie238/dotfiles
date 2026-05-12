{pkgs, ...}: {
  home.packages = with pkgs; [
    # faugus-launcher
    protonplus
    # lutris
    mangohud
    # gamescope
    gamescope-wsi
    heroic
    # alvr
    umu-launcher
    jackify
    protontricks
    # eden
    cemu
    rpcs3
    emulationstation-de
    # dolphin-emu
    # retroarch-full
    # (retroarch.withCores (
    #   cores:
    #     with cores; [
    #       mgba
    #       beetle-psx-hw
    #     ]
    # ))
  ];

  programs.distrobox.enable = true;
}
