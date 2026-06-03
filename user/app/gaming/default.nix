{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    # faugus-launcher
    protonplus
    # lutris
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

  programs.mangohud = {
    enable = true;
    settings = {
      toggle_hud = "Shift_R+F12";

      # text_color = lib.mkForce "c965bf";
    };
  };

  programs.distrobox.enable = true;
}
