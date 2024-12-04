{
    network-interface = "wlo1"; 
    secondary-network-interface = "enp3s0"; 
    nvidiaBusId = "PCI:01:00:0"; 
    onboardGraphicBusId = "PCI:00:02:0";

    file-system-base-uuid = "None";
    file-system-boot-uuid = "None";
    swap-device-uuid = "None";

    luks-hdd-intern-uuid = "ccc2e3e1-f278-4802-8e58-b7f041549905";
    luks-swap-uuid = "ccc2e3e1-f278-4802-8e58-b7f041549905";

    kernel-modules = ["vmd" "xhci_pci" "nvme"];
    system-state = "24.11";
}