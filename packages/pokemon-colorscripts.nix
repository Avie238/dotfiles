{
  stdenv,
  fetchFromGitLab,
  python3,
}:
stdenv.mkDerivation {
  name = "pokemon-colorscripts";
  version = "unstable";

  src = fetchFromGitLab {
    owner = "phoneybadger";
    repo = "pokemon-colorscripts";
    rev = "5802ff67520be2ff6117a0abc78a08501f6252ad";
    hash = "sha256-gKVmpHKt7S2XhSxLDzbIHTjJMoiIk69Fch202FZffqU=";
  };

  buildInputs = [python3];

  preBuild = ''
    patchShebangs ./install.sh
    patchShebangs ./pokemon-colorscripts.py

    substituteInPlace install.sh --replace "/usr/local" "$out"
  '';

  installPhase = ''
    mkdir -p $out/bin
    ./install.sh
  '';

  meta = {
    homepage = "https://gitlab.com/phoneybadger/pokemon-colorscripts";
    description = "CLI utility to print out images of pokemon to terminal";
    longDescription = ''
      Prints out colored unicode sprites of pokemon onto your terminal.
      Contains almost 900 pokemon from gen 1 to gen 8.
    '';
  };
}
