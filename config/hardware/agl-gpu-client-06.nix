{
    network-interface = "wlo1"; # select by user

    secondary-network-interface = "enp3s0"; # select by user
    
    nvidiaBusId = "PCI:01:00:0"; # select by user
    onboardGraphicBusId = "PCI:00:02:0"; # select by user

    file-system-base-uuid = "661a08e9-173e-4261-b42b-72b164e10620"; 
    file-system-boot-uuid = "6AB1-3D5C"; 
    swap-device-uuid = "9ff30f93-00ef-4b86-8652-1cee9b2e2530";

    luks-hdd-intern-uuid = "9f299b66-59a4-46be-ab1b-afe0446322a9";
    luks-swap-uuid = "de4a4fd3-2b93-4e54-b84d-57cafc776360";

    initrd-available-kernel-modules = [ 
        "vmd" # Volume Management Device
        "xhci_pci" # extensible host controller interface (USB and PCI stuff) 
        # "ahci" # Advanced host controller interface (SATA Stuff) 
        "nvme"
        "usb_storage"
        "usbhid"
        "sd_mod" ];
    #original-kernel-modules = [ 
    #    "vmd" 
    #    "xhci_pci" 
    #    "nvme" 
    #    "usbhid" 
    #    "usb_storage" 
    #    "sd_mod" 
    #];
    kernel-modules = [ "kvm-intel" ];

    boot-fs-options = [ "fmask=0077" "dmask=0077" ];

    system-state = "24.11"; # enter by user
}
