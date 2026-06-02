{
  pkgs,
  userSettings,
  lib,
  ...
}: {
  config = lib.mkIf (userSettings.browser == "firefox") {
    programs.firefox = {
      enable = true;
      configPath = ".mozilla/firefox";
      profiles = {
        default = {
          id = 0;
          name = "default";
          isDefault = true;
          search = {
            default = "Startpage";
            force = true;
            engines = {
              "Nix Packages" = {
                urls = [
                  {
                    template = "https://search.nixos.org/packages?channel=unstable&type=packages&query={searchTerms}";
                  }
                ];
                icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = ["@np"];
              };
              "My NixOS" = {
                urls = [{template = "https://mynixos.com/search?q={searchTerms}";}];
                icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = ["@mn"];
              };

              "Startpage" = {
                urls = [
                  {template = "https://www.startpage.com/sp/search?q={searchTerms}";}
                ];
              };
            };
          };
          extensions = {
            force = true;
            packages = with pkgs.firefox-addons; [
              ublock-origin
              sponsorblock
              bitwarden
            ];
          };
          settings = {
            "ui.systemUsesDarkTheme" = 1;
            "layout.css.prefers-color-scheme.content-override" = 0;
            "media.gmp-widevinecdm.version" = "system-installed";
            "media.gmp-widevinecdm.visible" = true;
            "media.gmp-widevinecdm.enabled" = true;
            "media.gmp-widevinecdm.autoupdate" = false;
            "media.eme.enabled" = true;
            "media.eme.encrypted-media-encryption-scheme.enabled" = true;
          };
        };
      };
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DontCheckDefaultBrowser = true;
        DisablePocket = true;
        SearchBar = "unified";
        ExtensionSettings = {
          "uBlock0@raymondhill.net" = {
            installation_mode = "force_installed";
            install_url = "file://${pkgs.firefox-addons.ublock-origin}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/uBlock0@raymondhill.net.xpi";
          };
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            installation_mode = "force_installed";
            install_url = "file://${pkgs.firefox-addons.bitwarden}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/{446900e4-71c2-419f-a6a7-df9c091e268b}.xpi";
          };
          "sponsorBlocker@ajay.app" = {
            installation_mode = "force_installed";
            install_url = "file://${pkgs.firefox-addons.sponsorblock}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/sponsorBlocker@ajay.app.xpi";
          };
        };
      };
    };
    xdg.autostart.entries = [
      "${pkgs.firefox}/share/applications/firefox.desktop"
    ];

    stylix.targets.firefox.profileNames = ["default"];

    home.sessionVariables = lib.mkIf (userSettings.system
      == "aarch64-linux") {
      MOZ_GMP_PATH = "${pkgs.widevine-firefox}/gmp-widevinecdm/system-installed";
    };
  };
}
