{pkgs, lib, ...}@args: {

    programs.captive-browser.enable = lib.mkDefault true;
    programs.captive-browser.interface = lib.mkDefault "wlo1";
    programs.captive-browser.package = lib.mkDefault pkgs.captive-browser; #default

    networking.networkmanager.enable = lib.mkDefault true;

    networking.useDHCP = lib.mkDefault true;

    networking.firewall.enable = lib.mkDefault true;
    networking.firewall.allowedTCPPorts = [ ];
    networking.firewall.allowedUDPPorts = [ ];
}