{pkgs, ...}: {
  programs.zsh = {
    enable = true;
  };

  users.defaultUserShell = pkgs.zsh;

  services.kmscon = {
    enable = true;
    autologinUser = "avie";
    fonts = [
      {
        name = "MesloLGS NF";
        package = pkgs.meslo-lgs-nf;
      }
    ];
    extraConfig = "font-size=20";
  };
}
