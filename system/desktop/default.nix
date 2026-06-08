{
  pkgs,
  userSettings,
  lib,
  config,
  ...
}: let
in {
  imports = [
    ./../minimal
    ./wm
    ./zswap.nix
    ./stylix.nix
    ./vm.nix
    ./vpn.nix
    ./file_manager
    ./gaming
  ];

  hardware.graphics = {
    enable = true;
  };

  virtualisation.docker.enable = true;

  services.samba = {
    enable = true;
    settings.global.security = "user";
    openFirewall = true;
  };
  # networking.nftables.enable = true;

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
  # services.printing.enable = true;
  #
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.logind.settings.Login.HandlePowerKey = "suspend";

  services.flatpak.enable =
    if userSettings.wm == "none"
    then false
    else true;

  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  services.netbird.enable = true;
  vpn.enable = false;
  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
