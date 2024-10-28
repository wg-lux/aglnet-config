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

    dnsmasq = {
        enable = true;
        hostname = hostname;
        port = port;
        ip = ip;
        # extra-config = extra-config; # DEPRECEATED
        settings = {
            listen-address = "127.0.0.1,${ip}";
            local="/${domains.main}/";
            interface = network-interface;
            bind-interfaces = true;
            log-queries = true;
            log-facility = "/var/log/dnsmasq.log";
            server = [
                "8.8.8.8"
                "4.4.4.4"
            ];
        };
    };

in dnsmasq
