{config, pkgs, network-config, ...}:

let 
    hosts = network-config.network.hosts;


in {

    networking.hosts = hosts;

}