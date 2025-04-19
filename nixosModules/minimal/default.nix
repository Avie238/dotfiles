{
  pkgs,
  lib,
  inputs,
  userSettings,
  config,
  ...
}:

let
  mkGrubFont =
    font:
    pkgs.runCommand "${font.package.name}.pf2"
      {
        FONTCONFIG_FILE = pkgs.makeFontsConf { fontDirectories = [ font.package ]; };
      }
      ''
        # Use fontconfig to select the correct .ttf or .otf file based on name
        font=$(
          ${lib.getExe' pkgs.fontconfig "fc-match"} \
          ${lib.escapeShellArg font.name} \
          --format=%{file}
        )

        # Convert to .pf2
        ${pkgs.grub2}/bin/grub-mkfont $font --output $out --size ${toString 36}
      '';

in

{
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./localization.nix
    ./network.nix
    ./users.nix
    ./sops.nix
    ./terminal.nix
  ];

  boot.loader = {
    grub = {
      enable = true;
      # font = lib.mkForce (toString (mkGrubFont config.stylix.fonts.monospace));

      # gfxpayloadEfi = "2560x1600x32"; # TTY resolution (grub > videoinfo)
      # gfxmodeEfi = "auto"; # Grub resolution (overridden by console mode)
    };
    timeout = 2;
    efi.canTouchEfiVariables = lib.mkDefault true;
  };
  boot.supportedFilesystems = [ "apfs" ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    download-buffer-size = 524288000;
  };

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    tree
    git
    nixfmt-rfc-style
  ];

}
