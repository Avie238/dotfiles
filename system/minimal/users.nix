{...}: {
  security.sudo.wheelNeedsPassword = false;

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';

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
