{
    os-base-args,
    network-config,
    extra-modules,
    ...
}@args:

let 

    hostnames = os-base-args.hostnames;

    os-configs = {
        #"nixos" = import ./base-client-gpu.nix (
        "${hostnames.gpu-client-02}" = import ./base-client-gpu.nix (
            os-base-args // {
                hostname = hostnames.gpu-client-02;
                extra-modules = extra-modules;
                network-config = network-config;
            }
        );
	};

in os-configs