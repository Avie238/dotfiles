{pkgs}:
pkgs.stdenv.mkDerivation {
  pname = "collada-dom";
  version = "master";

  src = pkgs.fetchFromGitHub {
    owner = "rdiankov";
    repo = "collada-dom";
    rev = "c1e20b7d6ff806237030fe82f126cb86d661f063";
    sha256 = "A1ne/D6S0shwCzb9spd1MoSt/238HWA8dvgd+DC9cXc=";
  };

  patches = [./boost.patch];

  postInstall = ''
    chmod +w -R $out
    mv $out/include/*/* $out/include
  '';

  nativeBuildInputs = [pkgs.cmake];

  buildInputs = [
    pkgs.boost
    pkgs.libxml2
    pkgs.minizip
    pkgs.readline
  ];
}
