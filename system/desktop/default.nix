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

  environment.systemPackages = with pkgs; [
    gparted
  ];
  programs.gamescope = {
    enable = true;
    enableWsi = true;
    capSysNice = false;
  };

  programs.alvr.enable = true;
  # services.wivrn = {
  #   enable = true;
  #   openFirewall = true;
  #
  #   # You should use the default configuration (which is no configuration), as that works the best out of the box.
  #   # However, if you need to configure something see https://github.com/WiVRn/WiVRn/blob/master/docs/configuration.md for configuration options and https://mynixos.com/nixpkgs/option/services.wivrn.config.json for an example configuration.
  # };

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
  networking.firewall.enable = false;
  networking.firewall.allowPing = true;
  # services.printing.enable = true;
  #
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.logind.settings.Login.HandlePowerKey = "suspend";

  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  services.netbird.enable = true;
  vpn.enable = false;

  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
