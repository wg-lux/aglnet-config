{lib ? import <nixpkgs/lib> , ...}:
let

    # nix eval --expr 'import ./domains.nix { lib = import <nixpkgs/lib>;}'


    hostnames = import ../hostnames.nix {};

    main = "endo-reg.net";
    subdomain-suffix-intern = "intern";
    addInternalDomain = name: value: "${value}-${subdomain-suffix-intern}.${main}";
    clients = lib.mapAttrs addInternalDomain hostnames;

    domains = {
        main = main;
        subdomain-suffix-intern = subdomain-suffix-intern;
        intern = "${subdomain-suffix-intern}.${main}";

        keycloak = "keycloak.${main}";
        keycloak-admin = "keycloak-${subdomain-suffix-intern}.${main}";
        endoreg-home = "home.${main}";
        openvpn = "vpn.${main}";
        clients = clients;

    };

in domains