{...}: {
  services.samba = {
    enable = true;
    enableNmbd = false;
    enableWinbindd = false;
    settings = {
      global = {
        "guest account" = "myuser";
        "map to guest" = "Bad User";

        "load printers" = "no";
        "printcap name" = "/dev/null";
      };
      "public" = {
        "path" = "/data/media";
        "guest ok" = "yes";
        "read only" = "no";
      };
    };
  };
}
