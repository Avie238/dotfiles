{pkgs, ...}: {
  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [thunar-archive-plugin thunar-volman];
}
