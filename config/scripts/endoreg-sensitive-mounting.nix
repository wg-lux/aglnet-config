{ lib, ... }:
let
  paths = import ../paths/main.nix { inherit lib; };
  groups = import ../groups/main.nix { inherit lib; };
  users = import ../users/main.nix { inherit lib; };

  log-dir = paths.logging.sensitive-partition-log-dir;

  user = users.service.name;

  secret-filemode = "0600";
  mountpoint-filemode = "0700";
  keyfile-sops-base-path = "sensitive-hdd/keys";

  # Endoreg Access Groups:
  endoreg-groups = {
    dropoff = groups.endoreg-dropoff.name;
    processing = groups.endoreg-processing.name;
    processed = groups.endoreg-processed.name;
  };

  mount-parent = paths.hardware.endoreg-sensitive-mount-parent;

  # Helper function to generate mount configurations
  createMountConfig = { label, group }:
    {
      label = label;
      keyfile-source = "${label}.key";
      keyfile-target = "/etc/sensitive-${label}.key";
      user = user;
      group = group;
      mountpoint = "${mount-parent}/${label}";
      sops-target = "${keyfile-sops-base-path}/${label}";
      filemode-secret = secret-filemode;
      filemode-mountpoint = mountpoint-filemode;
      mount-script-name = "mount-${label}";
      umount-script-name = "umount-${label}";
      mount-service-name = "mount-${label}";
      umount-service-name = "umount-${label}";
      log-script-name = "log-${label}";
      log-service-name = "log-${label}";
      # log-timer-name = "log-timer-${label}";
      log-timer-on-calendar = "*:0/30"; # Every 30 minutes
      log-dir = log-dir;
    };

  endoreg-sensitive-mounting = {
    mount-parent = mount-parent;

    dropoff = createMountConfig {
      label = "dropoff";
      group = endoreg-groups.dropoff;
    };

    processing = createMountConfig {
      label = "processing";
      group = endoreg-groups.processing;
    };

    processed = createMountConfig {
      label = "processed";
      group = endoreg-groups.processed;
    };
  };

in endoreg-sensitive-mounting
