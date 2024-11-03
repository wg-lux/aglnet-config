{config, pkgs, ...}:

let

    WIREGUARD = true;

    hostname = config.networking.hostName;
    domain = config.networking.domain;

    custom-packages = [] 
        ++ (if hostname == "agl-gpu-client-02" then [ 
            pkgs.udisks

            ] else [])
        ++ (if hostname == "agl-gpu-client-03" then []
            else [])
        ;

in {
    environment.systemPackages = custom-packages;

    # setup wireguard
    networking.wireguard = {
        enable = WIREGUARD;

        interfaces."lhome" = {
            ips = [ "192.168.2.0/16" ];
            listenPort = 59524;
            privateKeyFile = "/etc/wgLhome";

            peers = [
                {
                    allowedIPs = [
                        # "0.0.0.0/0" # Forward all traffic
                        "192.168.0.0/16"
                    ];
                    publicKey = "SJwbPtcR9bgIBPdDd6EU3B5CTyhQ94HuJSfUf3fVPQk=";
                    presharedKeyFile = "/etc/wgLhomePSK";
                    endpoint = "ma9cemeld4i2cf9j.myfritz.net:59524";
                    persistentKeepalive = 25;

                }
            ];
        };
    };
    
}