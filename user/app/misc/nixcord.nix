{ config, ... }:
{

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
}
