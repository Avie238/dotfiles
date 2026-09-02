# A muvm + FEX-Emu wrapper that runs the x86_64 faugus-launcher (and the
# umu/Proton game processes it spawns) on NixOS Asahi (Apple Silicon).
#
# Same approach as https://github.com/sm-idk/steam-asahi: Asahi runs a 16K-page
# kernel and only ships aarch64 userspace, so x86 games need (1) a 4K-page x86_64
# guest via muvm/libkrun and (2) FEX for instruction translation. The initScript
# below materializes the FHS layout pressure-vessel expects; umu-launcher uses
# the same Steam Linux Runtime container tooling as Steam, so the shims are
# identical. The FHS/etc/Vulkan/fusermount shim logic is lifted from steam-asahi.
{
  lib,
  writeShellApplication,
  symlinkJoin,
  makeDesktopItem,
  muvm,
  fex,
  fuse,
  fuse3,
  bash,
  coreutils,
  util-linux,
  gnugrep,
  pciutils,
  squashfuse,
  erofs-utils,
  yad,
  pulseaudio,
  lsb-release,
  glibc,
  faugusLauncherX86,
  memoryMiB ? null,
  extraEnv ? {
    # Conservative baseline only. Per-game flags (PROTON_USE_WINED3D=1,
    # FEX_X87REDUCEDPRECISION=1, …) belong in each game's launch arguments in
    # faugus-launcher because they can regress other titles.
    FEX_MULTIBLOCK = "0";
    # Host Vulkan layers live in unusual NixOS/FEX paths and pressure-vessel
    # errors out while importing them. ICD import (the GPU itself) still works.
    PRESSURE_VESSEL_IMPORT_VULKAN_LAYERS = "0";
  },
}: let
  extraEnvExports = lib.concatStringsSep " \\\n          " (
    lib.mapAttrsToList (k: v: "export ${k}=${lib.escapeShellArg v};") extraEnv
  );

  # NixOS /etc symlinks that bwrap can't follow — materialize as real files.
  etcSymlinksToMaterialize = [
    "host.conf"
    "hosts"
    "localtime"
    "os-release"
    "resolv.conf"
    "nsswitch.conf"
    "group"
    "passwd"
    "machine-id"
  ];

  # Stub dirs/files pressure-vessel expects but NixOS doesn't have.
  etcStubDirs = [
    "ld.so.conf.d"
    "alternatives"
    "xdg"
    "pulse"
  ];
  etcStubFiles = [
    "ld.so.cache"
    "ld.so.conf"
    "timezone"
  ];

  initScript = writeShellApplication {
    name = "faugus-asahi-init";
    runtimeInputs = [
      coreutils
      util-linux
      pciutils
    ];
    text = ''
      # NixOS has no FHS paths — create a writable tmpfs overlay with everything
      # bwrap/pressure-vessel/umu expect, then bind-mount it over the read-only
      # host /usr, /bin and /etc mounts inside the muvm guest.
      mkdir -p /run/fhs/bin /run/fhs/usr
      cp -a /bin/* /run/fhs/bin/ 2>/dev/null || true
      ln -sf ${bash}/bin/bash /run/fhs/bin/bash
      ln -sf ${bash}/bin/sh /run/fhs/bin/sh
      cat > /run/fhs/bin/lspci <<'EOF'
      #!/bin/sh
      # Apple Silicon normally has no PCI bus; umu/Proton only use lspci for
      # optional GPU probing, so stay quiet when there is nothing to list.
      if [ -d /sys/bus/pci/devices ]; then
        for dev in /sys/bus/pci/devices/*; do
          [ -e "$dev" ] && exec ${pciutils}/bin/lspci "$@"
        done
      fi
      exit 0
      EOF
      chmod +x /run/fhs/bin/lspci
      ln -sf ${lib.getExe' pulseaudio "pactl"} /run/fhs/bin/pactl
      ln -sf ${lib.getExe lsb-release} /run/fhs/bin/lsb_release
      ln -sf ${lib.getExe yad} /run/fhs/bin/zenity

      cp -a /usr/* /run/fhs/usr/ 2>/dev/null || true
      mkdir -p /run/fhs/usr/bin /run/fhs/usr/lib /run/fhs/usr/lib64
      ln -sf ${coreutils}/bin/env /run/fhs/usr/bin/env
      ln -sf /run/fhs/bin/lspci /run/fhs/usr/bin/lspci
      ln -sf ${lib.getExe' pulseaudio "pactl"} /run/fhs/usr/bin/pactl
      ln -sf ${lib.getExe lsb-release} /run/fhs/usr/bin/lsb_release
      ln -sf ${lib.getExe yad} /run/fhs/usr/bin/zenity

      # pressure-vessel can generate missing UTF-8 locales, but expects the glibc
      # charmaps under /usr/share/i18n. NixOS keeps them in /nix.
      mkdir -p /run/fhs/usr/share
      rm -rf /run/fhs/usr/share/i18n
      ln -s ${glibc}/share/i18n /run/fhs/usr/share/i18n

      # Expose host Vulkan metadata at standard FHS paths, and mirror it into
      # pressure-vessel's override tree (it rejects layers found in
      # /usr/share/vulkan unless the JSON is also under its overrides dir).
      mkdir -p /run/fhs/usr/share/vulkan /run/fhs/usr/lib/pressure-vessel/overrides/share/vulkan
      for subdir in icd.d explicit_layer.d implicit_layer.d; do
        src="/run/opengl-driver/share/vulkan/$subdir"
        [ -e "$src" ] || continue
        rm -rf "/run/fhs/usr/share/vulkan/$subdir"
        ln -s "$src" "/run/fhs/usr/share/vulkan/$subdir"
        mkdir -p "/run/fhs/usr/lib/pressure-vessel/overrides/share/vulkan/$subdir"
        for json in "$src"/*.json; do
          [ -e "$json" ] && ln -sf "$json" "/run/fhs/usr/lib/pressure-vessel/overrides/share/vulkan/$subdir/"
        done
      done

      # Fossilize/overlay layer JSONs Steam/umu drop in the user's XDG dir.
      mkdir -p /run/fhs/usr/lib/pressure-vessel/overrides/share/vulkan/implicit_layer.d
      for layer in /home/*/.local/share/vulkan/implicit_layer.d/steam*.json; do
        [ -f "$layer" ] && cp -f "$layer" /run/fhs/usr/lib/pressure-vessel/overrides/share/vulkan/implicit_layer.d/ 2>/dev/null || true
      done

      mount --bind /run/fhs/bin /bin
      mount --bind /run/fhs/usr /usr

      # /etc: same story. bwrap chokes on NixOS's layered symlinks
      # (host.conf -> /etc/static/ -> /nix/store/...) in a fresh mount namespace.
      mkdir -p /run/fhs/etc
      cp -a /etc/. /run/fhs/etc/ 2>/dev/null || true

      for f in ${lib.concatStringsSep " " etcSymlinksToMaterialize}; do
        if [ -L "/run/fhs/etc/$f" ]; then
          target=$(readlink -f "/run/fhs/etc/$f" 2>/dev/null) || continue
          rm -f "/run/fhs/etc/$f"
          if [ -f "$target" ]; then
            cp "$target" "/run/fhs/etc/$f"
          elif [ -d "$target" ]; then
            mkdir -p "/run/fhs/etc/$f" && cp -a "$target/." "/run/fhs/etc/$f/"
          fi
        fi
      done

      mkdir -p ${lib.concatMapStringsSep " " (d: "/run/fhs/etc/${d}") etcStubDirs}
      touch ${lib.concatMapStringsSep " " (f: "/run/fhs/etc/${f}") etcStubFiles}

      mount --bind /run/fhs/etc /etc

      # FEX needs a suid fusermount to mount its rootfs overlay.
      mkdir -p /run/wrappers
      mount -t tmpfs -o exec,suid tmpfs /run/wrappers
      mkdir -p /run/wrappers/bin
      cp ${lib.getExe' fuse "fusermount"} /run/wrappers/bin/fusermount
      cp ${lib.getExe' fuse3 "fusermount3"} /run/wrappers/bin/fusermount3
      chown root:root /run/wrappers/bin/fusermount /run/wrappers/bin/fusermount3
      chmod u=srx,g=x,o=x /run/wrappers/bin/fusermount /run/wrappers/bin/fusermount3
    '';
  };

  desktopItem = makeDesktopItem {
    name = "faugus-asahi";
    desktopName = "Faugus Launcher (Asahi)";
    comment = "Run Windows games on Apple Silicon via muvm + FEX-Emu";
    exec = "faugus-asahi %U";
    icon = "faugus-launcher";
    startupNotify = true;
    categories = ["Game"];
  };

  launcher = writeShellApplication {
    name = "faugus-asahi";
    runtimeInputs = [
      coreutils
      gnugrep
      squashfuse
      erofs-utils
    ];
    text = ''
      die() { echo "ERROR: $1" >&2; exit 1; }

      [[ "$(id -u)" -ne 0 ]] || die "Do not run faugus-asahi as root"

      # --- Ensure FEX rootfs (FEX >= 2605 is XDG-aware) ---
      if [[ -d "$HOME/.fex-emu" ]]; then
        fex_data_dir="$HOME/.fex-emu"
        fex_config="$HOME/.fex-emu/Config.json"
      else
        fex_data_dir="''${XDG_DATA_HOME:-$HOME/.local/share}/fex-emu"
        fex_config="''${XDG_CONFIG_HOME:-$HOME/.config}/fex-emu/Config.json"
      fi

      fex_configured=false
      if [[ -d "$fex_data_dir/RootFS" ]]; then
        for f in "$fex_data_dir/RootFS"/*; do
          case "$f" in
            *.ero | *.sqsh | *.img) fex_configured=true; break ;;
          esac
          [[ -d "$f" ]] && { fex_configured=true; break; }
        done
      fi
      if [[ "$fex_configured" = false && -f "$fex_config" ]] \
        && grep -qE '"RootFS"[[:space:]]*:[[:space:]]*"[^"]+"' "$fex_config" 2>/dev/null; then
        fex_configured=true
      fi

      if [[ "$fex_configured" = false ]]; then
        echo "FEX rootfs not found. Downloading Fedora 43 rootfs (~1.3GB, one time)..."
        ${lib.getExe' fex "FEXRootFSFetcher"} --assume-yes --distro-name=Fedora \
            --distro-version=43 --distro-list-first --as-is \
          || die "FEX rootfs download failed. Run 'FEXRootFSFetcher' from a terminal, then relaunch."
      fi

      muvm_mem_args=(${lib.optionalString (memoryMiB != null) "--mem=${toString memoryMiB}"})
      uid=$(id -u)

      run_in_vm() { # $1 = command string run inside FEXBash
        exec ${lib.getExe' coreutils "env"} \
          -u LANGUAGE -u LC_ADDRESS -u LC_COLLATE -u LC_CTYPE \
          -u LC_IDENTIFICATION -u LC_MEASUREMENT -u LC_MESSAGES -u LC_MONETARY \
          -u LC_NAME -u LC_NUMERIC -u LC_PAPER -u LC_TELEPHONE -u LC_TIME \
          LANG=C.UTF-8 LC_ALL=C.UTF-8 \
          ${lib.getExe muvm} \
          --gpu-mode=drm \
          "''${muvm_mem_args[@]}" \
          --execute-pre ${lib.getExe initScript} \
          --interactive \
          -e "PRESSURE_VESSEL_FILESYSTEMS_RO=/nix:/run/opengl-driver" \
          -- \
          FEXBash -c "\
            export PATH=/usr/local/bin:/usr/bin:/bin:\$PATH; \
            export PULSE_SERVER=unix:/run/user/$uid/pulse/native; \
            export SDL_AUDIODRIVER=pulseaudio; \
            unset LANGUAGE LC_ADDRESS LC_COLLATE LC_CTYPE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES LC_MONETARY LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE LC_TIME; \
            export LC_ALL=C.UTF-8; export LANG=C.UTF-8; \
            export LOCALE_ARCHIVE=/run/current-system/sw/lib/locale/locale-archive; \
            ${extraEnvExports}
            $1"
      }

      # Diagnostic mode: run an arbitrary command through the same plumbing.
      #   faugus-asahi --fex 'uname -m'            -> x86_64
      #   faugus-asahi --fex 'vulkaninfo --summary'
      if [[ "''${1:-}" == "--fex" ]]; then
        shift
        [[ $# -gt 0 ]] || die "usage: faugus-asahi --fex '<command>'"
        run_in_vm "$*"
      fi

      # Non-interactive launch (from a .desktop file): show a splash until the
      # faugus window is likely up.
      if ! [[ -t 0 || -t 1 ]]; then
        ${lib.getExe yad} --no-buttons --center --borders=16 \
          --title="Faugus Launcher" --window-icon=faugus-launcher \
          --text="Starting Faugus Launcher (microVM + FEX)..." &
        splash_pid=$!
        ( sleep 25; kill "$splash_pid" 2>/dev/null || true ) &
      fi

      faugus_args=""
      [[ $# -gt 0 ]] && faugus_args=" $*"
      echo "Launching faugus-launcher via muvm + FEX..."
      run_in_vm "exec ${lib.getExe faugusLauncherX86}$faugus_args"
    '';

    meta = {
      description = "faugus-launcher for NixOS on Apple Silicon via muvm + FEX-Emu";
      license = lib.licenses.mit;
      platforms = ["aarch64-linux"];
      mainProgram = "faugus-asahi";
    };
  };
in
  symlinkJoin {
    name = "faugus-asahi";
    paths = [
      launcher
      desktopItem
    ];
    postBuild = ''
      mkdir -p "$out/share"
      ln -s ${faugusLauncherX86}/share/icons "$out/share/icons"
    '';
    inherit (launcher) meta;
  }
