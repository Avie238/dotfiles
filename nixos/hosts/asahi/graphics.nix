{ config, pkgs, ... }:
{
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = false;
    };

    asahi = {
      enable = true;
      withRust = true;
      useExperimentalGPUDriver = true;
      experimentalGPUInstallMode = "replace";
      setupAsahiSound = true;
      peripheralFirmwareDirectory = ./firmware;
     
    };
  };

}
