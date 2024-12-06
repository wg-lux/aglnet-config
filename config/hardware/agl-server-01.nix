{
    network-interface = "enp4s0"; # select by user

    secondary-network-interface = "eno1"; # select by user
    
    nvidiaBusId = ""; # select by user
    onboardGraphicBusId = ""; # select by user

    file-system-base-uuid = "f7bf81b8-fd1b-44ed-9592-0d44092aae54"; 
    file-system-boot-uuid = "8CD8-AB8E"; 
    swap-device-uuid = "43135921-9453-4711-8539-dcd23cc62cd8";

    luks-hdd-intern-uuid = "";
    luks-swap-uuid = "";

    kernel-modules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
    initrd-available-kernel-modules = [ "kvm-amd" ];
    cpu_type = "amd";
    system-state = "23.11"; # enter by user
}
