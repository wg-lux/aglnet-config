{lib ? import <nixpkgs/lib>, ...}:

let 
    service-hosts = import ../service-hosts.nix { inherit lib; };
    hostnames = import ../hostnames.nix { inherit lib; };
    ips = import ../network/ips.nix { inherit lib; };
    ports = import ../network/ports.nix { inherit lib; };
    port = ports.dnsmasq.port;

    domains = import ../network/domains.nix { inherit lib; };


    abstract-host = service-hosts.dnsmasq;
    hostname = hostnames."${abstract-host}";
    ip = ips.clients."${abstract-host}";

    server-hardware = import ../hardware/${hostname}.nix;
    network-interface = server-hardware.network-interface;

    extra-config = ''
    # Listen on the VPN server IP for DNS requests
        listen-address=127.0.0.1,${ip}

        # Forward to public DNS servers
        server=8.8.8.8
        server=8.8.4.4

        # Local domain configuration;
        # dnsmasq will not forward queries for *.endo-reg.net to upstream DNS servers
        local=/${domains.main}/

        # Interface and logging
        interface=${network-interface}
        bind-interfaces # Forces dnsmasq to bind only to the interfaces specified by the listen-address and interface options
        log-queries
        log-facility=/var/log/dnsmasq.log
    '';


    dnsmasq = {
        hostname = hostname;
        port = port;
        ip = ip;
        extra-config = extra-config;
    };

in dnsmasq
