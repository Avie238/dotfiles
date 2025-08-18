{pkgs}:
pkgs.writeShellApplication {
  name = "cbz_to_webp";
  excludeShellChecks = ["SC2035" "SC2012"];

  runtimeInputs = with pkgs; [imagemagick libwebp zip];
  text = ''
    file="$1"
    pwd_comic="$PWD"

    unar -o /tmp/comic_temp -D "$file"
    cd /tmp/comic_temp
    file_count="$(ls -1 | wc -l )"
    if [ "$file_count" == 1 ]; then
      cd "$(ls -d */|head -n 1)"
    fi
    mogrify -format webp -quality 80 *.jpg
    rm *.jpg
    cd ..

    if [ "$file_count" == 1 ]; then
      zip -r "''${file%.*}-webp.zip" "$(ls -d */|head -n 1)"
      mv "''${file%.*}-webp.zip" ./..
      cd ..
    else
      zip -r "''${file%.*}-webp.zip" "comic_temp"
    fi

    mv "''${file%.*}-webp.zip" "''${file%.*}-webp.cbz"

    mv "''${file%.*}-webp.cbz" "$pwd_comic"

    rm -r /tmp/comic_temp  '';
}
