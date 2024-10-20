let 
    network = {
        service-hosts = import ../service-hosts.nix;
        domains = import ./domains.nix;
        hosts = import ../hostnames.nix;
        ips = import ../ips.nix;
        ports = import ../ports.nix;
        urls = import ./urls.nix;
    };

in network;