let 
    paths = import ../../paths/main.nix;
    users = import ../../users/main.nix;
    groups = import ../../groups/main.nix;

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