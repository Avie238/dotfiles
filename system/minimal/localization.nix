{
  config,
  lib,
  userSettings,
  ...
}:

{
  options = {
    localization.enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf config.localization.enable {
    time.timeZone = userSettings.timeZone;

    i18n = {
      defaultLocale = "en_IE.UTF-8";
      supportedLocales = [
        "en_US.UTF-8/UTF-8"
        "nl_NL.UTF-8/UTF-8"
        "en_IE.UTF-8/UTF-8"
        "pl_PL.UTF-8/UTF-8"
      ];
    };

    services.xserver.xkb.layout = userSettings.kb_layout;
  };

}
