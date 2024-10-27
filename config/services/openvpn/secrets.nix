{lib ? <nixpkgs/lib>, ...}:

let 
    base = import ./base.nix {inherit lib; };
    paths = base.paths;
    user = base.user;
    group = base.group;
    filemode = base.filemode-secret;
    format = "binary";

    filenames = paths.filenames;

    secrets = {
        shared = {
            "ca-cert" = {
                sopsFile = ../../../secrets/shared +"/${filenames.ca}";
                path = paths.shared.ca;
                format = format;
                owner = user;
                mode = filemode;
                group = group;
            };

            "ta-key" = {
                sopsFile = ../../../secrets/shared +"/${filenames.ta}";
                path = paths.shared.ta;
                format = format;
                owner = user;
                mode = filemode;
                group = group;
            };
        };

        server = hostname : {
            "dh-pem" = {
                sopsFile = ../../../secrets/${hostname}/${filenames.dh-pem};
                path = paths.server.dh-pem;
                format = format;
                owner = user;
                mode = filemode;
                group = group;
            };
            "cert" = {
                sopsFile = ../../../secrets/${hostname}/${filenames.cert-server};
                path = paths.server.cert;
                format = format;
                owner = user;
                mode = filemode;
                group = group;
            };
            "key" = {
                sopsFile = ../../../secrets/${hostname}/${filenames.key-server};
                path = paths.server.key;
                format = format;
                owner = user;
                mode = filemode;
                group = group;
            };
        };


        client = hostname: {
            "cert" = {
                sopsFile = ../../../secrets/${hostname}/${filenames.cert-client};
                path = paths.client.cert;
                format = format;
                owner = user;
                mode = filemode;
                group = group;
            };

            "key" = {
                sopsFile = ../../../secrets/${hostname}/${filenames.key-client};
                path = paths.client.key;
                format = format;
                owner = user;
                mode = filemode;
                group = group;
            };
        };
    };

in secrets
