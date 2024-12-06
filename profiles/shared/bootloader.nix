{ config, lib, pkgs, modulesPath, network-config, ... }:
let 

  hostname = config.networking.hostName;
  hardware = network-config.hardware."${hostname}";

  kernel-modules = hardware.system.kernel-modules;
  initrd-available-kernel-modules = hardware.system.initrd-available-kernel-modules;
  cpu_type = hardware.system.cpu_type;

  # if hostname == "agl-gpu-server-01" then use_grub = true and use_systemd_boot = false; else use_grub = false and use_systemd_boot = true;

  use_grub = if hostname == "agl-gpu-server-01" then true else false;
  use_systemd_boot = if hostname == "agl-gpu-server-01" then false else true;

in {
    imports = [ 
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot.initrd.availableKernelModules = initrd-available-kernel-modules;
    boot.initrd.kernelModules = lib.mkDefault [ ];
    boot.kernelModules = kernel-modules;
    boot.extraModulePackages = lib.mkDefault [ ];

    boot.loader.systemd-boot.enable = use_systemd_boot;
    boot.loader.grub = {
      enable = use_grub;
      device = "/dev/disk/by-uuid/3AAF-0A61";
      # devices = [ ];   # Multiple devices can be specified here
      efiSupport = true;
      # efiInstallAsRemovable = true;
    };
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_6_11;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu."${cpu_type}".updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

}