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
      delta-plugin
      momw-configurator
      openmw-validator
      tes3cmd
      umo
      groundcoverify
      s3lightfixes
      # openmw
      userSettings.pkgs-openmw.openmw
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
