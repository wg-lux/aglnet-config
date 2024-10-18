{
    os-base-args,
    extra-modules, custom-services,
    ...
}@args:

let 

    hostnames = os-base-args.hostnames;

    os-configs = {
        "${hostnames.gpu-client-02}" = import ./base-client-gpu.nix (
            os-base-args // {
                hostname = hostnames.gpu-client-02;
                extra-modules = extra-modules;
            }
        );
	};

in os-configs