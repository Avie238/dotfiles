{
  inputs,
  userSettings,
  config,
  lib,
  pkgs,
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
    # Let artemis fetch build inputs from substituters itself instead of us
    # copying them over the wire first.
    builders-use-substitutes = true;
  };

  # Offload aarch64-linux builds (e.g. linux-asahi on a cachix miss) to
  # artemis over SSH — it emulates aarch64 via binfmt (see hosts/artemis).
  # Only used on a cache miss; if artemis is unreachable this just falls
  # back to building locally.
  nix.distributedBuilds = true;
  nix.buildMachines = [
    {
      hostName = "artemis-nixos";
      system = "aarch64-linux";
      protocol = "ssh-ng";
      sshUser = "avie";
      sshKey = config.sops.secrets."id_ed25519".path;
      maxJobs = 8; # tune to artemis's actual core count
      speedFactor = 1;
      supportedFeatures = ["big-parallel" "kvm"];
    }
  ];
  # avie's SSH key is already deployed everywhere via sops (system/minimal/ssh.nix)
  # and already authorized on artemis; this just makes root's (nix-daemon's)
  # ssh client trust artemis's host key non-interactively.
  programs.ssh.knownHosts."artemis-nixos".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILO6KbBOGVqy9cnc8/Ll/hyJF4/KP5on/X9TC5QEg/yp";

  boot = {
    loader.efi.canTouchEfiVariables = false;
    kernelParams = [
      "appledrm.show_notch=1"
      # Prevent USB ports going dead after device removal
      "usbcore.autosuspend=-1"
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

  environment.systemPackages = [pkgs.usb-reset];

  gaming.enable = true;
  #General
  system.stateVersion = "25.05";
}
