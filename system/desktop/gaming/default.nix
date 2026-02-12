{
  pkgs,
  lib,
  config,
}: {
  options = {
    gaming.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
    };
  };
  config = lib.mkIf (config.gaming.enable == true) {
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    services.xserver.videoDrivers = ["amdgpu"];
  };
}
