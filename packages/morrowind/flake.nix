{
  inputs = {
    nixpkgs.url = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
      };

      packages = with pkgs; [
        SDL2
        boost
        bullet'
        libxt
        luajit
        lz4
        mygui'
        openal
        osg'
        recastnavigation
        unshield
        yaml-cpp
        ffmpeg
      ];

      nativeBuildInputs = with pkgs; [
        cmake
        pkg-config
        libsForQt5.qt5.wrapQtAppsHook
        libsForQt5.qt5.qttools
      ];

      libraries = with pkgs; [
        webkitgtk_4_1

        gtk3

        cairo

        gdk-pixbuf

        glib

        dbus

        openssl

        librsvg
        libayatana-appindicator
        libappindicator
      ];
      GL = "GLVND"; # or "LEGACY";

      osg' = (pkgs.openscenegraph.override {colladaSupport = true;}).overrideDerivation (old: {
        version = "openmw-unstable-01-07-2024";
        # A dev recommended using the latest 3.6 branch. Seems to work well and fix a bug related to collada
        # randomly not loading compared to the one referenced in the flatpak build script.
        src = pkgs.fetchFromGitHub {
          owner = "openmw";
          repo = "osg";
          rev = "43faf6fa88bd236e0911a5340bfbcbc25b3a98d9";
          sha256 = "sha256-P/959OYW9F3hjgo3QdjVfNuCzS8e7y7oxpVj4Kcl1X4=";
        };
        patches = [
          (pkgs.fetchpatch {
            # Darwin: Without this patch, OSG won't build osgdb_png.so, which is required by OpenMW.
            name = "darwin-osg-plugins-fix.patch";
            url = "https://gitlab.com/OpenMW/openmw-dep/-/raw/1305497c009dc0e7a6a70fe14f0a2f92b96cbcb4/macos/osg.patch";
            sha256 = "sha256-G8Y+fnR6FRGxECWrei/Ixch3A3PkRfH6b5q9iawsSCY=";
          })
        ];
        cmakeFlags =
          (old.cmakeFlags or [])
          ++ [
            "-Wno-dev"
            "-DOpenGL_GL_PREFERENCE=${GL}"
            "-DBUILD_OSG_PLUGINS_BY_DEFAULT=0"
            "-DBUILD_OSG_DEPRECATED_SERIALIZERS=0"
          ]
          ++ (map (e: "-DBUILD_OSG_PLUGIN_${e}=1") [
            "BMP"
            "DAE"
            "DDS"
            "FREETYPE"
            "JPEG"
            "OSG"
            "PNG"
            "TGA"
          ]);
      });

      bullet' = pkgs.bullet.overrideDerivation (old: {
        cmakeFlags =
          (old.cmakeFlags or [])
          ++ [
            "-Wno-dev"
            "-DOpenGL_GL_PREFERENCE=${GL}"
            "-DUSE_DOUBLE_PRECISION=ON"
            "-DBULLET2_MULTITHREADING=ON"
          ];
      });

      mygui' = pkgs.mygui.overrideDerivation (old: rec {
        patches = [];
        version = "3.4.3";

        src = pkgs.fetchFromGitHub {
          owner = "MyGUI";
          repo = "mygui";
          rev = "MyGUI${version}";
          hash = "sha256-qif9trHgtWpYiDVXY3cjRsXypjjjgStX8tSWCnXhXlk=";
        };
        cmakeFlags = [
          "-DMYGUI_BUILD_TOOLS=OFF"
          "-DMYGUI_BUILD_DEMOS=OFF"
          "-DMYGUI_RENDERSYSTEM=4"
          "-DMYGUI_DONT_USE_OBSOLETE=TRUE"
        ];
      });
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = packages;

        nativeBuildInputs = nativeBuildInputs;

        shellHook = with pkgs; ''
          export LD_LIBRARY_PATH="${
            lib.makeLibraryPath libraries
          }:$LD_LIBRARY_PATH"


        '';
      };
    });
}
