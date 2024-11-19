{config, pkgs, network-config, ...}: 
let 
    # https://git.eisfunke.com/config/nixos/-/blob/main/docs/graphics.md?ref_type=heads
    # https://nixos.wiki/wiki/Nvidia#Running_the_new_RTX_SUPER_on_nixos_stable

    hostname = config.networking.hostName;
    hardware-conf = network-config.hardware."${hostname}";
    onboardGraphicBusId = hardware-conf.system.onboardGraphicBusId;
    nvidiaBusId = hardware-conf.system.nvidiaBusId;


in {
  # hardware.graphics = true; # OpenGl will be migrated to hardware.graphics in 24.11
  hardware.opengl.enable = true;
  nixpkgs.config.cudaSupport = true;
  services.xserver.videoDrivers = ["nvidia"];
  boot.initrd.kernelModules = [ "nvidia" ];

  environment.systemPackages = with pkgs; [
    # cudaPackages.cudatoolkit
    autoAddDriverRunpath
  ];

  # specialisation = {
  #   on-the-go.configuration = {
  #     system.nixos.tags = [ "on-the-go" ];
  #     hardware.nvidia = {
  #       prime.offload.enable = pkgs.lib.mkForce false;
  #       prime.offload.enableOffloadCmd = pkgs.lib.mkForce false;
  #       prime.sync.enable = pkgs.lib.mkForce false;
  #     };
  #   };
  # };


  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "555.58";
      sha256_64bit = "sha256-bXvcXkg2kQZuCNKRZM5QoTaTjF4l2TtrsKUvyicj5ew=";
      sha256_aarch64 = pkgs.lib.fakeSha256;
      openSha256 = pkgs.lib.fakeSha256;
      settingsSha256 = "sha256-vWnrXlBCb3K5uVkDFmJDVq51wrCoqgPF03lSjZOuU8M=";
      persistencedSha256 = pkgs.lib.fakeSha256;
    };

    prime = {
      sync.enable = true; 
      # Make sure to use the correct Bus ID values for your system!
      intelBusId = onboardGraphicBusId;
      nvidiaBusId = nvidiaBusId;
    };
  };

}
