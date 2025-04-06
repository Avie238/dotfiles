{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./default.nix
    ./desktop
  ];

}
