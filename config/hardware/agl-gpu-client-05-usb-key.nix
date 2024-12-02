let 
  # Import hardware configuration based on the provided hostname config file

  ## Also possible to import from a separate file
  # hardware = import ;
  # filesystem-luks-uuid = hardware.luks-hdd-intern-uuid;
  # swap-luks-uuid = hardware.luks-swap-uuid;

  filesystem-luks-uuid = "274d2191-1443-41f9-bee5-0efc0fc705bf";
  swap-luks-uuid = "6e991f24-1dbb-4bd8-a91c-849b887a0f6e";
  usb-uuid = "d56065d6-eb8b-453a-8f90-17ac4a7c165d";
  usb-mountpoint = "/mnt/usb_key";
  usb-device = "/dev/disk/by-uuid/d56065d6-eb8b-453a-8f90-17ac4a7c165d";

  bs = 1;
  offset-m = 50;
  offset-b = 52428800;
  keyfile-size = 4096;

in {

    boot.initrd.availableKernelModules = [ "dm-crypt" "sd_mod" "usb_storage"];

    boot.initrd.luks.devices."luks-274d2191-1443-41f9-bee5-0efc0fc705bf" = {
        keyFile       = usb-device;
        keyFileOffset = offset-b;
        keyFileSize   = keyfile-size;
        preLVM        = true;
        fallbackToPassword = true;
    };

    boot.initrd.luks.devices."luks-6e991f24-1dbb-4bd8-a91c-849b887a0f6e" = {
        keyFile       = usb-device;
        keyFileOffset = offset-b;
        keyFileSize   = keyfile-size;
        preLVM        = true;
        fallbackToPassword = true;
    };
}
