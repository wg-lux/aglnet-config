{ config, lib, pkgs, custom-hardware, system-encrypted, ... }:

let 
    ch = custom-hardware;
    filesystem-base-uuid = ch.file-system-base-uuid;
    filesystem-boot-uuid = ch.file-system-boot-uuid;
    swap-uuid = ch.swap-device-uuid;

    luks-base-uuid = ch.luks-hdd-intern-uuid;
    luks-swap-uuid = ch.luks-swap-uuid;
    inherit system-encrypted;
    hostname = config.networking.hostName;

    custom-boot-options = ch.boot-fs-options;

in {

    fileSystems."/" = { 
        device = "/dev/disk/by-uuid/${filesystem-base-uuid}";
        fsType = "ext4";
    };

    fileSystems."/boot".device = "/dev/disk/by-uuid/${filesystem-boot-uuid}"; 
    fileSystems."/boot".fsType = "vfat";

    # if hostname ==  in BOOT_OPTIONS then take the options from BOOT_OPTIONS else []
    fileSystems."/boot".options = ch.boot-fs-options;

    boot.initrd.luks.devices = if system-encrypted then {
        "luks-${luks-base-uuid}".device = "/dev/disk/by-uuid/${luks-base-uuid}";
        "luks-${luks-swap-uuid}".device = "/dev/disk/by-uuid/${luks-swap-uuid}";
    } else {};

    swapDevices = [ 
            { device = "/dev/disk/by-uuid/${swap-uuid}"; }
        ];
}