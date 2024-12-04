
{}
# let 
#   # Import hardware configuration based on the provided hostname config file

#   ## Also possible to import from a separate file
#   # hardware = import ;
#   # filesystem-luks-uuid = hardware.luks-hdd-intern-uuid;
#   # swap-luks-uuid = hardware.luks-swap-uuid;

#   filesystem-luks-uuid = "ccc2e3e1-f278-4802-8e58-b7f041549905";
#   swap-luks-uuid = "6f435f7a-4ce5-4ff9-b891-91a145832b66";
#   usb-uuid = "124d0fed-b6e2-44c2-b3ec-10f4f1ba2ede";
#   usb-mountpoint = "/mnt/usb_key";
#   usb-device = "/dev/disk/by-uuid/124d0fed-b6e2-44c2-b3ec-10f4f1ba2ede";

#   bs = 1;
#   offset-m = 50;
#   offset-b = 52428800;
#   keyfile-size = 4096;

# in {

#     boot.initrd.availableKernelModules = [ "dm-crypt" "sd_mod" "usb_storage"];

#     # boot.initrd.luks.devices."luks-ccc2e3e1-f278-4802-8e58-b7f041549905" = {
#     #     keyFile       = usb-device;
#     #     keyFileOffset = offset-b;
#     #     keyFileSize   = keyfile-size;
#     #     preLVM        = true;
#     #     fallbackToPassword = true;
#     # };

#     # boot.initrd.luks.devices."luks-6f435f7a-4ce5-4ff9-b891-91a145832b66" = {
#     #     keyFile       = usb-device;
#     #     keyFileOffset = offset-b;
#     #     keyFileSize   = keyfile-size;
#     #     preLVM        = true;
#     #     fallbackToPassword = true;
#     # };
# }
