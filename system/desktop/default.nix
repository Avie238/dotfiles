{
  pkgs,
  userSettings,
  lib,
  ...
}: let
  wrapMuvm = {package}: pkgs.writeShellScriptBin "${package}" "muvm ${lib.getExe pkgs.x86."${package}"}";
in {
  imports = [
    ./../minimal
    ./wm
    ./zswap.nix
    ./stylix.nix
    ./vm.nix
    ./vpn.nix
    ./thunar.nix
  ];

  hardware.graphics = {
    enable = true;
  };

  virtualisation.docker.enable = true;
  # virtualisation.incus = {
  #   enable = true;
  #   ui.enable = true;
  # };

  services.samba = {
    enable = true;
    settings.global.security = "user";
    openFirewall = true;
  };
  networking.nftables.enable = true;

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  # environment.systemPackages = with pkgs.avie-pkgs; [
  #   wineWow64Packages.full
  # ];

  # hardware.opengl.extraPackages = [pkgs.mesa];

  # environment.etc = {
  #   "resolv.conf".text = ''
  #     search netbird.cloud
  #     nameserver 1.1.1.1
  #     options edns0'';
  # };

  networking.firewall.enable = true;
  networking.firewall.allowPing = true;
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  hardware.graphics.package =
    # Workaround for Mesa 25.3.0 regression
    # https://github.com/nix-community/nixos-apple-silicon/issues/380
    assert pkgs.mesa.version == "25.3.0";
      (import (fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/c5ae371f1a6a7fd27823bc500d9390b38c05fa55.tar.gz";
        sha256 = "sha256-4PqRErxfe+2toFJFgcRKZ0UI9NSIOJa+7RXVtBhy4KE=";
      }) {localSystem = pkgs.stdenv.hostPlatform;}).mesa;
  services.logind.settings.Login.HandlePowerKey = "suspend";

  services.flatpak.enable =
    if userSettings.wm == "none"
    then false
    else true;

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  services.netbird.enable = true;
  vpn.enable = false;
}
