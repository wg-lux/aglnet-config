let 
  # Import hardware configuration based on the provided hostname config file

  ## Also possible to import from a separate file
  # hardware = import ./agl-gpu-client-02.nix;
  # filesystem-luks-uuid = hardware.luks-hdd-intern-uuid;
  # swap-luks-uuid = hardware.luks-swap-uuid;

  filesystem-luks-uuid = "11b8d63b-d405-463c-b12e-d8466538fabb";
  swap-luks-uuid = "a1354565-9805-46f8-88a7-f96b4b513208";
  usb-uuid = "805dcffe-4fb4-4417-9731-fbaed37f9393";
  usb-mountpoint = "/mnt/usb_key";
  usb-device = "/dev/disk/by-uuid/805dcffe-4fb4-4417-9731-fbaed37f9393";

  bs = 1;
  offset-m = 50;
  offset-b = 52428800;
  keyfile-size = 4096;

in {

    boot.initrd.availableKernelModules = [ "dm-crypt" "sd_mod" "usb_storage"];

    boot.initrd.luks.devices."luks-11b8d63b-d405-463c-b12e-d8466538fabb" = {
        keyFile       = usb-device;
        keyFileOffset = offset-b;
        keyFileSize   = keyfile-size;
        preLVM        = true;
        fallbackToPassword = true;
    };

    boot.initrd.luks.devices."luks-a1354565-9805-46f8-88a7-f96b4b513208" = {
        keyFile       = usb-device;
        keyFileOffset = offset-b;
        keyFileSize   = keyfile-size;
        preLVM        = true;
        fallbackToPassword = true;
    };
}
