# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{

  programs.zsh = {
    enable = true;
  };

  users.defaultUserShell = pkgs.zsh;

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

}
