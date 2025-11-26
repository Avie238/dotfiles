{
  config,
  pkgs,
  ...
}: {
  imports = [
    # ./samba.nix
  ];
  services.logind.lidSwitchExternalPower = "ignore";

  services.openssh = {
    enable = true;
    ports = [22];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      AllowUsers = null;
      UseDns = true;
      X11Forwarding = true;
    };
  };

  users.users."avie".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEpr1NL5tOxml1z9ZlW0TW6o5d46SG+8lk+z6i4QS1G9 ania.dymowska238@gmail.com"
  ];

  virtualisation.docker = {
    enable = true;
    # enableNvidia = true;
  };

  users.users.avie.extraGroups = ["docker"];

  virtualisation.docker.daemon.settings.features.cdi = true;
  hardware.graphics.enable32Bit = true;
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia.open = false;
  hardware.nvidia-container-toolkit.enable = true;
  services.xserver.enable = true;

  # services.cockpit = {
  #   enable = true;
  #   port = 9090;
  #   openFirewall = true;
  #   settings = {
  #     WebService = {
  #       AllowUnencrypted = true;
  #     };
  #   };
  # };
  # environment.systemPackages = with pkgs; [
  #   cockpit
  # ];

  services.netbird.enable = true;
}
