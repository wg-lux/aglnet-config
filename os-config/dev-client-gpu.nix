{
    nixpkgs,
    pkgs,
    base-config,
    hostname, 
    inputs,
    network-config,
    extra-modules,
    extra-packages,
    ...
}@args:
let 
    IS_ENDOREG_CLIENT = true;
    SYSTEM_ENVRYPTED = true;
    SSH_BY_DEFAULT = true;

    ######### EXPERIMENTAL #########################
    clangVersion = "18";   # Version of Clang
    gccVersion = "13";     # Version of GCC
    llvmPkgs = pkgs."llvmPackages_${clangVersion}";  # LLVM toolchain
    gccPkg = pkgs."gcc${gccVersion}";  # GCC package for compiling

    # Create a clang toolchain with libstdc++ from GCC
    clangStdEnv = pkgs.stdenvAdapters.overrideCC llvmPkgs.stdenv (llvmPkgs.clang.override {
      gccForLibs = gccPkg;  # Link Clang with libstdc++ from GCC
    });

    ################################################

    system = base-config.system;

in nixpkgs.lib.nixosSystem {
    system = system;

    specialArgs = {
        hostname = hostname;
        inherit inputs system; 
        inherit network-config;
        inherit extra-packages;
        is-endoreg-client = IS_ENDOREG_CLIENT;
        system-encrypted = SYSTEM_ENVRYPTED;
        ssh-by-default = SSH_BY_DEFAULT;
    };
    
    modules = [
        ../profiles/main.nix

        {environment.systemPackages = extra-packages;}
    ] ++ extra-modules;

    
}