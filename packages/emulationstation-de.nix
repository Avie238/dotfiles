{
  lib,
  appimageTools,
  fetchurl,
}: let
  version = "3.4.1-58";
  pname = "es-de";

  src = fetchurl {
    url = "https://gitlab.com/es-de/emulationstation-de/-/package_files/288156961/download";
    hash = "sha256-PGGkTXONVRY9qljt5wcgtCWg32JGDATcI908pYZyNYE=";
  };

  appimageContents = appimageTools.extractType1 {inherit pname version src;};
in
  appimageTools.wrapType2 rec {
    inherit pname version src;

    # extraInstallCommands = ''
    #   substituteInPlace $out/share/applications/org.es_de.frontend.desktop \
    #     --replace-fail 'Exec=AppRun' 'Exec=emulationstation-de'
    # '';
    #
    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/org.es_de.frontend.desktop $out/share/applications/${pname}.desktop

      install -m 444 -D ${appimageContents}/org.es_de.frontend.svg $out/share/icons/hicolor/512x512/apps/${pname}.svg

      substituteInPlace $out/share/applications/${pname}.desktop \
      	--replace 'Exec=AppRun --no-sandbox %U' 'Exec=${pname} %U'
    '';

    meta = {
      downloadPage = "https://gitlab.com/es-de/emulationstation-de/-/releases";
      platforms = ["x86_64-linux"];
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
    };
  }
