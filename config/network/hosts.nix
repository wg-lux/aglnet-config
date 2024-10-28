{ lib ? import <nixpkgs/lib> , ... }:
let 
    domains = import ./domains.nix { inherit lib; };
    client-domains = domains.clients;

    ips = import ./ips.nix { inherit lib; };
    client-ips = ips.clients;

    hostnames = import ../hostnames.nix { inherit lib; };

    # Create the `hosts` attribute set by iterating over the `ips`
    hosts = lib.mapAttrs (raw-hostname: ip: {
        "${ip}" = [ (client-domains.${raw-hostname}) hostnames."${raw-hostname}" ];
    }) client-ips;

    # create hosts by adding localhost to the hosts
    finalHosts = hosts // {
        "127.0.0.1" = [ "localhost" "localhost" ];
    };


in finalHosts
