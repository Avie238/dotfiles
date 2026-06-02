{
  lib,
  pkgs,
  config,
  userSettings,
  ...
}: let
  wrapMuvm = {package}: pkgs.writeShellScriptBin "${package}" "${lib.getExe pkgs.muvm} ${lib.getExe pkgs.x86."${package}"}";
in {
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
        with pkgs;
          [
            muvm
            x86.steam
            x86.protonplus
            x86.winetricks
          ]
          ++ (map (x: wrapMuvm {package = x;}) ["faugus-launcher" "gamescope"])
      else
        with pkgs; [
          faugus-launcher
          protonplus
          winetricks
        ];
  };
}
