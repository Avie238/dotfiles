{
  inputs,
  userSettings,
  config,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.apple-silicon.nixosModules.apple-silicon-support
    (userSettings.dotfilesDir + "/profiles/${userSettings.profile}/configuration.nix")
  ];

  #Boot
  boot.binfmt.emulatedSystems = ["i686-linux" "x86_64-linux"];
  nix.settings = {
    extra-platforms = config.boot.binfmt.emulatedSystems;
  };

  boot = {
    loader.efi.canTouchEfiVariables = false;
    kernelParams = [
      "appledrm.show_notch=1"
    ];
  };

  #Asahi
  hardware.asahi = {
    enable = true;
    setupAsahiSound = true;
    peripheralFirmwareDirectory = ./firmware;
    # Build kernel/m1n1/uboot from apple-silicon's own locked nixpkgs,
    # mirroring how upstream CI populates nixos-apple-silicon.cachix.org;
    # using our nixpkgs would change the derivations and force local builds.
    pkgs = lib.mkForce (import inputs.apple-silicon.inputs.nixpkgs {
      crossSystem.system = "aarch64-linux";
      localSystem.system = "aarch64-linux";
      overlays = [inputs.apple-silicon.overlays.default];
    });
  };

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = ["*"];
        settings = {
          main = {
            leftalt = "leftmeta";
            leftmeta = "leftalt";
            fn = "leftcontrol";
            leftcontrol = "toggle(fn_toggle)";
          };
          fn_toggle = {
            brightnessdown = "f1";
            brightnessup = "f2";
            scale = "f3";
            search = "f4";
            micmute = "f5";
            sleep = "f6";
            previoussong = "f7";
            playpause = "f8";
            nextsong = "f9";
            mute = "f10";
            volumedown = "f11";
            volumeup = "f12";
          };
        };
      };
    };
  };

  # nixpkgs' source-built aarch64 Flutter engine lacks fontconfig, so Flutter
  # apps (rustdesk, localsend) only see fonts under the hardcoded fallback
  # /usr/share/fonts — without this, all their text renders invisible.
  fonts.fontDir.enable = true;
  systemd.tmpfiles.rules = [
    "L+ /usr/share/fonts - - - - /run/current-system/sw/share/X11/fonts"
  ];

  gaming.enable = true;
  #General
  system.stateVersion = "25.05";
}
