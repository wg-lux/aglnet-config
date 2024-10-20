{lib, ...}:
let

    # nix eval --expr 'import ./domains.nix { lib = import <nixpkgs/lib>;}'


    hostnames = import ../hostnames.nix;

    main = "endoreg.net";
    subdomain-suffix-intern = "intern";

    addInternalDomain = name: value: "${value}-${subdomain-suffix-intern}.${main}";
    clients = lib.mapAttrs addInternalDomain hostnames;

    domains = {
        main = main;
        subdomain-suffix-intern = subdomain-suffix-intern;
        intern = "${subdomain-suffix-intern}.${main}";

        keycloak = "keycloak.${main}";
        endoreg-home = "home.${main}";
        clients = clients;

    };

in clients