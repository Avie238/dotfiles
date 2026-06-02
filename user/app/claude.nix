{
  pkgs,
  inputs,
  lib,
  ...
}: {
  programs.claude-code = {enable = true;};
}
