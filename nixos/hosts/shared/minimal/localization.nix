{ config, pkgs, ... }:
{
  time.timeZone = "Europe/Amsterdam";

  # i18n = {
  #   defaultLocale = "en_IE.UTF-8";
  #   supportedLocales = [
  #     "en_US.UTF-8/UTF-8"
  #     "nl_NL.UTF-8/UTF-8"
  #     "en_IE.UTF-8/UTF-8"
  #     "pl_PL.UTF-8/UTF-8"
  #   ];
  # };

  services.xserver.xkb.layout = "pl";
}
