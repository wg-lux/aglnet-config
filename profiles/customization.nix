{config, pkgs, ...}:

let

    WIREGUARD = true;

    hostname = config.networking.hostName;
    domain = config.networking.domain;

    custom-packages = [] 
        ++ (if hostname == "agl-gpu-client-02" then [ 
            pkgs.udisks
            pkgs.vault

            ] else [])
        ++ (if hostname == "agl-gpu-client-03" then []
            else [])
        ;

in {
    environment.systemPackages = custom-packages;


    
}