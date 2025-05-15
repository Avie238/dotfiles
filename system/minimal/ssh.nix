{
  config,
  lib,
  ...
}: {
  programs.ssh = {
    startAgent = true;
    extraConfig = ''
      Host *
        AddKeysToAgent yes
        IdentityFile ${
        if config.sops.enable
        then config.sops.secrets."id_ed25519".path
        else "/id_ed25519"
      }
    '';
    knownHosts = {
      "github.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
    };
  };
}
