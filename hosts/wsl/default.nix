{
  lib,
  inputs,
  userSettings,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.default
    (userSettings.dotfilesDir + "/profiles/${userSettings.profile}/configuration.nix")
  ];

  wsl.enable = true;
  wsl.defaultUser = "avie";

  nix.settings.ssl-cert-file = "/etc/ssl/certs/ca-bundle.crt";

  systemd.services.nix-daemon.environment = {
    NIX_SSL_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";
    GIT_SSL_CAINFO = "/etc/ssl/certs/ca-bundle.crt";
    CURL_CA_BUNDLE = lib.mkForce "/etc/ssl/certs/ca-bundle.crt";
  };

  security.pki.certificates = [
    (builtins.readFile ./Cummins-Prisma-Root-CA.crt)
    (builtins.readFile ./2895732A0D7425B1BE9C5F956DA4123956B71915__CN_WSUS_Publishers_Self_signed.pem)
    (builtins.readFile ./799168C7A0F9591CC71778CC5030A11684ADFC44__CN_Tanium_Inc___O_Tanium_Inc___L_Emeryville__S_California__C_US.pem)
    (builtins.readFile ./80A35C521E64B1EAA89FC493D63A82D34728FDED__CN_WSUS_Publishers_Self_signed.pem)
    (builtins.readFile ./8F43288AD272F3103B6FB1428485EA3014C0BCFE__CN_Microsoft_Root_Certificate_Authority_2011__O_Microsoft_Corporation__L_Redmond__S_Washington__C_US.pem)
    (builtins.readFile ./92B46C76E13054E104F230517E6E504D43AB10B5__CN_Symantec_Enterprise_Mobile_Root_for_Microsoft__O_Symantec_Corporation__C_US.pem)
    (builtins.readFile ./9EA77BA6D30BB2AB2DECE2DFDC2470429DCC3677__CN_Microsoft_Intune_Root_Certification_Authority.pem)
    (builtins.readFile ./A197D6717352023B615F6ED444A6981ABC80F6C9__CN_Microsoft_Intune_Root_Certification_Authority.pem)
    (builtins.readFile ./C5091132E9ADF8AD3E33932AE60A5C8FA939E824__CN_Cisco_Umbrella_Root_CA__O_Cisco.pem)
    (builtins.readFile ./F5119CB571036EDF6712D07ED078703677984957__CN_mkcert_CED_AT21T_W1_A1047744__Anna_Dymowska___OU_CED_AT21T_W1_A1047744__Anna_Dymowska___O_mkcert_developm.pem)
  ];

  boot.loader = {
    systemd-boot.enable = lib.mkForce false;
    grub.enable = lib.mkForce false;
  };

  environment.systemPackages = with pkgs; [
    xfce.thunar
    claude-code
    nodejs
    distrobox
  ];
  programs.nix-ld.enable = true;
  sops.enable = false;
  vm.enable = false;
  vpn.enable = false;

  networking.hostName = userSettings.hostname;

  system.stateVersion = "26.05";
}
