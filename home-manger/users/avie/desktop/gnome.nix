{
  config,
  pkgs,
  inputs,
  ...
}:

{

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        show-battery-percentage = true;
      };

    };
  };

}
