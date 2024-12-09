{config, pkgs, ...}:

let

    WIREGUARD = true;

    hostname = config.networking.hostName;
    domain = config.networking.domain;

    custom-packages = [] 
        ++ (if hostname == "agl-gpu-client-06" then [ 
            pkgs.udisks
            pkgs.vault
            pkgs.vlc

            ] else [])
        ++ (if hostname == "agl-gpu-client-03" then []
            else [])

        ++ (if hostname == "agl-gpu-client-05" then [
            pkgs.vlc
        ] else [])
        ;

in {
    environment.systemPackages = custom-packages;
}