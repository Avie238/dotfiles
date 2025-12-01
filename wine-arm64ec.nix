{pkgs, ...}:
pkgs.wineWow64Packages.full.overrideAttrs (old: {
  name = "wine-wow64-arm64ec";

  nativeBuildInputs =
    old.nativeBuildInputs
    ++ [pkgs.llvm-arm64ec.clang pkgs.llvm-arm64ec.lld];

  # buildInputs =
  #   old.buildInputs
  #   ++ [pkgs.mingwArm64ec];

  configureFlags =
    old.configureFlags
    ++ [
      "--enable-archs=arm64ec,aarch64"
      "CC=${pkgs.llvm-arm64ec.clang}/bin/clang"
      "LD=${pkgs.llvm-arm64ec.lld}/bin/lld"
    ];
  meta = {
    platforms = ["aarch64-linux" "x86_64-linux"];
  };
})
