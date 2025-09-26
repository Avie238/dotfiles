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
  nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;
  boot = {
    loader.efi.canTouchEfiVariables = false;
    kernelParams = [
      "apple_dcp.show_notch=1"
    ];
  };

  #Asahi
  hardware.asahi = {
    enable = true;
    setupAsahiSound = true;
    peripheralFirmwareDirectory = ./firmware;
  };

  #General
  system.stateVersion = "25.05";
}
