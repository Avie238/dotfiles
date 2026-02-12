{
  stdenv,
  fetchgit,
  lib,
  pkgs,
}:
stdenv.mkDerivation {
  pname = "QRookie";
  version = "0.4.2";

  src = fetchgit {
    url = "https://github.com/glaumar/QRookie.git";
    rev = "ad637ce1b6707f3dbbbbed8e0abcd16c16a8bf64";
    # fetchSubmodules = false;
    # fetchLFS = true;
    sha256 = "sha256-RAWFAxO3+y6Vl5z0DMT2Gez1OzCbmxPwQ3UBXYnzkx8=";
  };

  nativeBuildInputs = with pkgs; [
    cmake
    qt6.wrapQtAppsHook
    kdePackages.extra-cmake-modules
  ];

  buildInputs = with pkgs;
    [
      kdePackages.qtbase
      kdePackages.qtdeclarative
      kdePackages.qcoro
      kdePackages.kirigami
      kdePackages.qtsvg
      kdePackages.qtimageformats
    ]
    ++ lib.optionals stdenv.isLinux [
      kdePackages.qqc2-breeze-style
    ]
    ++ lib.optionals stdenv.isDarwin [
      kdePackages.breeze-icons
    ];

  qtWrapperArgs = with pkgs; [
    ''
      --prefix PATH : ${lib.makeBinPath [p7zip apktool xdg-utils android-tools apksigner jdk21_headless]}
    ''
  ];

  cmakeFlags = ["-DCMAKE_BUILD_TYPE=Release"];

  meta = with pkgs.lib; {
    homepage = "https://github.com/glaumar/QRookie";
    description = ''
      Download and install Quest games from ROOKIE Public Mirror.
    '';
    licencse = licenses.gpl3;
    platforms = platforms.all;
  };
}
