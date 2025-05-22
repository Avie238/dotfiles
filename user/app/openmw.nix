{
  pkgs,
  lib,
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
  };
}
