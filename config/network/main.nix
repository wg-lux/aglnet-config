{ lib, ... }:
let 
    network = {
        service-hosts = import ../service-hosts.nix { inherit lib;};
        hostsnames = import ../hostnames.nix { inherit lib;};
        domains = import ./domains.nix { inherit lib;};
        ips = import ./ips.nix { inherit lib;};
        ports = import ./ports.nix { inherit lib;};
        urls = import ./urls.nix { inherit lib;};
        identities = import ./identities.nix { inherit lib;};
    };

in network