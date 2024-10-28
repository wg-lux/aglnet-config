{config, pkgs, network-config, lib ? <nixpkgs/lib>, ...}:
# {lib ? <nixpkgs/lib>, ...}:

let 
    conf = network-config.services.openvpn;
    main-domain = network-config.network.domains.main;
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
        if is-openvpn-host then [ pkgs.openvpn pkgs.vault ]pkgs.traceroute  
        else [ pkgs.traceroute ];


in {

    programs.dublin-traceroute.enable = true;
    networking.domain = main-domain;

    networking.nameservers = [ "8.8.8.8" "1.1.1.1" ];
    boot.initrd.network.openvpn.enable = true; # Starts Openvpn at stage 1 of boot
    
    environment.etc = etc-files; 
    environment.systemPackages = extra-packages;

    sops.secrets = sops-secrets;
    networking.firewall.allowedTCPPorts =  if is-openvpn-host then [ conf.port ] else [ ];


    services.openvpn.restartAfterSleep = true;
    services.openvpn.servers = {
        aglNet = { 
            config = '' config ${openvpn-config}'';
            autoStart = true;
            updateResolvConf = false;
        };
    };



}