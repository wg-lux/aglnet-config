{ lib, ... }:
let 
    domains = import ./domains.nix { inherit lib; };

    urls = {
        keycloak = "https://${domains.keycloak}/";
        endoreg-home = "https://${domains.endoreg-home}/";
    };

in urls