{ pkgs, ... }:
{  
  # services.gnome.core-utilities.enable = true;

  environment.systemPackages = with pkgs; [
    kdePackages.xdg-desktop-portal-kde
    kdePackages.svgpart
    kdePackages.systemsettings
  ];

  services.desktopManager.plasma6.enable = true;
  services.displayManager = {
    defaultSession = "plasmax11";
    sddm.enable = true;
    # sddm.wayland.enable = true;
  };

  services.xserver = {
    enable = true;
    xkb.layout = "de";
    xkb.variant = "";
    displayManager = {
      gdm= {
        enable = false;
        autoSuspend = false;
      };
    };
  };
}