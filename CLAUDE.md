# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A NixOS flake managing multiple machines for user `avie`. All system and home configuration lives here; changes take effect via `nixos-rebuild`.

## Commands

```sh
# Apply configuration to the current machine (alias: nix-rebuild)
sudo nixos-rebuild switch --flake ~/dotfiles/#

# Build a specific host without switching (useful to verify changes compile)
nixos-rebuild build --flake .#<host>   # avie-nixos | artemis-nixos | homelab-nixos | wsl-nixos

# Evaluate-only syntax/eval check
nix flake check

# Update all flake inputs, then rebuild (alias: nix-update)
nix flake update --flake ~/dotfiles

# Build the Asahi installer ISO (alias: iso_arm)
nix build .#installer-bootstrap -o results/iso-asahi -j6 -L --impure
```

There are no tests or linters configured; `nixos-rebuild build` / `nix flake check` is the way to validate changes. Known pre-existing failure: `nix flake check` errors with `packages.aarch64-linux.linux-asahi is not a derivation`; to validate config changes, eval instead: `nix eval --raw .#nixosConfigurations.<host>.config.system.build.toplevel.drvPath`.

## Architecture

Everything is parameterized by a `userSettings` attrset generated in `flake.nix` (`genUserSettings`). It carries per-host choices — `wm` (niri/hyprland/none), `browser`, `term`, `editor`, `theme`, `profile`, `stable`, `dotfilesDir` — and is passed via `specialArgs`/`extraSpecialArgs`. When adding configurable behavior, prefer extending `userSettings` or branching on it.

Layering: `flake.nix` (nixosConfigurations) → `hosts/` (hardware) → `profiles/` (system + home entry points) → `system/` (NixOS modules) + `user/` (home-manager modules). Custom derivations in `packages/` and `scripts/`, exposed via their `overlay.nix`.

Cross-cutting toggles are NixOS options (e.g. `gaming.enable`, `sops.enable`). Secrets via sops-nix (`secrets/secrets.yaml`, key at `~/.config/sops/age/keys.txt`). Theming via Stylix (`system/desktop/stylix.nix`).

## Binary caches

Substituters/keys have a single source of truth: the `nixConfig` block in `flake.nix`. It serves fresh-install bootstrap directly (needs a trusted user to accept, e.g. `--accept-flake-config`), and `system/minimal/default.nix` re-reads it via `(import ../../flake.nix).nixConfig` into `nix.settings` for steady state (the installer ISO inherits this via `system/iso` → `system/minimal`). `nixConfig` values must stay literal — Nix rejects computed values with "setting ... is a thunk". No per-host duplicates.

Asahi kernel cache invariant (avoids hours-long local kernel builds):

- The `apple-silicon`, `hyprland`, and `niri` flake inputs must NOT have `inputs.nixpkgs.follows` — their cachix caches only hold builds against each flake's own locked nixpkgs (for apple-silicon that means hours-long local kernel builds).
- Inputs used by stable hosts (`home-manager-stable`, `nixos-wsl`) follow `nixpkgs-stable`, not `nixpkgs`. `nixCats`, `impermanence`, and `flake-compat` have no nixpkgs input — adding follows is a no-op that emits a lock warning.
- `hosts/asahi/default.nix` pins `hardware.asahi.pkgs` (via `lib.mkForce`) to an import of `inputs.apple-silicon.inputs.nixpkgs` mirroring upstream's `packages` output exactly; keep it argument-identical to their flake.nix.
- After changing the `apple-silicon` input, re-lock with `nix flake update apple-silicon` — a plain `nix flake lock` dedupes `apple-silicon/nixpkgs` onto the root nixpkgs node and breaks cache hits.
- To verify a cache hit: eval `.#nixosConfigurations.avie-nixos.config.boot.kernelPackages.kernel.outPath`, then curl `https://nixos-apple-silicon.cachix.org/<hash>.narinfo` (expect HTTP 200).

## Environment notes

- `python3` and `jq` are not on PATH; use `nix run nixpkgs#jq -- <args>` for JSON inspection.
- To get a `fetchFromGitHub` hash: `nix-prefetch-url --unpack https://github.com/<owner>/<repo>/archive/<rev>.tar.gz` → `nix hash convert --hash-algo sha256 --to sri <base32>`.
