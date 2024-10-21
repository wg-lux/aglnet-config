{lib, ...}:
let
    paths = import ../paths/main.nix {inherit lib;};
    groups = import ../groups/main.nix {inherit lib;};
    users = import ../users/main.nix {inherit lib;};

    user = users.service.name;

    secret-filemode = "0600";
    mountpoint-filemode = "0700";

    keyfile-sops-base-path = "sensitive-hdd/keys";

    # Endoreg Access Groups:
    endoreg-dropoff-group = groups.endoreg-dropoff.name;
    endoreg-processing-group = groups.endoreg-processing.name;
    endoreg-processed-group = groups.endoreg-processed.name;

    mount-parent = paths.hardware.endoreg-sensitive-mount-parent;

    dropoff-label = "dropoff";
    processing-label = "processing";
    processed-label = "processed";

    endoreg-sensitive-mounting = {
        mount-parent = mount-parent;

        dropoff = {
            label = dropoff-label;
            keyfile-source = "${dropoff-label}.key";
            keyfile-target = "/etc/sensitive-${dropoff-label}.key";
            user = user;
            group = endoreg-dropoff-group;
            mountpoint = "${mount-parent}/${dropoff-label}";
            sops-target = "${keyfile-sops-base-path}/${dropoff-label}";
            filemode-secret = secret-filemode;
            filemode-mountpoint = mountpoint-filemode;
            mount-script-name = "mount-${dropoff-label}";
            umount-script-name = "umount-${dropoff-label}";
            mount-service-name = "mount-${dropoff-label}";
            umount-service-name = "umount-${dropoff-label}";
        };

        processing = {
            label = processing-label;
            keyfile-source = "${processing-label}.key";
            keyfile-target = "/etc/sensitive-${processing-label}.key";
            user = user;
            group = endoreg-processing-group;
            mountpoint = "${mount-parent}/${processing-label}";
            sops-target = "${keyfile-sops-base-path}/${processing-label}";
            filemode-secret = secret-filemode;
            filemode-mountpoint = mountpoint-filemode;
            mount-script-name = "mount-${processing-label}";
            umount-script-name = "umount-${processing-label}";
            mount-service-name = "mount-${processing-label}";
            umount-service-name = "umount-${processing-label}";
        };

        processed = {
            label = processed-label;
            keyfile-source = "${processed-label}.key";
            keyfile-target = "/etc/sensitive-${processed-label}.key";
            user = user;
            group = endoreg-processed-group;
            mountpoint = "${mount-parent}/${processed-label}";
            sops-target = "${keyfile-sops-base-path}/${processed-label}";
            filemode-secret = secret-filemode;
            filemode-mountpoint = mountpoint-filemode;
            mount-script-name = "mount-${processed-label}";
            umount-script-name = "umount-${processed-label}";
            mount-service-name = "mount-${processed-label}";
            umount-service-name = "umount-${processed-label}";
        };
    };

in endoreg-sensitive-mounting

