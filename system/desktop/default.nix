{
  pkgs,
  userSettings,
  ...
}: {
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
  virtualisation.incus = {
    enable = true;
    ui.enable = true;
  };

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

  environment.systemPackages = with pkgs.x86; [
    steam
    wine
    lutris
    protonup-qt
    mesa-demos
  ];
  environment.etc = {
    "resolv.conf".text = ''
      search netbird.cloud
      nameserver 1.1.1.1
      options edns0'';
  };
  networking.firewall.enable = true;
  networking.firewall.allowPing = true;
  services.printing.enable = true;
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

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  services.netbird.enable = true;
}
