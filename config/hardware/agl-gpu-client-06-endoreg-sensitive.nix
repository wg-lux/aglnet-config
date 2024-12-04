{ ... }:
let
  sensitive-hdd = {
    # Partition dropoff
    "dropoff" = {
      label = "dropoff";
      device = "/dev/disk/by-uuid/74db40f6-0e50-41b0-b483-0738d56d7293";
      device-by-label = "/dev/disk/by-label/dropoff";
      mountPoint = "/mnt/sensitive-hdd-mount/dropoff";
      uuid = "74db40f6-0e50-41b0-b483-0738d56d7293";
      luks-uuid = "1f0eb18d-64f3-45d0-8346-4ebfebe635c4";
      luks-device = "/dev/disk/by-uuid/1f0eb18d-64f3-45d0-8346-4ebfebe635c4";
      fsType = "ext4";
    };
    # Partition processing
    "processing" = {
      label = "processing";
      device = "/dev/disk/by-uuid/54b97c07-11b8-4ca6-9bab-a1dcf8f6db39";
      device-by-label = "/dev/disk/by-label/processing";
      mountPoint = "/mnt/sensitive-hdd-mount/processing";
      uuid = "54b97c07-11b8-4ca6-9bab-a1dcf8f6db39";
      luks-uuid = "e3fe908c-dc3f-408a-997c-a953e9fe524a";
      luks-device = "/dev/disk/by-uuid/e3fe908c-dc3f-408a-997c-a953e9fe524a";
      fsType = "ext4";
    };
    # Partition processed
    "processed" = {
      label = "processed";
      device = "/dev/disk/by-uuid/f85c47d5-56dd-4a94-9c1b-4f46ecdd407f";
      device-by-label = "/dev/disk/by-label/processed";
      mountPoint = "/mnt/sensitive-hdd-mount/processed";
      uuid = "f85c47d5-56dd-4a94-9c1b-4f46ecdd407f";
      luks-uuid = "f6d0a094-3e33-40b9-be58-54be96810c2f";
      luks-device = "/dev/disk/by-uuid/f6d0a094-3e33-40b9-be58-54be96810c2f";
      fsType = "ext4";
    };
  };
in sensitive-hdd