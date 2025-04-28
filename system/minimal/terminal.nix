{pkgs, ...}: {
  programs.zsh = {
    enable = true;
  };

  users.defaultUserShell = pkgs.zsh;

  services.kmscon = {
    enable = true;
    autologinUser = "avie";
  };
}
