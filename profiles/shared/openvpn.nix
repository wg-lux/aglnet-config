{config, pkgs, network-config, lib ? <nixpkgs/lib>, ...}:
# {lib ? <nixpkgs/lib>, ...}:

let 
    conf = network-config.services.openvpn;
    hostname = config.networking.hostName;
    openvpn-host-hostname = conf.hostname;

    # # Check if hostname is same as openvpn hostname and generate bool variable from it
    is-openvpn-host = hostname == openvpn-host-hostname;    
    
    etc-files = if is-openvpn-host then conf.etc-files.server else conf.etc-files.client;


in {
    boot.initrd.network.openvpn.enable = true; # Starts Openvpn at stage 1 of boot
    environment.etc = etc-files; 

    #TODO Deploy the certificates
    #TODO Load Configuration file
    #TODO Check old configuration for other migrations
    #TODO Review update-resolv-conf


}