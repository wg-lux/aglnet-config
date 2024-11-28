let 
  # Import hardware configuration based on the provided hostname config file

  ## Also possible to import from a separate file
  # hardware = import ;
  # filesystem-luks-uuid = hardware.luks-hdd-intern-uuid;
  # swap-luks-uuid = hardware.luks-swap-uuid;

  filesystem-luks-uuid = "4052a436-8b52-4969-adc0-f0e985fe6b6d";
  swap-luks-uuid = "8d58f4dd-cfb1-4360-8410-60d1dad60741";
  usb-uuid = "f3bbdd87-6e3e-441c-929e-7e3e69961041";
  usb-mountpoint = "/mnt/usb_key";
  usb-device = "/dev/disk/by-uuid/f3bbdd87-6e3e-441c-929e-7e3e69961041";

  bs = 1;
  offset-m = 50;
  offset-b = 52428800;
  keyfile-size = 4096;

in {

    boot.initrd.availableKernelModules = [ "dm-crypt" "sd_mod" "usb_storage"];

    boot.initrd.luks.devices."luks-4052a436-8b52-4969-adc0-f0e985fe6b6d" = {
        keyFile       = usb-device;
        keyFileOffset = offset-b;
        keyFileSize   = keyfile-size;
        preLVM        = true;
        fallbackToPassword = true;
    };

    boot.initrd.luks.devices."luks-8d58f4dd-cfb1-4360-8410-60d1dad60741" = {
        keyFile       = usb-device;
        keyFileOffset = offset-b;
        keyFileSize   = keyfile-size;
        preLVM        = true;
        fallbackToPassword = true;
    };
}
