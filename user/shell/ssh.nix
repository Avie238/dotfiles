{config, ...}: {
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
        AddKeysToAgent yes
        IdentityFile ${config.sops.secrets."id_ed25519"}'';
  };
}
