{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./../minimal
  ];

  sops.enable = false;

  #FIXME: Cross compilation not working for some reason
  localization.enable = false;

  system.activationScripts.copySecrets.text =
    #bash
    ''
      cp -p ${/run/secrets/wifi.env} /wifi.env
      cp -p ${/run/secrets/id_ed25519} /id_ed25519
      cp -p ${/home/avie/.config/sops/age/keys.txt} /keys.txt
    '';

  environment.shellAliases = {
    clone = "git clone git@github.com:Avie238/dotfiles && cd dotfiles";
  };

  services.xserver = {
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;
    desktopManager.gnome.enable = true;
  };

  environment.systemPackages = with pkgs; [
    gparted
  ];

  #Users
  users.users.avie.initialHashedPassword = "";
  users.users.nixos.enable = false;

  #Network
  networking.wireless.enable = false;
  networking.networkmanager.ensureProfiles.environmentFiles = lib.mkForce ["/wifi.env"];
}
