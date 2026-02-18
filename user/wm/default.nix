{
  config,
  userSettings,
  ...
}: {
  imports = [
    ./gnome.nix
    ./hyprland
    ./niri
    ./utils
  ];

  systemd.user.sessionVariables = config.home.sessionVariables;

  xdg.desktopEntries = {
    nvim = {
      name = "nvim";
      genericName = "Text editor";
      exec = "${userSettings.term} -e nvim";
      terminal = false;
    };
  };
}
