{
  pkgs,
  lib,
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
    hardware.graphics = {
      enable = true;
      enable32Bit = userSettings.system == "x86_64-linux";
    };

    services.xserver.videoDrivers = ["amdgpu"];
  };
}
