{
    os-base-args,
    network-config,
    extra-modules,
    ...
}@args:

let 

    hostnames = network-config.hostnames;

    os-configs = {
        #"nixos" = import ./base-client-gpu.nix (
        "${hostnames.server-01}" = import ./base-server.nix (
            os-base-args // {
                hostname = hostnames.server-01;
                extra-modules = extra-modules;
                network-config = network-config;
            }
        );

        "${hostnames.gpu-client-02}" = import ./dev-client-gpu.nix ( ##TODO Change to base-client after prototyping
            os-base-args // {
                hostname = hostnames.gpu-client-02;
                extra-modules = extra-modules;
                network-config = network-config;
            }
        );
	};

in os-configs