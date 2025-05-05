{
  inputs,
  userSettings,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.apple-silicon.nixosModules.apple-silicon-support
    (userSettings.dotfilesDir + "/profiles/${userSettings.profile}/configuration.nix")
  ];

  #Boot
  # boot.binfmt.emulatedSystems = ["x86_64-linux"];
  boot = {
    loader.efi.canTouchEfiVariables = false;
    kernelParams = [
      "apple_dcp.show_notch=1"
    ];
  };

  #Asahi
  hardware.asahi = {
    enable = true;
    withRust = true;
    useExperimentalGPUDriver = true;
    experimentalGPUInstallMode = "replace";
    setupAsahiSound = true;
    peripheralFirmwareDirectory = ./firmware;
  };

  #General
  networking.hostName = "avie-nixos";
  system.stateVersion = "25.05";
}
