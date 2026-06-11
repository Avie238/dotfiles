{
  lib,
  wineWow64Packages,
  fex-emu-wine,
}:
# Native AArch64 Wine running 32-bit x86 via FEX WoW64, without muvm.
# 64-bit x86 via ARM64EC (FEX libarm64ecfex.dll) requires Wine to export
# the full ARM64EC ntdll API set — pending upstream Wine support.
# https://asahilinux.org/2025/08/progress-report-6-16/
wineWow64Packages.unstable.overrideAttrs (old: {
  name = "wine-wow64-fex-${old.version}";

  # nixpkgs builds the x86_64 dlls as plain x86_64 PE, which an arm64 host
  # can't load (ntdll fails with STATUS_NOT_SUPPORTED). Building them as
  # ARM64EC/ARM64X is what lets an x86_64 process start at all.
  configureFlags =
    map (builtins.replaceStrings
      ["--enable-archs=aarch64,x86_64,i386"]
      ["--enable-archs=arm64ec,aarch64,i386"])
    old.configureFlags;

  # GNU strip rewrites the arm64x PE dlls (it knows pei-aarch64) moving
  # the NT headers from 0x78 to 0x80 without updating the ARM64X dynamic
  # relocations, so the AMD64 machine-override fixup misses the Machine
  # field and wine refuses to start x86_64 processes (STATUS_NOT_SUPPORTED,
  # c00000bb). Keep the PE dlls out of fixupPhase stripping.
  stripExclude = ["lib/wine/*-windows/*"];

  # FEX provides the 32-bit JIT provider (xtajit.dll) for running x86 code.
  # 64-bit x86 via libarm64ecfex.dll (xtajit64) requires Wine ntdll to export
  # ProcessPendingCrossProcessEmulatorWork and RtlIsEcCode (ARM64EC CHPE
  # infrastructure), which Wine 11.9 does not yet provide — FEX crashes at
  # a deliberate HLT assert in ProcessInit. Re-add xtajit64 once Wine ships
  # full ARM64EC ntdll support.
  postInstall =
    (old.postInstall or "")
    + ''
      cp ${fex-emu-wine}/lib/wine/aarch64-windows/xtajit.dll \
        $out/lib/wine/aarch64-windows/xtajit.dll
    '';

  meta =
    old.meta
    // {
      description = "AArch64 Wine with FEX for running x86/x86_64 Windows applications";
      platforms = ["aarch64-linux"];
    };
})
