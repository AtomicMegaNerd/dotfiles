# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/b068e72a-ee74-4594-af88-2509d2c86b40";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" "discard=async" ];
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/b068e72a-ee74-4594-af88-2509d2c86b40";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" "discard=async" ];
    };

  fileSystems."/nix" =
    {
      device = "/dev/disk/by-uuid/b068e72a-ee74-4594-af88-2509d2c86b40";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "discard=async" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/9774-1E76";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/bfdc7247-8a1a-4049-9a48-0883be9e387a"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp7s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;
}
