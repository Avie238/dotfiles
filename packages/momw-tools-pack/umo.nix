{
  python3Packages,
  fetchFromGitLab,
  fetchPypi,
  lib,
  pkgs,
}: let
  curldl = python3Packages.buildPythonPackage rec {
    pname = "curldl";
    version = "1.0.1";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-uMF/Fs+c5E6M6xnpuwF3jMin/RtgEcL3UvYwaXqV+FI=";
    };

    pyproject = true;
    dependencies = with python3Packages; [pycurl tenacity tqdm];
    nativeBuildInputs = with python3Packages; [setuptools setuptools-scm];

    meta = {
      description = "Safely and reliably download files with PycURL";
      homepage = "https://github.com/noexec/curldl";
      license = lib.licenses.lgpl3;
    };
  };
in
  python3Packages.buildPythonApplication rec {
    pname = "umo";
    version = "0.9.4";

    src = fetchFromGitLab {
      owner = "modding-openmw";
      repo = "umo";
      rev = version;
      sha256 = "sha256-lEkYSK07sAC9miXMJkaxXoBfW5+X/ztp5pT7o4Wo2lQ=";
    };

    pyproject = true;

    build-system = with python3Packages; [
      setuptools
    ];
    dependencies = with python3Packages; [
      coloredlogs
      desktop-notifier

      curldl
      pkgs.desktop-file-utils
      pycurl
      pydantic
      pycryptodomex
      platformdirs
      rarfile
      pwinput
      websockets
      certifi
      beautifulsoup4
      typer
      click
      toml
    ];

    pythonRelaxDeps = true;

    nativeInstallCheckInputs = [pkgs.versionCheckHook];
    versionCheckProgramArg = "--version";
    doInstallCheck = true;
    installCheckPhase = ''
      # have to import hook manually, something is broken for automatic import
      source ${pkgs.versionCheckHook}/nix-support/setup-hook
      versionCheckHook
    '';

    meta = {
      description = "umo is an automatic modlist downloader for Modding-OpenMW.com";
      homepage = "https://gitlab.com/modding-openmw/umo";
      license = lib.licenses.agpl3Only;
      mainProgram = "umo";
    };
  }
