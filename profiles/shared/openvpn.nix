{config, pkgs, network-config, lib ? <nixpkgs/lib>, ...}:
# {lib ? <nixpkgs/lib>, ...}:

let 
    conf = network-config.services.openvpn;
    hostname = config.networking.hostName;
    openvpn-host-hostname = conf.hostname;

    # # Check if hostname is same as openvpn hostname and generate bool variable from it
    is-openvpn-host = hostname == openvpn-host-hostname;    
    
    etc-files = if is-openvpn-host then conf.etc-files.server else conf.etc-files.client;

    shared-secrets = conf.secrets.shared;
    hostname-secrets = if is-openvpn-host then conf.secrets.server hostname else conf.secrets.client hostname;
    sops-secrets = shared-secrets // hostname-secrets;

    openvpn-config = if is-openvpn-host then conf.paths.server.conf else conf.paths.client.conf;

    extra-packages = 
        if is-openvpn-host then [ pkgs.openvpn pkgs.vault] 
        else [ ];

    dnsmasq-conf = network-config.services.dnsmasq;
    dnsmasq-port = dnsmasq-conf.port;
    dnsmasq-extra-config = dnsmasq-conf.extra-config;


in {
    boot.initrd.network.openvpn.enable = true; # Starts Openvpn at stage 1 of boot
    
    environment.etc = etc-files; 
    environment.systemPackages = extra-packages;

    sops.secrets = sops-secrets;
    networking.firewall.allowedTCPPorts =  if is-openvpn-host then [ conf.port ] else [ ];
    # networking.enableIPv4Forwarding = true;


    services.openvpn.restartAfterSleep = true;
    services.openvpn.servers = {
        aglNet = { 
            config = '' config ${openvpn-config}'';
            autoStart = true;
            updateResolvConf = true;
        };
    };


    ################ DNSMASQ
    networking.firewall.allowedUDPPorts = [ dnsmasq-port ];
    services.dnsmasq = {
        enable = true;
        extraConfig = dnsmasq-extra-config;
        alwaysKeepRunning = true;
    };


}