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

  /*
    src = pkgs.fetchurl {
    url = "mirror://sourceforge/collada-dom/Collada%20DOM/Collada%20DOM%202.2/Collada%20DOM%202.2.zip";
    name = "collada-dom-2.2.0.zip";
    sha256 = "sha256-Vr0gw5eHeA55Zko7X49hwAKAoXdS2PHzvGGR6oqg26Y=";
  };

  prePatch = ''
    cp Makefile.linux Makefile
    make os=linux project=minizip
  '';

  makeFlags = [
    "os=linux"
    "project=dom"
    "-C" "dom"
  ];
  */

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
