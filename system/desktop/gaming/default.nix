{
  pkgs,
  lib,
  config,
  ...
}: {
  services.xserver.videoDrivers = ["amdgpu"];
  # programs.alvr = {
  #   enable = true;
  #   openFirewall = true;
  # };
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
  services.wivrn = {
    enable = true;
    openFirewall = true;

    # Write information to /etc/xdg/openxr/1/active_runtime.json, VR applications
    # will automatically read this and work with WiVRn (Note: This does not currently
    # apply for games run in Valve's Proton)
    defaultRuntime = true;

    # Run WiVRn as a systemd service on startup
    autoStart = true;
    package = pkgs.wivrn.overrideAttrs (
      finalAttrs: prevAttrs: {
        version = "26.2.2";
        src = pkgs.fetchFromGitHub {
          owner = "wivrn";
          repo = "wivrn";
          rev = "v${finalAttrs.version}";
          hash = "sha256-DC+oHQLH9GlN/iDdk8XdPp1wENU5ZuZ+CC0x/wOlyYM=";
        };
        monado = pkgs.applyPatches {
          src = pkgs.fetchFromGitLab {
            domain = "gitlab.freedesktop.org";
            owner = "monado";
            repo = "monado";
            rev = "723652b545a79609f9f04cb89fcbf807d9d6451a";
            hash = "sha256-wGqvTI/X22apc8XCN3GCGQClHfBW5xk73mZnwWvHtyI=";
          };
          postPatch = ''
            ${finalAttrs.src}/patches/apply.sh ${finalAttrs.src}/patches/monado/*
          '';
        };
      }
    );
    # You should use the default configuration (which is no configuration), as that works the best out of the box.
    # However, if you need to configure something see https://github.com/WiVRn/WiVRn/blob/master/docs/configuration.md for configuration options and https://mynixos.com/nixpkgs/option/services.wivrn.config.json for an example configuration.
  };
  programs.gamemode.enable = true;
  programs.alvr = {
    enable = true;

    openFirewall = true;
    # Pin to 20.13.0 due to https://github.com/alvr-org/ALVR/issues/3134
    package = pkgs.alvr.overrideAttrs (
      finalAttrs: prevAttrs: {
        version = "20.13.0";

        src = pkgs.fetchFromGitHub {
          owner = "alvr-org";
          repo = "ALVR";
          tag = "v${finalAttrs.version}";
          fetchSubmodules = true;
          hash = "sha256-h7/fuuolxbNkjUbqXZ7NTb1AEaDMFaGv/S05faO2HIc=";
        };

        cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
          inherit (finalAttrs) src;
          hash = "sha256-A0ADPMhsREH1C/xpSxW4W2u4ziDrKRrQyY5kBDn//gQ=";
        };
      }
    );
  };
}
