{ config, pkgs, ... }:

{
  boot.kernelParams = [
    "zswap.enabled=1"
    "zswap.compressor=zstd"
    "zswap.zpool=zsmalloc"
    "zswap.max_pool_percent=50"
  ];
}
