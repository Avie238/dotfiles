{
  pkgs,
  userSettings,
  lib,
  ...
}: {
  config = lib.mkIf (userSettings.browser == "firefox") {
    programs.firefox = {
      enable = true;
      profiles = {
        default = {
          id = 0;
          name = "default";
          isDefault = true;
          search = {
            force = true;
            default = "google";
            order = [
              "google"
            ];
            engines = {
              "Nix Packages" = {
                urls = [
                  {
                    template = "https://search.nixos.org/packages?channel=unstable";
                    params = [
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
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
            };
          };
          extensions = {
            force = true;
            packages = with pkgs.firefox-addons; [
              ublock-origin
              lastpass-password-manager
              sponsorblock
            ];
          };
          settings = {
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
      };
    };
    xdg.autostart.entries = [
      "${pkgs.firefox}/share/applications/firefox.desktop"
    ];

    stylix.targets.firefox.profileNames = ["default"];

    home.sessionVariables = {
      MOZ_GMP_PATH = "${pkgs.widevine-firefox}/gmp-widevinecdm/system-installed";
    };
  };
}
