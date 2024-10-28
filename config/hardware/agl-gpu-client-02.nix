{
    network-interface = "wlo1"; # select by user

    secondary-network-interface = "enp4s0"; # select by user
    
    nvidiaBusId = "PCI:01:00:0"; # select by user
    onboardGraphicBusId = "PCI:00:02:0"; # select by user

    file-system-base-uuid = "d4b66dbd-9bf4-4d2c-94a8-030592681888"; 
    file-system-boot-uuid = "B969-AD7C"; 
    swap-device-uuid = "125ea13e-20db-426b-9428-4a5e67596f15";

    luks-hdd-intern-uuid = "11b8d63b-d405-463c-b12e-d8466538fabb";
    luks-swap-uuid = "a1354565-9805-46f8-88a7-f96b4b513208";


    kernel-modules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
    initrd-available-kernel-modules = [ "kvm-intel" ];

    system-state = "23.11"; # enter by user
}
