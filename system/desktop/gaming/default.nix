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
    hardware.opengl = {
      enable = true;
      driSupport32Bit = userSettings.system == "x86_64-linux";
    };

    programs.steam-asahi = {
      enable = true;
    };

    # muvm is rootless but needs /dev/kvm for the libkrun microVM that both
    # steam-asahi and faugus-asahi run the x86 game processes inside.
    users.users.${userSettings.username}.extraGroups =
      lib.optional (userSettings.system == "aarch64-linux") "kvm";

    services.xserver.videoDrivers = ["amdgpu"];
  };
}
