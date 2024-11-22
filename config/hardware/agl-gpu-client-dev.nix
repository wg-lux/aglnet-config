{
    network-interface = "wlo1"; # select by user

    secondary-network-interface = "enp4s0"; # select by user
    
    nvidiaBusId = "PCI:01:00:0"; # select by user
    onboardGraphicBusId = "PCI:00:02:0"; # select by user

    file-system-base-uuid = "57583232-d300-40d8-ae04-3ae510697a13"; 
    file-system-boot-uuid = "739A-7657"; 
    swap-device-uuid = "8c497dfb-c2ae-46d1-9314-305dddd50620";

    luks-hdd-intern-uuid = "2d8b5a20-2780-43b6-a0f8-e26bd36d19e6";
    luks-swap-uuid = "4da269f8-08c4-4f1d-9fb3-dfd440c4bd32";

    kernel-modules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
    initrd-available-kernel-modules = [ "kvm-intel" ];


    system-state = "23.11"; # enter by user
}
