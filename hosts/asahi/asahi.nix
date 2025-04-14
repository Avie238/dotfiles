{ ... }:

{

  hardware.asahi = {
    enable = true;
    withRust = true;
    useExperimentalGPUDriver = true;
    experimentalGPUInstallMode = "replace";
    setupAsahiSound = true;
    peripheralFirmwareDirectory = ./firmware;
  };

}
