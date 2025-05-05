{
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./../minimal
    ./wm
    ./zswap.nix
    ./stylix.nix
  ];

  services.flatpak.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = lib.mkForce false;
  };
}
