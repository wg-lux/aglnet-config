{
    network-interface = "enp2s0"; # select by user

    secondary-network-interface = ""; # select by user
    
    nvidiaBusId = ""; # select by user
    onboardGraphicBusId = "PCI:00:02:0"; # select by user

    file-system-base-uuid = "15fb4507-3e05-4ec8-8b6d-60c50d49f087"; 
    file-system-boot-uuid = "C8DC-81C9"; 
    swap-device-uuid = "fa117429-ffa5-40d3-9f26-3d48cabef36e";

    luks-hdd-intern-uuid = "";
    luks-swap-uuid = "";

    kernel-modules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
    initrd-available-kernel-modules = [ "kvm-intel" ];
    cpu_type = "intel";

    system-state = "23.11"; # enter by user
}
