{ config, lib, pkgs, custom-hardware, ... }:

let 
    ch = custom-hardware;
    filesystem-base-uuid = ch.file-system-base-uuid;
    filesystem-boot-uuid = ch.file-system-boot-uuid;
    swap-uuid = ch.swap-device-uuid;

    luks-base-uuid = ch.luks-hdd-intern-uuid;
    luks-swap-uuid = ch.luks-swap-uuid;

in {

    fileSystems."/" = { 
        device = "/dev/disk/by-uuid/${filesystem-base-uuid}";
        fsType = "ext4";
    };

    fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/${filesystem-boot-uuid}"; 
        fsType = "vfat";
    };

    boot.initrd.luks.devices = {
        "luks-${luks-base-uuid}".device = "/dev/disk/by-uuid/${luks-base-uuid}";
        "luks-${luks-swap-uuid}".device = "/dev/disk/by-uuid/${luks-swap-uuid}";
    };

    swapDevices = [ 
            { device = "/dev/disk/by-uuid/${swap-uuid}"; }
        ];
}