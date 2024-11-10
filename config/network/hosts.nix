{ lib ? import <nixpkgs/lib> , ... }:
let 
    domains = import ./domains.nix { inherit lib; };
    service-hosts = import ../service-hosts.nix { inherit lib; };
    client-domains = domains.clients;

    ips = import ./ips.nix { inherit lib; };
    client-ips = ips.clients;

    hostnames = import ../hostnames.nix { inherit lib; };

    keycloak-ip = ips.clients."${service-hosts.keycloak}";
    keycloak-admin-domain = domains.keycloak-admin;

    # Create the `hosts` attribute set by iterating over `client-ips`
    hosts = lib.foldl' (acc: raw-hostname: 
        let 
            ip = client-ips.${raw-hostname};
        in
            acc // {
                "${ip}" = [ (client-domains.${raw-hostname}) hostnames.${raw-hostname} ];
            }
    ) {} (lib.attrNames client-ips);

    # create hosts by adding localhost to the hosts
    finalHosts = hosts // {
        "127.0.0.1" = [ "localhost" "localhost" ];
        "${keycloak-ip}" = [ keycloak-admin-domain hostnames."${service-hosts.keycloak}" ];
    };


in finalHosts
