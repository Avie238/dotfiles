{
  pkgs,
  lib,
  userSettings,
  ...
}: {
  options = {
    openmw-dev.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
    };
  };
  config = {
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

      nvim = {
        name = "nvim";
        genericName = "Text editor";
        exec = "${userSettings.term} -e nvim";
        terminal = false;
      };

      swayimg = {
        name = "swayimg";
        genericName = "Image viewer";
        exec = "${userSettings.term} -e swayimg";
        terminal = false;
      };
    };
  };
}
