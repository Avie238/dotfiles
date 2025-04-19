{
  lib,
  pkgs,
  inputs,
  userSettings,
  ...
}:

{
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix.enable = true;
  stylix.autoEnable = true;
  stylix.polarity = "dark";
  stylix.image = ../../wallpaper.jpg;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/${userSettings.theme}.yaml";
  stylix.fonts = {
    monospace = {
      name = userSettings.font;
      package = userSettings.fontPkg;
    };
    # serif = {
    #   name = userSettings.font;
    #   package = userSettings.fontPkg;
    # };
    # sansSerif = {
    #   name = userSettings.font;
    #   package = userSettings.fontPkg;
    # };
    emoji = {
      name = "Noto Color Emoji";
      package = pkgs.noto-fonts-emoji-blob-bin;
    };
    sizes = {
      desktop = 10;
      applications = 10;
    };
  };

  stylix.targets.lightdm.enable = true;

  services.xserver.displayManager.lightdm = {
    greeters.slick.enable = true;
    greeters.slick.theme.name = "Adwaita-dark";
  };

  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };

}
