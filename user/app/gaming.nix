{
  lib,
  pkgs,
  config,
  userSettings,
  ...
}: {
  options = {
    gaming.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf config.gaming.enable {
    home.packages =
      if (userSettings.system == "aarch64-linux")
      then
        # x86 gaming stack runs through muvm + FEX. steam-asahi provides Steam
        # (system module); faugus-asahi is the umu/Proton launcher.
        with pkgs; [
          faugus-asahi
          x86.arduino-ide
        ]
      else
        with pkgs; [
          faugus-launcher
          protonplus
          winetricks
        ];
  };
}
