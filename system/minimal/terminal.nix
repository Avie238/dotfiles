{pkgs, ...}: {
  programs.zsh = {
    enable = true;
  };

  users.defaultUserShell = pkgs.zsh;
  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  # services.kmscon = {
  #   enable = true;
  #   config = {
  #     font-size = 22;
  #     font-name = "Jetbrains Mono NF";
  #   };
  # };
}
