let 
  # Import hardware configuration based on the provided hostname config file

  ## Also possible to import from a separate file
  # hardware = import ;
  # filesystem-luks-uuid = hardware.luks-hdd-intern-uuid;
  # swap-luks-uuid = hardware.luks-swap-uuid;

  filesystem-luks-uuid = "2d8b5a20-2780-43b6-a0f8-e26bd36d19e6";
  swap-luks-uuid = "4da269f8-08c4-4f1d-9fb3-dfd440c4bd32";
  usb-uuid = "0fa2944d-4cf8-47d0-b116-8faa810ca7e2";
  usb-mountpoint = "/mnt/usb_key";
  usb-device = "/dev/disk/by-uuid/0fa2944d-4cf8-47d0-b116-8faa810ca7e2";

  bs = 1;
  offset-m = 50;
  offset-b = 52428800;
  keyfile-size = 4096;

in {

    boot.initrd.availableKernelModules = [ "dm-crypt" "sd_mod" "usb_storage"];

    boot.initrd.luks.devices."luks-2d8b5a20-2780-43b6-a0f8-e26bd36d19e6" = {
        keyFile       = usb-device;
        keyFileOffset = offset-b;
        keyFileSize   = keyfile-size;
        preLVM        = true;
        fallbackToPassword = true;
    };

    boot.initrd.luks.devices."luks-4da269f8-08c4-4f1d-9fb3-dfd440c4bd32" = {
        keyFile       = usb-device;
        keyFileOffset = offset-b;
        keyFileSize   = keyfile-size;
        preLVM        = true;
        fallbackToPassword = true;
    };
}
