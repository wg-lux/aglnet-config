{ ... }:
let
  sensitive-hdd = {
    # Partition dropoff

#     # dropoff
# mapper_name = dropoff
# uuid = d90de9f1-88c4-4262-84b9-9b890333e4f0
# luks-uuid = 33f74540-77d0-4e4e-a632-fdaa39b1cbcb
# mountpoint = /mnt/sensitive-hdd-mount/dropoff

# # sudo cryptsetup open UUID=33f74540-77d0-4e4e-a632-fdaa39b1cbcb dropoff --key-file key-sdf1.key
# # sudo mount /dev/mapper/dropoff /mnt/sensitive-data-mount/dropoff

    "dropoff" = {
      label = "dropoff";
      device = "/dev/disk/by-uuid/d90de9f1-88c4-4262-84b9-9b890333e4f0";
      device-by-label = "/dev/disk/by-label/dropoff";
      mountPoint = "/mnt/sensitive-hdd-mount/dropoff";
      uuid = "d90de9f1-88c4-4262-84b9-9b890333e4f0";
      luks-uuid = "33f74540-77d0-4e4e-a632-fdaa39b1cbcb";
      luks-device = "/dev/disk/by-uuid/33f74540-77d0-4e4e-a632-fdaa39b1cbcb";
      fsType = "ext4";
    };
    # Partition processing
    "processing" = {
      label = "processing";
      device = "/dev/disk/by-uuid/982742d3-4a9c-4d7a-acb9-de2ae25170cd";
      device-by-label = "/dev/disk/by-label/processing";
      mountPoint = "/mnt/sensitive-hdd-mount/processing";
      uuid = "982742d3-4a9c-4d7a-acb9-de2ae25170cd";
      luks-uuid = "6306e841-38f0-44a5-a410-3cc2770f7176";
      luks-device = "/dev/disk/by-uuid/6306e841-38f0-44a5-a410-3cc2770f7176";
      fsType = "ext4";
    };
    # Partition processed
    "processed" = {
      label = "processed";
      device = "/dev/disk/by-uuid/cacaf010-70d4-4dc0-be26-b33fee85fe8d";
      device-by-label = "/dev/disk/by-label/processed";
      mountPoint = "/mnt/sensitive-hdd-mount/processed";
      uuid = "cacaf010-70d4-4dc0-be26-b33fee85fe8d";
      luks-uuid = "7269cc88-3e4b-4398-bda8-cb97d95e613f";
      luks-device = "/dev/disk/by-uuid/7269cc88-3e4b-4398-bda8-cb97d95e613f";
      fsType = "ext4";
    };
  };
in sensitive-hdd
