{
  inputs,
  userSettings,
  config,
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

  #General
  system.stateVersion = "25.05";
}
