let 
    domains = import ./domains.nix;
    urls = {
        keycloak = "https://${domains.keycloak.domain}/";
        endoreg-home = "https://${domains.endoreg-home.domain}/";
    };

in urls