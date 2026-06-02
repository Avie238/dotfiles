{pkgs, ...}: {
  programs.zsh = {
    enable = true;
  };

  users.defaultUserShell = pkgs.zsh;

  services.kmscon = {
    enable = true;
    fonts = [
      {
        name = "Jetbrains Mono NF";
        package = pkgs.nerd-fonts.jetbrains-mono;
      }
    ];
    extraConfig = "font-size=22";
  };
}
