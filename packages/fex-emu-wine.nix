{
  lib,
  stdenv,
  fetchurl,
  dpkg,
}:
# FEX's WoW64/ARM64EC emulation DLLs for AArch64 Wine, prebuilt from the
# FEX-Emu Ubuntu PPA (the dlls are self-contained PE binaries, so the
# Ubuntu series they were built for doesn't matter).
# https://asahilinux.org/2025/08/progress-report-6-16/
stdenv.mkDerivation {
  pname = "fex-emu-wine";
  version = "2605";

  src = fetchurl {
    url = "https://ppa.launchpadcontent.net/fex-emu/fex/ubuntu/pool/main/f/fex-emu-wine/fex-emu-wine_2605~1~r_arm64.deb";
    hash = "sha256-NoNSb2w04HiX3jGdXNFH3f/L0QBbrx3L+vUDwuon6FM=";
  };

  nativeBuildInputs = [dpkg];
  unpackCmd = "dpkg-deb -x $curSrc source";

  installPhase = ''
    mkdir -p $out/lib/wine/aarch64-windows
    # xtajit.dll: name Wine looks for when running 32-bit x86 code on arm64
    cp usr/lib/wine/aarch64-windows/libwow64fex.dll \
      $out/lib/wine/aarch64-windows/xtajit.dll
    cp usr/lib/wine/aarch64-windows/libarm64ecfex.dll \
      $out/lib/wine/aarch64-windows/libarm64ecfex.dll
  '';

  meta = {
    description = "FEX emulation DLLs for running x86 Windows applications under AArch64 Wine";
    homepage = "https://fex-emu.com/";
    license = lib.licenses.mit;
    platforms = ["aarch64-linux"];
  };
}
