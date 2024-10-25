let 
  # Import hardware configuration based on the provided hostname config file

  ## Also possible to import from a separate file
  # hardware = import ./agl-gpu-client-02.nix;
  # filesystem-luks-uuid = hardware.luks-hdd-intern-uuid;
  # swap-luks-uuid = hardware.luks-swap-uuid;

  filesystem-luks-uuid = "428e63c6-f7bb-4e32-94af-cea7ad71bc51";
  swap-luks-uuid = "e701612f-d046-4505-8ea5-b7069222ae8c";
  usb-uuid = "be57cff9-21f5-4bc8-bbc5-9e57ad93e1fb";
  usb-mountpoint = "/mnt/usb_key";
  usb-device = "/dev/disk/by-uuid/be57cff9-21f5-4bc8-bbc5-9e57ad93e1fb";

  bs = 1;
  offset-m = 50;
  offset-b = 52428800;
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
