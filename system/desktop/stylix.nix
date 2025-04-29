{
  lib,
  pkgs,
  inputs,
  userSettings,
  ...
}: {
  imports = [inputs.stylix.nixosModules.stylix];

  stylix = {
    enable = true;
    autoEnable = true;
    image = userSettings.dotfilesDir + "/wallpaper.jpg";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${userSettings.theme}.yaml";
    fonts = {
      monospace = {
        name = userSettings.font;
        package = pkgs.nerd-fonts.${userSettings.fontPkg};
      };
      emoji = {
        name = "Noto Color Emoji";
        package = pkgs.noto-fonts-emoji-blob-bin;
      };
      sizes = {
        desktop = 10;
        applications = 10;
      };
    };
    # opacity.terminal = 0.85;
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 20;
      # package = pkgs.quintom-cursor-theme;
      # name = "Quintom_Ink";
      # size = 21;
    };

    #targets.grub.enable = false;
    targets.nvf.transparentBackground.main = true;
  };

  #services.xserver.displayManager.lightdm = {
  #  greeters.slick.enable = true;
  #  greeters.slick.theme.name = "Adwaita-dark";
  #};

  # environment.sessionVariables = {
  #   QT_QPA_PLATFORMTHEME = "qt5ct";
  # };
}
