{
  pkgs,
  inputs,
  firefox-addons,
  ...
}:

{

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
              definedAliases = [ "@np" ];
            };
          };
        };
        extensions.packages = with pkgs.firefox-addons; [
          ublock-origin
          lastpass-password-manager
          sponsorblock
        ];
      };
    };
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DontCheckDefaultBrowser = true;
      DisablePocket = true;
      SearchBar = "unified";

      # Preferences = {
      #   # Privacy settings
      #   "extensions.pocket.enabled" = lock-false;
      #   "browser.newtabpage.pinned" = lock-empty-string;
      #   "browser.topsites.contile.enabled" = lock-false;
      #   "browser.newtabpage.activity-stream.showSponsored" = lock-false;
      #   "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
      #   "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
      # };

      # ExtensionSettings = {
      #   "uBlock0@raymondhill.net" = {
      #     install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
      #     installation_mode = "force_installed";
      #   };
      #   "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
      #     install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
      #     installation_mode = "force_installed";
      #   };
      #   "jid1-MnnxcxisBPnSXQ@jetpack" = {
      #     install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
      #     installation_mode = "force_installed";
      #   };
      #   "extension@tabliss.io" = {
      #     install_url = "https://addons.mozilla.org/firefox/downloads/file/3940751/tabliss-2.6.0.xpi";
      #     installation_mode = "force_installed";
      #   };
      # };
    };

  };
  xdg.autostart.entries = [
    "${pkgs.firefox}/share/applications/firefox.desktop"
  ];

}
