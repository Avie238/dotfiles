{...}: {
  imports = [
    ./../minimal
    ./wm
    ./zswap.nix
    ./stylix.nix
  ];

  hardware.graphics = {
    enable = true;
  };

  virtualisation.docker.enable = true;
}
