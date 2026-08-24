{
  lib,
  pkgs,
  config,
  userSettings,
  ...
}: let
  wrapMuvm = {package}: let
    pkg = pkgs.x86."${package}";
    inner = pkgs.x86.writeShellScriptBin "${package}-muvm-inner" ''
      export XDG_DATA_DIRS="${pkgs.x86.hicolor-icon-theme}/share''${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"
      exec ${lib.getExe pkg}
    '';
  in
    pkgs.writeShellScriptBin "${package}" ''
      exec ${lib.getExe pkgs.muvm} ${lib.getExe inner}
    '';
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
            wine-wow64-fex
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
          cemu
          azahar
          eden
          # rpcs3
          protontricks
        ];
    programs.mangohud.enable = true;
    xdg.configFile."openvr/openvrpaths.vrpath".text = let
      steam = "${config.xdg.dataHome}/Steam";
    in
      builtins.toJSON {
        version = 1;
        jsonid = "vrpathreg";

        external_drivers = null;
        config = ["${steam}/config"];

        log = ["${steam}/logs"];

        runtime = [
          "${pkgs.xrizer}/lib/xrizer"
          # OR
          #"${pkgs.opencomposite}/lib/opencomposite"
        ];
      };
  };
}
