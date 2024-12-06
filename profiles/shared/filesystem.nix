{ config, lib, pkgs, custom-hardware, system-encrypted, ... }:

let 
    ch = custom-hardware;
    filesystem-base-uuid = ch.file-system-base-uuid;
    filesystem-boot-uuid = ch.file-system-boot-uuid;
    swap-uuid = ch.swap-device-uuid;
    has-swap = swap-uuid != null;
    swap-devices = if ! has-swap then [] else [
        { device = "/dev/disk/by-uuid/${swap-uuid}"; }
    ];

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

    fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/${filesystem-boot-uuid}";
        fsType = "vfat";
    } // lib.optionalAttrs (lib.hasAttr "boot-fs-options" ch) {
        options = custom-boot-options;
    };



    boot.initrd.luks.devices = if system-encrypted then 
        let
            luksDevices = {
            "luks-${luks-base-uuid}".device = "/dev/disk/by-uuid/${luks-base-uuid}";
            };
            swapLuksDevice = if has-swap then {
            "luks-${luks-swap-uuid}".device = "/dev/disk/by-uuid/${luks-swap-uuid}";
            } else {};
        in
        luksDevices // swapLuksDevice
    else {};


    swapDevices = swap-devices;
}