{
  lib,
  pkgs,
  userSettings,
  inputs,
  ...
}:

{
  config = lib.mkIf (userSettings.wm == "hyprland") {

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };

    services.xserver.excludePackages = [ pkgs.xterm ];

    xdg.portal = {
      enable = true;
    };

    qt = {
      enable = true;
    };
    # Pipewire
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

}
