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
  services.kmscon.fonts = [
    {
      name = "MesloLGS NF";
      package = pkgs.meslo-lgs-nf;
    }
  ];

  nix.settings.trusted-users = lib.mkForce [ "avie" ];

}
