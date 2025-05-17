{
  python312,
  widevine-cdm,
  fetchFromGitLab,
  python312Packages,
  fetchPypi,
  lib,
}:
python312.pkgs.buildPythonApplication {
  name = "umo";
  version = widevine-cdm.version;
  src = fetchFromGitLab {
    owner = "Avie238";
    repo = "umo";
    rev = "b0827b9932f55db78a1c1bc39a9d56f99a8f77a3";
    hash = "sha256-lEkYSK07sAC9miXMJkaxXoBfW5+X/ztp5pT7o4Wo2lQ=";
  };

  format = "pyproject";
  buildInputs = [python312];

  dependencies = with python312Packages; [
    coloredlogs
    desktop-notifier
    pycryptodomex
    pycurl
    pydantic
    platformdirs
    (python312Packages.buildPythonPackage rec {
      pname = "curldl";
      version = "1.0.1";
      src = fetchPypi {
        inherit pname version;
        sha256 = "sha256-uMF/Fs+c5E6M6xnpuwF3jMin/RtgEcL3UvYwaXqV+FI=";
      };
      nativeBuildInputs = [setuptools-scm];
      build-system = [setuptools];
      dependencies = [tenacity tqdm pycurl];

      format = "pyproject";
    })
    pwinput
    websockets
    certifi
    beautifulsoup4
    typer
    click
    toml
    nuitka
    importlib-metadata
  ];

  buildPhase = ''
    python -m nuitka src/umo.py --standalone --include-package=dbus_fast --include-package=importlib.metadata --deployment                                                \
            --include-module=desktop_notifier.resources                 \
            --include-package-data=desktop_notifier                     \
            --output-filename=umo                                       \
            --output-dir=dist                                           \
            --remove-output                                             \
            --include-module=_json                                      \
            --include-module=_bisect                                    \
            --linux-icon=icons/KeenderM.png                             \
            --product-name=umo                                          \
            --file-version=0.9.4
    mkdir -p $out/bin
    cp -r dist $out/bin
  '';
}
