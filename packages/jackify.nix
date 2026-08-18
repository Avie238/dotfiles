{
  lib,
  python3,
  fetchFromGitHub,
  makeWrapper,
  autoPatchelfHook,
  stdenv,
  openssl,
  zlib,
}: let
  # solsticegamestudios fork of vdf (Steam VDF file parser), required by Jackify.
  # The upstream PyPI vdf package is a different fork.
  vdf = python3.pkgs.buildPythonPackage {
    pname = "vdf";
    version = "unstable-2024-06-04";
    src = fetchFromGitHub {
      owner = "solsticegamestudios";
      repo = "vdf";
      rev = "f47c683c1330f0fcddec034fd49c26e41acd63f2";
      hash = "sha256-MK83/IrUGYulAt1z1obUYoL1HxmvdlWmgD2coduo/3s=";
    };

    format = "setuptools";
    doCheck = false;
  };
in
  python3.pkgs.buildPythonApplication {
    pname = "jackify";
    version = "0.6.0.1";

    src = fetchFromGitHub {
      owner = "Omni-guides";
      repo = "Jackify";
      tag = "v0.7.2.2";
      hash = "sha256-nGGlnPKWKWTNJJ9wOi0FqZquK+rk7xQbFlpfyLuXgvI=";
    };

    format = "other";

    nativeBuildInputs = [makeWrapper autoPatchelfHook];

    # liblttng-ust is the LTTng userspace tracing library used only by the .NET
    # CoreCLR diagnostics/profiling component. It is not needed for normal operation.
    autoPatchelfIgnoreMissingDeps = ["liblttng-ust.so.0"];

    # Native libraries required by the bundled .NET 9 CoreCLR runtime.
    buildInputs = [
      stdenv.cc.cc.lib # libstdc++.so.6, libgcc_s.so.1
      openssl # libssl.so.3, libcrypto.so.3
      zlib # libz.so.1
    ];

    propagatedBuildInputs = with python3.pkgs; [
      pyside6
      psutil
      requests
      tqdm
      pycryptodome
      pyyaml
      packaging
      watchdog
      vdf
    ];

    installPhase = ''
          runHook preInstall

          # Install the Python package into site-packages.
          mkdir -p $out/${python3.sitePackages}
          cp -r jackify $out/${python3.sitePackages}/

          # Launcher scripts — wrapPythonPrograms (postFixup) will inject PYTHONPATH.
          mkdir -p $out/bin

          cat > $out/bin/jackify <<'EOF'
      #!/usr/bin/env python3
      import sys
      from jackify.__main__ import main
      sys.exit(main() or 0)
      EOF
          chmod +x $out/bin/jackify

          cat > $out/bin/jackify-cli <<'EOF'
      #!/usr/bin/env python3
      import sys
      from jackify.frontends.cli.main import JackifyCLI
      cli = JackifyCLI()
      sys.exit(cli.run() or 0)
      EOF
          chmod +x $out/bin/jackify-cli

          runHook postInstall
    '';

    # jackify-engine loads libcoreclr.so, libclrjit.so, etc. via dlopen at
    # runtime (they are not listed in DT_NEEDED).  autoPatchelfHook only patches
    # DT_NEEDED dependencies, so those co-located .so files are never added to the
    # binary's RUNPATH.  Injecting LD_LIBRARY_PATH into the Python launcher wrapper
    # is the right fix: the subprocess inherits it and dlopen resolves correctly.
    makeWrapperArgs = [
      "--prefix"
      "LD_LIBRARY_PATH"
      ":"
      "${placeholder "out"}/${python3.sitePackages}/jackify/engine"
      # .NET's SSL/TLS layer and other native interop libs use dlopen at runtime,
      # so their directories must be in LD_LIBRARY_PATH even though they appear in
      # buildInputs (which only covers explicit DT_NEEDED resolution by autoPatchelf).
      "--prefix"
      "LD_LIBRARY_PATH"
      ":"
      "${openssl.out}/lib"
      "--prefix"
      "LD_LIBRARY_PATH"
      ":"
      "${zlib}/lib"
      # The bundled DLLs contain ReadyToRun native sections compiled for Windows.
      # Disable R2R so CoreCLR JIT-compiles from the portable IL instead.
      "--set"
      "DOTNET_ReadyToRun"
      "0"
      # ICU is not bundled; use invariant globalization mode (fine for a mod installer).
      "--set"
      "DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"
      "1"
    ];

    meta = with lib; {
      description = "GUI and CLI tool for installing Wabbajack modlists on Linux and Steam Deck";
      homepage = "https://github.com/Omni-guides/Jackify";
      license = licenses.gpl3Only;
      platforms = platforms.linux;
      mainProgram = "jackify";
    };
  }
