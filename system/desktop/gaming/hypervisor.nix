{
  pkgs,
  lib,
  config,
  ...
}: {
  users.groups.libvirtd.members = ["avie"];
  # users.groups.libvirt.members = ["avie"];
  environment.systemPackages = with pkgs; [
    virt-viewer
    OVMF
    bridge-utils
    qemu
  ];
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        # runAsRoot =
      };
      hooks.qemu = {
        qemu = "/home/avie/Repos/single-gpu-passthrough/hooks/qemu";
      };
      extraConfig = "
log_filters=\"3:qemu 1:libvirt\"
log_outputs=\"2:file:/var/log/libvirt/libvirtd.log\"
      ";
    };
    spiceUSBRedirection.enable = true;
  };
}
