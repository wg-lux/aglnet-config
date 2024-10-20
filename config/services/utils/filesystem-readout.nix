{ lib, ... }:
let 
    paths = import ../../paths/main.nix { inherit lib; };
    users = import ../../users/main.nix { inherit lib; };
    groups = import ../../groups/main.nix { inherit lib; };

    filesystem-readout = {
        path = paths.hardware.file-system-readout;
        service-user = users.root.name;
        service-group = groups.maintenance.name;
        maintenance-user = users.maintenance.name;
        maintenance-group = groups.maintenance.name;
        # path = "/etc/hardware-readout-filesystems.json";'
        # service-user = "root";
        # service-group = "maintenance";
        # maintenance-group = "maintenance";
        # maintenance-user = "maintenance-user";

        service-name = "filesystem-readout";
        script-name = "filesystem-readout-script";
    };

in filesystem-readout