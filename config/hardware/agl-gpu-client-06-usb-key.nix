let 
  # Import hardware configuration based on the provided hostname config file

  ## Also possible to import from a separate file
  # hardware = import ;
  # filesystem-luks-uuid = hardware.luks-hdd-intern-uuid;
  # swap-luks-uuid = hardware.luks-swap-uuid;

  filesystem-luks-uuid = "9f299b66-59a4-46be-ab1b-afe0446322a9";
  swap-luks-uuid = "de4a4fd3-2b93-4e54-b84d-57cafc776360";
  usb-uuid = "b0f0ad55-619c-4a50-85cc-a4d6a9d6b9e9";
  usb-mountpoint = "/mnt/usb_key";
  usb-device = "/dev/disk/by-uuid/b0f0ad55-619c-4a50-85cc-a4d6a9d6b9e9";

  bs = 1;
  offset-m = 50;
  offset-b = 52428800;
  keyfile-size = 4096;

in {

    boot.initrd.availableKernelModules = [ "dm-crypt" "sd_mod" "usb_storage"];

    boot.initrd.luks.devices."luks-9f299b66-59a4-46be-ab1b-afe0446322a9" = {
        keyFile       = usb-device;
        keyFileOffset = offset-b;
        keyFileSize   = keyfile-size;
        preLVM        = true;
        fallbackToPassword = true;
    };

    boot.initrd.luks.devices."luks-de4a4fd3-2b93-4e54-b84d-57cafc776360" = {
        keyFile       = usb-device;
        keyFileOffset = offset-b;
        keyFileSize   = keyfile-size;
        preLVM        = true;
        fallbackToPassword = true;
    };
}
