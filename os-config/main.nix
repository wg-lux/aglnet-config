{
    os-base-args,
    network-config,
    extra-modules,
    ...
}@args:

let 

    hostnames = network-config.hostnames;

    os-configs = {
        "${hostnames.gpu-client-dev}" = import ./dev-client-gpu.nix ( ##TODO Change to base-client after prototyping
            os-base-args // {
                hostname = hostnames.gpu-client-dev;
                extra-modules = extra-modules;
                network-config = network-config;
            }
        );

        #"nixos" = import ./base-client-gpu.nix (
        "${hostnames.server-01}" = import ./base-server.nix (
            os-base-args // {
                hostname = hostnames.server-01;
                extra-modules = extra-modules;
                network-config = network-config;
            }
        );

        "${hostnames.server-02}" = import ./base-server.nix (
            os-base-args // {
                hostname = hostnames.server-02;
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

 	"${hostnames.gpu-client-03}" = import ./dev-client-gpu.nix ( ##TODO Change to base-client after prototyping
            os-base-args // {
                hostname = hostnames.gpu-client-03;
                extra-modules = extra-modules;
                network-config = network-config;
            }
        );
};

in os-configs
