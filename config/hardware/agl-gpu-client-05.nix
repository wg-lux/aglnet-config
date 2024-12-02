{
    network-interface = "wlo1"; # select by user

    secondary-network-interface = "enp4s0"; # select by user
    
    nvidiaBusId = "PCI:01:00:0"; # select by user
    onboardGraphicBusId = "PCI:00:02:0"; # select by user

    file-system-base-uuid = "c8fdc2af-c01c-4237-9f58-91f7ad7acf50"; 
    file-system-boot-uuid = "9675-A87D"; 
    swap-device-uuid = "d321d297-a334-4a1a-a77b-00b2974f4358";

    luks-hdd-intern-uuid = "274d2191-1443-41f9-bee5-0efc0fc705bf";
    luks-swap-uuid = "6e991f24-1dbb-4bd8-a91c-849b887a0f6e";

    kernel-modules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
    initrd-available-kernel-modules = [ "kvm-intel" ];


    system-state = "23.11"; # enter by user
}
