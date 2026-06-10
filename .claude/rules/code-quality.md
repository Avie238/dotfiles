---
alwaysApply: true
---

# Code Quality

## Anti-defaults (counter common Claude tendencies)

- No premature abstractions. Three similar lines beats a helper used once.
- Don't add features or improvements beyond what was asked.
- Don't refactor adjacent code while fixing a bug.
- No dead code or commented-out blocks. Git has history.
- WHY comments, never WHAT. If code needs a "what" comment, rename instead.
- API docs at module boundaries only, not every internal function.

## Naming (Nix)

- Attribute names and option paths: camelCase (`userSettings`, `mkForce`, `services.myService.enable`).
- Derivation and package names: kebab-case (`my-package`, `pokemon-colorscripts`).
- NixOS module options: camelCase dots (`gaming.enable`, `sops.enable`).
- Script and package file names in `scripts/` and `packages/`: descriptive kebab-case matching their purpose.
- `lib.mk*` helpers: follow nixpkgs naming conventions (`mkIf`, `mkOption`, `mkDefault`).

## Code Markers

`TODO(author): desc (#issue)` for planned work. `FIXME(author): desc (#issue)` for known bugs. `HACK(author): desc (#issue)` for ugly workarounds (explain the proper fix). `NOTE: desc` for non-obvious context. Owner and issue link required. Never `XXX`, `TEMP`, `REMOVEME`.
