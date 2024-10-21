{ ... }:
let 
    hardware = {
        file-system-readout = "/etc/hardware-readout-filesystems.json";
        endoreg-sensitive-mount-parent = "/mnt/endoreg-sensitive";
    };
    
in hardware