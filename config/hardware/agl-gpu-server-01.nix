{
    network-interface = "eno1np1"; # select by user


# NAME                  SIZE TYPE MOUNTPOINTS
#                                            UUID
# sda                 465.8G disk            
# ├─sda1                  1G part            AF9C-CC9F # 2ter Versuch
# └─sda2              464.7G part            deb5be66-f6bf-42db-8514-028394123e11
# sdb                   3.5T disk            
# ├─sdb1                100M part            
# ├─sdb2               1000M part /boot      3AAF-0A61 # 1 versuch
# └─sdb3                3.5T part            41yEIZ-q316-yj3q-A9m8-4qPC-uyAs-iuEvB7
#   └─pool-root         3.5T lvm  /nix/store 02da5c64-162e-43e4-8a00-9ef14acb547e # 1 versuch
#                                 /          
# sdc                   3.5T disk            
# ├─sdc1                  1M part            
# ├─sdc2                513M part            4CF6-D19D
# └─sdc3                3.5T part            YclHfI-VRcm-8raB-xdQ8-5h4E-jV1o-TpYreQ
#   ├─vgubuntu-root     3.5T lvm             ce71f55c-c616-4165-a203-d3ad4352a920
#   └─vgubuntu-swap_1   1.9G lvm             88f060d8-9ea8-4fc5-900b-78616928ca67



    secondary-network-interface = "eno1np0"; # select by user
    
    nvidiaBusId = "PCI:01:00:0"; # select by user
    nvidiaBusId2 = "PCI:02:00:0"; # select by user
    onboardGraphicBusId = "PCI:198:00:0"; # select by user

    file-system-base-uuid = "02da5c64-162e-43e4-8a00-9ef14acb547e"; 
    file-system-boot-uuid = "AF9C-CC9F"; 
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
    kernel-modules = ["kvm-amd" ];
    boot-fs-options = [ "fmask=0022" "dmask=0022" ];
    cpu_type = "amd";

    # hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;


    system-state = "25.05"; # enter by user
}