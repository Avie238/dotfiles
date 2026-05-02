{
  inputs,
  userSettings,
  config,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    (userSettings.dotfilesDir + "/profiles/${userSettings.profile}/configuration.nix")
  ];

  #Boot
  # fileSystems."/home/avie/SSD" = {
  #   device = "/dev/disk/by-uuid/7f4c805b-8775-4bc3-9e20-216631de4d92";
  #   fsType = "ext4";
  #   options = [
  #     # If you don't have this options attribute, it'll default to "defaults"
  #     # boot options for fstab. Search up fstab mount options you can use
  #     "users" # Allows any user to mount and unmount
  #     "nofail" # Prevent system from failing if this drive doesn't mount
  #   ];
  # };

  # nix.settings = {
  #   substituters = [
  #     "https://hyprland.cachix.org"
  #     "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="
  #   ];
  #   trusted-substituters = [
  #     "https://hyprland.cachix.org"
  #     "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="
  #   ];
  #   trusted-public-keys = [
  #     "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
  #     "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="
  #   ];
  # };
  programs.ns-usbloader.enable = true;
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        AutoEnable = true;
        ControllerMode = "bredr";
        Experimental = true;
      };
    };
  };
  services.blueman.enable = true;
  hardware.enableAllFirmware = true;
  services.sunshine = {
    enable = true;
    autoStart = true;
    # capSysAdmin = true;
    openFirewall = true;
    applications = {
      apps = [
        {
          name = "faugus";
          cmd = "io.github.faugus.faugus-launcher";
        }
        {
          name = "Clair Obscur Expedition 33";
          cmd = "flatpak run --command=/app/bin/faugus-launcher io.github.Faugus.faugus-launcher --game clair-obscur-expedition-33";
        }
        {
          name = "Steam Big Picture";
          detached = [
            "setsid steam steam://open/bigpicture"
          ];
          prep-cmd = [
            {
              do = "";
              undo = "setsid steam steam://close/bigpicture";
            }
          ];
          # "image-path": "steam.png"
        }
      ];
    };
  };
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = ["*"];
        settings = {
          main = {
            home = "insert";
          };
        };
      };
    };
  };

  #General
  boot.loader = {
    systemd-boot.enable = lib.mkForce true;
  };

  # environment.etc = {
  #   "resolv.conf".text = ''
  #     search netbird.cloud
  #     nameserver 1.1.1.1
  #     options edns0'';
  # };
  system.stateVersion = "25.11";
}
