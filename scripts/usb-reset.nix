{pkgs}:
pkgs.writeShellScriptBin "usb-reset" ''
  if [ "$(id -u)" != "0" ]; then
    exec sudo "$0" "$@"
  fi

  # For each USB root hub, walk up to the host controller and rebind its driver.
  # Covers both platform bus (Asahi/ARM) and PCI bus (x86/xhci_hcd).
  for hub in /sys/bus/usb/devices/usb*; do
    hc=$(readlink -f "$hub/..")
    driver_path="$hc/driver"
    [ -L "$driver_path" ] || continue

    driver=$(readlink -f "$driver_path" | xargs basename)
    devname=$(basename "$hc")

    echo "Resetting $devname (driver: $driver)..."

    unbind_ok=0
    for bus in platform pci; do
      if echo "$devname" > "/sys/bus/$bus/drivers/$driver/unbind" 2>/dev/null; then
        unbind_ok=1
        sleep 1
        echo "$devname" > "/sys/bus/$bus/drivers/$driver/bind" 2>/dev/null \
          || echo "  warning: rebind failed"
        break
      fi
    done

    [ "$unbind_ok" -eq 1 ] && echo "  done" || echo "  skipped (could not unbind)"
  done
''
