{lib, ...}: {
  imports = [
    ./../minimal
  ];

  sops.enable = false;
  localization.enable = false;

  system.activationScripts.copySecrets.text = ''
    cp -p ${/run/secrets/wifi.env} /wifi.env
    cp -p ${/home/avie/.config/sops/age/keys.txt} /keys.txt
  '';

  environment.shellAliases = {
    clone = "git clone https://github.com/Avie238/dotfiles && cd dotfiles";
    copy = "sudo mkdir -p /mnt/var/lib/sops-nix && sudo cp /keys.txt /mnt/var/lib/sops-nix/keys.txt";
  };

  #Users
  users.users.avie.initialHashedPassword = "";
  nix.settings.trusted-users = lib.mkForce ["avie"];
  users.users.nixos.enable = false;

  #Network
  networking.wireless.enable = false;
  networking.networkmanager.ensureProfiles.environmentFiles = lib.mkForce ["/wifi.env"];
}
