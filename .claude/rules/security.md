---
paths:
  - "secrets/**"
  - "system/minimal/sops.nix"
  - "**/*.yaml"
  - ".sops.yaml"
---

# Security

- Never write plaintext secrets in `.nix` files. All secrets go through sops-nix.
- Never commit `secrets/secrets.yaml` unencrypted. The `.sops.yaml` rules must always match the encryption recipients.
- When editing `secrets/secrets.yaml`, use `sops secrets/secrets.yaml` — it decrypts in-editor and re-encrypts on save.
- Never add a new secret without a corresponding entry in `.sops.yaml` and the sops keyfile.
- The age key at `~/.config/sops/age/keys.txt` must never be committed.
- Never expose sops secret values in `environment.variables`, `environment.systemPackages` scripts, or other world-readable paths.
