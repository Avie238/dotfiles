{ config, pkgs, ... }:

{

  boot = {
    binfmt.emulatedSystems = [ "x86_64-linux" ];
    supportedFilesystems = [ "apfs" ];
    loader.efi.canTouchEfiVariables = false;
    kernelParams = [
      "apple_dcp.show_notch=1"
    ];
  };

}
