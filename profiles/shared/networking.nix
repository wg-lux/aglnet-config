{...}@args: {

    programs.captive-browser.enable = true;

    networking.networkmanager.enable = true;

    networking.firewall.enable = true;
    networking.firewall.allowedTCPPorts = [ ];
    networking.firewall.allowedUDPPorts = [ ];
}