{
    network-interface = "wlo1"; # select by user

    secondary-network-interface = "enp4s0"; # select by user

    nvidiaBusId = "PCI:01:00:0"; # select by user
    onboardGraphicBusId = "PCI:00:02:0"; # select by user

    file-system-base-uuid = "eb8c2a80-3615-492e-9426-5a0867d1719b";
    file-system-boot-uuid = "0BBB-8DA2";
    swap-device-uuid = "99942727-d084-4612-bc32-378f3cfce48d";

    luks-hdd-intern-uuid = "4052a436-8b52-4969-adc0-f0e985fe6b6d";
    luks-swap-uuid = "8d58f4dd-cfb1-4360-8410-60d1dad60741";

    kernel-modules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
    initrd-available-kernel-modules = [ "kvm-intel" ];


    system-state = "23.11"; # enter by user
}
