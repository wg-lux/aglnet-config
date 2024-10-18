{
    nixpkgs, pkgs,
    base-config,
    hostname, 
    inputs,
    network-config,
    extra-modules,
    ...
}@args:
let 
    nixpkgs = args.os-base-args.nixpkgs;

    pkgs = import nixpkgs {
		system = system;
		config = {
			allowUnfree = base-config.allow-unfree;
			cudaSupport = true;
		};
	};

    ######### EXPERIMENTAL #########################
    clangVersion = "16";   # Version of Clang
    gccVersion = "13";     # Version of GCC
    llvmPkgs = pkgs."llvmPackages_${clangVersion}";  # LLVM toolchain
    gccPkg = pkgs."gcc${gccVersion}";  # GCC package for compiling

    # Create a clang toolchain with libstdc++ from GCC
    clangStdEnv = pkgs.stdenvAdapters.overrideCC llvmPkgs.stdenv (llvmPkgs.clang.override {
      gccForLibs = gccPkg;  # Link Clang with libstdc++ from GCC
    });

    ################################################

    system = base-config.system;

    sops-nix = extra-modules.sops-nix;
    custom-packages = args.custom-packages;

in nixpkgs.lib.nixosSystem {
    system = system;

    specialArgs = {
        hostname = hostname;
        inherit inputs system; 
        inherit network-config;
        
    };
    
    modules = [
        ../profiles/main.nix
        sops-nix.nixosModules.sops
        
    ];
}