{
  lib,
  pkgs,
  inputs,
  userSettings,
  ...
}:

let
  themePath = "${pkgs.base16-schemes}/share/themes/${userSettings.theme}.yaml";
  themePolarity = "dark";
  myLightDMTheme = if themePolarity == "light" then "Adwaita" else "Adwaita-dark";
  backgroundUrl = builtins.readFile (./. + "../../../themes" + ("/io") + "/backgroundurl.txt");
  backgroundSha256 = builtins.readFile (./. + "../../../themes/" + ("/io") + "/backgroundsha256.txt");
in
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix.enable = true;
  stylix.polarity = themePolarity;
  stylix.image = pkgs.fetchurl {
    url = backgroundUrl;
    sha256 = backgroundSha256;
  };
  stylix.base16Scheme = themePath;
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
    greeters.slick.theme.name = myLightDMTheme;
  };
  stylix.targets.console.enable = true;

  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };

}
