{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    vm.enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf config.vm.enable {
    programs.virt-manager.enable = true;

    users.groups.libvirtd.members = ["avie"];

    environment.systemPackages = with pkgs; [
      virt-viewer
      spice
      spice-gtk
      spice-protocol
      qemu
    ];

    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          swtpm.enable = true;
          ovmf.enable = true;
          ovmf.packages = [pkgs.OVMFFull.fd];
        };
      };
      spiceUSBRedirection.enable = true;
    };
    services.spice-vdagentd.enable = true;
    boot.extraModulePackages = with config.boot.kernelPackages; [usbip];
    programs.nix-ld.enable = true;
  };
}
