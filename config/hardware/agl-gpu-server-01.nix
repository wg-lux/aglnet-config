{
    network-interface = "eno1np1"; # select by user

    secondary-network-interface = "eno1np0"; # select by user
    
    nvidiaBusId = "PCI:01:00:0"; # select by user
    nvidiaBusId2 = "PCI:02:00:0"; # select by user
    onboardGraphicBusId = "PCI:198:00:0"; # select by user

    file-system-base-uuid = "73e4fbb8-d4b5-4a97-8767-c5b957370a7e"; 
    file-system-boot-uuid = "A122-97BD"; 
    swap-device-uuid = null;

    luks-hdd-intern-uuid = "x";
    luks-swap-uuid = "x";

    initrd-available-kernel-modules = [ 
      "xhci_pci" 
      "ahci" 
      "mpt3sas" # module is critical for systems relying on LSI/Broadcom SAS-3 controllers
      "usb_storage" 
      "usbhid" 
      "sd_mod" 
      "ast"
    ];
    kenel-modules = ["kvm-amd" ];
    boot-fs-options = [ "fmask=0022" "dmask=0022" ];
    cpu_type = "amd";

    # hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;


    system-state = "25.05"; # enter by user
}