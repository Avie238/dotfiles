{pkgs, ...}: {
  programs.thunar.enable = true;

  programs.thunar.plugins = with pkgs; [
    thunar-archive-plugin # Requires an Archive manager like file-roller, ark, etc
    thunar-volman
  ];
  environment.systemPackages = [
    pkgs.file-roller
  ];
}
