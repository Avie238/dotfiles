{
  pkgs,
  lib,
  config,
  userSettings,
  ...
}: {
  options = {
    openmw-dev.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
    };
  };
  config = lib.mkIf config.openmw-dev.enable {
    home.packages = with pkgs; [
      openmw-dev
      delta-plugin
      s3lightfixes
      momw-configurator
      openmw-validator
      tes3cmd
      umo
      groundcoverify
    ];

    xdg.desktopEntries = {
      Morrowind = {
        name = "Morrowind";
        genericName = "Game";
        exec = "momw-configurator run /home/avie/Games/portable";
        terminal = false;
      };
    };
  };
}
