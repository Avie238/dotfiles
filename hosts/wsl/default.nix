{
  config,
  lib,
  pkgs,
  inputs,
  userSettings,
  ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.default
    (userSettings.dotfilesDir + "/profiles/${userSettings.profile}/configuration.nix")
  ];
  environment.systemPackages = [
    pkgs.neovim
    pkgs.neovide
    pkgs.git
  ];
  wsl.enable = true;
  wsl.defaultUser = "avie";
  nix.settings.ssl-cert-file = "/etc/ssl/certs/ca-bundle.crt";
  security.pki.certificates = [
    (builtins.readFile ./Cummins-Prisma-Root-CA.crt)
  ];

  boot.loader = {
    systemd-boot.enable = lib.mkForce false;
  };
  sops.enable = lib.mkForce false;

  networking.hostName = "wsl-nixos";

  system.stateVersion = "25.05"; # Did you read the comment?
}
