{
    network-interface = "wlo1"; # select by user

    secondary-network-interface = "enp3s0"; # select by user
    
    nvidiaBusId = "PCI:01:00:0"; # select by user
    onboardGraphicBusId = "PCI:00:02:0"; # select by user

    file-system-base-uuid = "1c77566e-0da4-4b2c-90db-afe8b0c73ce9"; 
    file-system-boot-uuid = "1872-E67D"; 
    swap-device-uuid = "2a57e304-91e3-488c-a9a0-09f19839c4b0";

    luks-hdd-intern-uuid = "ccc2e3e1-f278-4802-8e58-b7f041549905";
    luks-swap-uuid = "6f435f7a-4ce5-4ff9-b891-91a145832b66";

    kernel-modules =[ "vmd" "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
    initrd-available-kernel-modules = [ "kvm-intel" ];

    fileSystems."/boot".options = [ "fmask=0077" "dmask=0077" ];


    system-state = "24.11"; # enter by user
}
