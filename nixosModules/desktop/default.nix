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

  nixpkgs.overlays = [
    inputs.nix-vscode-extensions.overlays.default
  ];
}
