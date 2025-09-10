{
  config,
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.nixcord.homeModules.nixcord
  ];

  options = {
    discord.enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };
  };

  config = {
    programs.nixcord = {
      enable = true;
      discord.enable = false;
      vesktop.enable = true;
      extraConfig = {
        "discordBranch" = "stable";
        "minimizeToTray" = true;
        "arRPC" = false;
        "splashColor" = config.lib.stylix.colors.withHashtag.base05;
        "splashBackground" = config.lib.stylix.colors.withHashtag.base00;
      };
    };
  };
}
