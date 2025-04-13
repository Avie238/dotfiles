{ inputs, ... }:

{

  imports = [
    inputs.sops-nix.nixosModules.sops
    ./../minimal
    ./DE.nix
    ./zswap.nix
  ];

  services.flatpak.enable = true;

  hardware.graphics = {
    enable = true;
  };
}
