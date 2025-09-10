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
  wsl.defaultUser = "nixos";
  nix.settings.ssl-cert-file = "/etc/ssl/certs/ca-bundle.crt";
  security.pki.certificates = [
    (builtins.readFile ./Cummins-Prisma-Root-CA.crt)
  ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    download-buffer-size = 524288000;
  };
  boot.loader = {
    systemd-boot.enable = lib.mkForce false;
  };
  networking.hostName = "msi-nixos";

  system.stateVersion = "25.05"; # Did you read the comment?
}
