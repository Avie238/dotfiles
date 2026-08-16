{
  inputs,
  userSettings,
  config,
  lib,
  pkgs,
  ...
}: let
  # ATTENTION: make sure this points to the correct location relative to this file
  cpuid-fault-emulation = pkgs.callPackage ../../packages/cpuid-fault-emulation {
    kernel = config.boot.kernelPackages.kernel;
  };
in {
  imports = [
    ./hardware-configuration.nix
    (userSettings.dotfilesDir + "/profiles/${userSettings.profile}/configuration.nix")
  ];
  services.flatpak.enable = true;
  #Boot
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
  boot.kernelModules = ["hid-sony" "hid-playstation"];
  # Disable UMIP
  boot.kernelParams = ["clearcpuid=umip"];

  # Hypervisor
  boot.extraModulePackages = [cpuid-fault-emulation];

  # Optional shell scripts to diasble and enable the hypervisor
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "enable-hypervisor" ''
      sudo modprobe -r kvm_amd kvm
      sudo modprobe cpuid_fault_emulation
    '')
    (pkgs.writeShellScriptBin "disable-hypervisor" ''
      sudo modprobe -r cpuid_fault_emulation
      sudo modprobe kvm_amd kvm
    '')
  ];

  programs.steam = {
    enable = true;
  };
  users.extraGroups.input.members = ["avie"];
  programs.ns-usbloader.enable = true;
  hardware.bluetooth = {
    enable = true;
    # settings = {
    #   General = {
    #     Enable = "Source,Sink,Media,Socket";
    #     AutoEnable = true;
    #     ControllerMode = "bredr";
    #     Experimental = true;
    #   };
    # };
  };
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "smbnix";
        "netbios name" = "smbnix";
        "security" = "user";
        #"use sendfile" = "yes";
        #"max protocol" = "smb2";
        # note: localhost is the ipv6 localhost ::1
        # "hosts allow" = "192.168.0. 127.0.0.1 localhost";
        # "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };
      "data" = {
        "path" = "/home/avie/SSD";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0777";
        # "force user" = "username";
        # "force group" = "groupname";
      };
      # "private" = {
      #   "path" = "/mnt/Shares/Private";
      #   "browseable" = "yes";
      #   "read only" = "no";
      #   "guest ok" = "no";
      #   "create mask" = "0644";
      #   "directory mask" = "0755";
      #   "force user" = "username";
      #   "force group" = "groupname";
      # };
    };
  };

  services.fwupd.enable = true;
  services.blueman.enable = true;
  hardware.enableAllFirmware = true;
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
    applications = {
      apps = [
        {
          name = "Desktop";
          cmd = "";
        }
        {
          name = "faugus";
          cmd = "sudo -u avie io.github.Faugus.faugus-launcher";
        }
        {
          name = "RPCS3";
          cmd = "sudo -u avie rpcs3";
        }
        # {
        #   name = "Clair Obscur Expedition 33";
        #   cmd = "flatpak run --command=/app/bin/faugus-launcher io.github.Faugus.faugus-launcher --game clair-obscur-expedition-33";
        # }
        {
          name = "Steam Big Picture";
          detached = [
            "sudo -u avie setsid steam steam://open/bigpicture"
          ];
          prep-cmd = [
            {
              do = "";
              undo = "sudo -u avie setsid steam steam://close/bigpicture";
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
