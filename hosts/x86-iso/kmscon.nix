{
  pkgs,
  modulesPath,
  lib,
  config,
  ...
}:

{

  services.kmscon.enable = true;
  services.kmscon.autologinUser = "avie";

  console.packages = [ pkgs.terminus_font ];
  nix.settings.trusted-users = lib.mkForce [ "avie" ];

}
