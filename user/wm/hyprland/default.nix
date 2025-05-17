{
  pkgs,
  userSettings,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./hypridle.nix
    ./hyprlock.nix
    ./waybar.nix
  ];
  config = lib.mkIf (userSettings.wm == "hyprland") {
    xdg.autostart.enable = false;

    gtk.iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };

    home.packages = with pkgs; [
      brightnessctl
      networkmanagerapplet
      hyprnome
      hyprpaper
      (userSettings.fileManager.package)
      grimblast
      hyprsunset
      cmatrix
      cava
      btop
      baobab
      dunst
      nix-cleanup
      volumeControl
      brightnessControl
      (pkgs.extend inputs.nixos-muvm-fex.overlays.default).muvm
      unar
      openmw-dev
      delta-plugin
      s3lightfixes
      momw-configurator
      openmw-validator
      tes3cmd
      # umo
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        exec-once = [
          "dbus-update-activation-environment --systemd DISPLAY XAUTHORITY WAYLAND_DISPLAY XDG_SESSION_DESKTOP=Hyprland XDG_CURRENT_DESKTOP=Hyprland XDG_SESSION_TYPE=wayland"
          "[workspace 1 silent] uwsm app -- ${userSettings.term}"
          "[workspace 2 silent] uwsm app -- ${userSettings.editor.spawn}"
          "[workspace 3 silent] uwsm app -- ${userSettings.browser}"
        ];

        env = [
          "ELECTRON_OZONE_PLATFORM_HINT,auto"
          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_DESKTOP,Hyprland"
          "XDG_SESSION_TYPE,wayland"
          "GDK_BACKEND,wayland,x11,*"
          "QT_QPA_PLATFORM,wayland;xcb"
          "QT_QPA_PLATFORMTHEME,qt5ct"
          "QT_AUTO_SCREEN_SCALE_FACTOR,1"
          "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
          "CLUTTER_BACKEND,wayland"
        ];

        monitor = "internal,2560x1664@60,0x0,1";

        input = {
          kb_layout = userSettings.kb_layout;

          touchpad = {
            natural_scroll = true;
            clickfinger_behavior = true;
          };
        };

        "$mainMod" = "SUPER";

        bind =
          [
            "$mainMod, Q, killactive,"
            "SUPERSHIFT, Q, exec, uwsm stop"
            "$mainMod, E, exec, uwsm app -- ${userSettings.editor.spawn}"
            "$mainMod, T, exec, uwsm app -- ${userSettings.term}"
            #App launcher
            "$mainMod, $mainMod_L, exec, pkill ${userSettings.menu.name} || ${userSettings.menu.spawn}"
            #Screenshot
            "CTRL SHIFT, 3, exec, grimblast --freeze copysave output"
            "CTRL SHIFT, 4, exec, grimblast --freeze copysave area"
            "SUPERSHIFT, P, exec, hyprpicker --autocopy --format=hex"
            "$mainMod, Left, exec, hyprnome --previous"
            "$mainMod, Right, exec, hyprnome"
            "SUPER_SHIFT, Left, exec, hyprnome --previous --move"
            "SUPER_SHIFT, Right, exec, hyprnome --move"
            #Disable MMB
            ", mouse:274, exec,"
            #Scratch pads
            "SUPER, RETURN, exec, [workspace special:scratch_term silent] if hyprctl clients | grep scratch_term; then echo \"scratch_term respawn not needed\"; else uwsm app -- kitty; fi"
            "SUPER, RETURN, togglespecialworkspace,scratch_term"
            "SUPER, L, exec, [workspace special:scratch_files silent] if hyprctl clients | grep scratch_files; then echo \"scratch_files respawn not needed\"; else uwsm app -- ${userSettings.fileManager.spawn}; fi"
            "SUPER, L, togglespecialworkspace,scratch_files"
          ]
          ++ (builtins.concatLists (
            builtins.genList (
              i: let
                ws = i + 1;
              in [
                "$mainMod, code:1${toString i}, workspace, ${toString ws}"
                "$mainMod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            )
            9
          ));

        "$scratchpadsize" = "size 80% 85%";
        "$scratchpad" = "onworkspace:n[s:special:scratch]";
        windowrulev2 = [
          "float,$scratchpad"
          "$scratchpadsize,$scratchpad"
          "opacity 0.95, title:.vi.*"
          "opacity 0.85, class:kitty, title:negative:.vi.*"
        ];

        bindl = [
          ",switch:on:Lid Switch,exec, systemctl suspend"
        ];

        bindel = [
          ",XF86AudioRaiseVolume, exec, volumeControl -i"
          ",XF86AudioLowerVolume, exec, volumeControl -d"
          ",XF86AudioMute, exec, volumeControl -m"
          ",XF86MonBrightnessUp, exec, brightnessControl -i"
          ",XF86MonBrightnessDown, exec, brightnessControl -d"
          "SUPER, XF86MonBrightnessUp, exec, brightnessControl -i -k"
          "SUPER, XF86MonBrightnessDown, exec, brightnessControl -d -k"
        ];

        windowrule = [
          # "workspace empty,class:^(vesktop|firefox)$"
          "float, title:^(Volume Control|Bluetooth Devices|Network Connections)$"
          "size 50% 50%, title:^(Volume Control|Bluetooth Devices|Network Connections)$"
          "suppressevent maximize, class:.*"
          "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
        ];

        # workspace = [
        #   #Auto open firefox on new workspace
        #   "r[3-9], on-created-empty:[] firefox"
        # ];

        ecosystem = {
          no_update_news = true;
        };

        gestures = {
          workspace_swipe = true;
          workspace_swipe_distance = 150;
        };

        general = {
          gaps_in = 3;
          gaps_out = 7;
          border_size = 3;

          resize_on_border = false;
          allow_tearing = false;

          layout = "dwindle";
        };

        decoration = {
          rounding = 10;
          rounding_power = 2;

          active_opacity = 1.0;
          inactive_opacity = 1.0;

          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
          };

          blur = {
            enabled = true;
            size = 3;
            passes = 1;

            vibrancy = 0.1696;
          };
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        master = {
          new_status = "master";
        };

        animations = {
          enabled = true;

          bezier = [
            "easeOutQuint,0.23,1,0.32,1"
            "easeInOutCubic,0.65,0.05,0.36,1"
            "linear,0,0,1,1"
            "almostLinear,0.5,0.5,0.75,1.0"
            "quick,0.15,0,0.1,1"
          ];
          animation = [
            "global, 1, 10, default"
            "border, 1, 5.39, easeOutQuint"
            "windows, 1, 4.79, easeOutQuint"
            "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
            "windowsOut, 1, 1.49, linear, popin 87%"
            "fadeIn, 1, 1.73, almostLinear"
            "fadeOut, 1, 1.46, almostLinear"
            "fade, 1, 3.03, quick"
            "layers, 1, 3.81, easeOutQuint"
            "layersIn, 1, 4, easeOutQuint, fade"
            "layersOut, 1, 1.5, linear, fade"
            "fadeLayersIn, 1, 1.79, almostLinear"
            "fadeLayersOut, 1, 1.39, almostLinear"
            "specialWorkspace, 1, 4, default, slidefadevert -50%"
          ];
        };
      };

      xwayland.enable = true;
      systemd.enable = false;
    };

    programs.rofi = lib.mkIf (userSettings.menu.name == "rofi") {
      enable = true;
      package = pkgs.rofi-wayland;
    };

    services.hyprpaper.enable = true;

    services.dunst.enable = true;

    programs.tmux = {
      enable = true;
    };

    home.file.".config/environment.d/gsk.conf".text = "GSK_RENDERER=gl";

    xdg.mimeApps.defaultApplications = {
      "inode/directory" = [
        "${pkgs."${userSettings.fileManager.package}"}/bin/${userSettings.fileManager}"
      ];
    };
  };
}
