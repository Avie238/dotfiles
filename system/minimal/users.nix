{...}: {
  security.sudo.wheelNeedsPassword = false;

  users.users.avie = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
    createHome = true;
  };

  nix.settings.trusted-users = ["root" "avie"];
}
