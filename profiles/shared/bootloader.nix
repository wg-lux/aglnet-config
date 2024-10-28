{ config, lib, pkgs, modulesPath, network-config, ... }:
let 

  hostname = config.networking.hostName;
  hardware = network-config.hardware."${hostname}";

  kernel-modules = hardware.system.kernel-modules;
  initrd-available-kernel-modules = hardware.system.initrd-available-kernel-modules;


in {
    imports = [ 
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot.initrd.availableKernelModules = initrd-available-kernel-modules;
    boot.initrd.kernelModules = lib.mkDefault [ ];
    boot.kernelModules = kernel-modules;
    boot.extraModulePackages = lib.mkDefault [ ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_6_10;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

}