{
  config,
  pkgs,
  inputs,
  ...
}:

{

  imports = [
    inputs.sops-nix.nixosModules.sops
    ./../minimal
    ./DE.nix
    ./graphics.nix
  ];

  services.flatpak.enable = true;
}
