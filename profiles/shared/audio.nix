{pkgs, ...}: {

  hardware.pulseaudio = {
    enable = false;
    package = pkgs.pulseaudioFull;  # Ensures full feature set
    extraConfig = ''
      load-module module-alsa-card
      load-module module-udev-detect
    '';
  };

  
  # Ensure all necessary firmware and drivers are available
  hardware.enableAllFirmware = true;

  environment.systemPackages = with pkgs; [];



}
