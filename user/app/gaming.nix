{
  lib,
  pkgs,
  config,
  userSettings,
  ...
}: let
  # Extract the full Python path from faugus-run's wrapper so subprocess calls
  # to `python3 -m faugus.*` (proton_downloader, components) inherit all deps.
  faugusPythonPath = let
    wrapper = builtins.readFile "${pkgs.x86.faugus-launcher}/bin/.faugus-run-wrapped";
    tokens = lib.splitString "'" wrapper;
    sitePaths =
      builtins.filter
      (t: lib.hasPrefix "/nix/store/" t && lib.hasSuffix "/site-packages" t)
      tokens;
  in
    lib.concatStringsSep ":" sitePaths;

  wrapMuvm = {package}: let
    pkg = pkgs.x86."${package}";
    inner = pkgs.x86.writeShellScriptBin "${package}-muvm-inner" ''
      export XDG_DATA_DIRS="${pkgs.x86.hicolor-icon-theme}/share''${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"
      ${lib.optionalString (package == "faugus-launcher") ''
        export PYTHONPATH="${faugusPythonPath}"
      ''}
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
            # x86.steam
            # x86.protonplus
            # x86.protonup-qt
            # x86.winetricks
          ]
          ++ (map (x: wrapMuvm {package = x;}) ["lutris" "faugus-launcher"])
      else
        with pkgs; [
          faugus-launcher
          protonplus
          winetricks
        ];
  };
}
