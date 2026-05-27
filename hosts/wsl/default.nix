{
  lib,
  inputs,
  userSettings,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.default
    (userSettings.dotfilesDir + "/profiles/${userSettings.profile}/configuration.nix")
  ];

  wsl.enable = true;
  wsl.defaultUser = "avie";

  nix.settings.ssl-cert-file = "/etc/ssl/certs/ca-certificates.crt";

  security.pki.certificates = [
    (builtins.readFile ./Cummins-Prisma-Root-CA.crt)
  ];

  boot.loader = {
    systemd-boot.enable = lib.mkForce false;
    grub.enable = lib.mkForce false;
  };

  environment.systemPackages = with pkgs; [
    pkgs.wget
    # cacert
    pkgs.xfce.thunar
    # claude-code
    # uv
  ];
  programs.nix-ld.enable = true;
  sops.enable = false;
  vm.enable = false;
  vpn.enable = false;

  networking.hostName = userSettings.hostname;

  system.stateVersion = "25.05";
}
