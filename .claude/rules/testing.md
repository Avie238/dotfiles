---
alwaysApply: true
---

# Validation

- Before applying to the live system, always build first: `nixos-rebuild build --flake .#<host>` or `nix eval --raw .#nixosConfigurations.<host>.config.system.build.toplevel.drvPath`.
- `nix flake check` errors on the Asahi `linux-asahi` package — use the eval form above to validate config changes instead.
- Test the specific host affected by a change, not all hosts.
- Never run `sudo nixos-rebuild switch` without a successful build check first.
- For new packages or scripts, verify with `nix build .#<pkg>` before wiring into a host config.
