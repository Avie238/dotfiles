{pkgs}:
pkgs.writeShellApplication {
  name = "fn-toggle";
  excludeShellChecks = ["SC2086"];
  text = ''
    fnmode="$(cat /sys/module/hid_apple/parameters/fnmode)"
    if [ $fnmode == 1 ]; then
      echo 2 | sudo tee /sys/module/hid_apple/parameters/fnmode
    else
      echo 1 | sudo tee /sys/module/hid_apple/parameters/fnmode
    fi
  '';
}
