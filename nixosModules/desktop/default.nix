{ inputs, ... }:

{

  imports = [
    inputs.sops-nix.nixosModules.sops
    ./../minimal
    ./wm
    ./zswap.nix
    ./stylix.nix
    ./grub.nix
  ];

  services.flatpak.enable = true;

  hardware.graphics = {
    enable = true;
  };
}
