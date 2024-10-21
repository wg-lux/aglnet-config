let 
  # Import hardware configuration based on the provided hostname config file

  ## Also possible to import from a separate file
  # hardware = import ;
  # filesystem-luks-uuid = hardware.luks-hdd-intern-uuid;
  # swap-luks-uuid = hardware.luks-swap-uuid;

  filesystem-luks-uuid = "428e63c6-f7bb-4e32-94af-cea7ad71bc51";
  swap-luks-uuid = "e701612f-d046-4505-8ea5-b7069222ae8c";
  usb-uuid = "ceb3283a-44aa-4c22-90be-caed45c4ef24";
  usb-mountpoint = "/mnt/usb_key";
  usb-device = "/dev/disk/by-uuid/ceb3283a-44aa-4c22-90be-caed45c4ef24";

  bs = 1;
  offset-m = 14900;
  offset-b = 15623782400;
  keyfile-size = 4096;

in {

    boot.initrd.availableKernelModules = [ "dm-crypt" "sd_mod" "usb_storage"];

    boot.initrd.luks.devices."luks-428e63c6-f7bb-4e32-94af-cea7ad71bc51" = {
        keyFile       = usb-device;
        keyFileOffset = offset-b;
        keyFileSize   = keyfile-size;
        preLVM        = true;
        fallbackToPassword = true;
    };

    boot.initrd.luks.devices."luks-e701612f-d046-4505-8ea5-b7069222ae8c" = {
        keyFile       = usb-device;
        keyFileOffset = offset-b;
        keyFileSize   = keyfile-size;
        preLVM        = true;
        fallbackToPassword = true;
    };
}
