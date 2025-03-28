{ config, pkgs, ... }:

{
  programs.fastfetch = {
    enable = true;
    settings = builtins.fromJSON (builtins.readFile ./config.jsonc);
  };
}
