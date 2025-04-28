{config, ...}: {
  programs.ssh = {
    startAgent = true;
    extraConfig = ''
      Host *
        AddKeysToAgent yes
        IdentityFile ${config.sops.secrets."id_ed25519".path}
    '';
  };
}
