{ lib, ... }:
let 
    paths = import ../../paths/main.nix { inherit lib; };
    vpn-paths = paths.services.openvpn;

    services = {
        utils = import ./utils/main.nix {inherit lib;};
        identity = import ./identity/main.nix {inherit lib;};
        openvpn = import ./openvpn/main.nix {inherit lib;};
        nginx = import ./nginx/main.nix {inherit lib;};
        dnsmasq = import ./dnsmasq.nix {inherit lib;};
        keycloak = import ./keycloak/main.nix {inherit lib;};
        databases = import ./databases/main.nix {inherit lib;};
    };

in services