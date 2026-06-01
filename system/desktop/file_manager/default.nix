{
  pkgs,
  userSettings,
  ...
}: {
  imports = [
    ./thunar.nix
  ];

  services.tumbler.enable = true;
}
