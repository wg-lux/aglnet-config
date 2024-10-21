{
  description = "AGL Nix Config";

nixConfig = {
    substituters = [
        "https://cache.nixos.org"
        "https://cuda-maintainers.cachix.org"
    ];
    trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
};


inputs = {
	nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

	nix-index-database.url = "github:Mic92/nix-index-database";
	nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

	sops-nix.url = "github:Mic92/sops-nix";
	sops-nix.inputs.nixpkgs.follows = "nixpkgs";


	envfs.url = "github:Mic92/envfs";
  	envfs.inputs.nixpkgs.follows = "nixpkgs";


	endoreg-usb-encrypter.url = "github:wg-lux/endoreg-usb-encrypter";
	endoreg-usb-encrypter.inputs.nixpkgs.follows = "nixpkgs";


	# nix-ld.url = "github:Mic92/nix-ld";
	# nix-ld.inputs.nixpkgs.follows = "nixpkgs";

	# add for flake usage with nixos stable
	flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";

  };


outputs = { 
	self, nixpkgs, 
	envfs,
	nix-index-database, sops-nix, 
	...
}@inputs: #

let
	base-config = {
		system = "x86_64-linux";
		allow-unfree = true;
		cuda-support = true;
	};

	system = base-config.system;

	pkgs = import nixpkgs {
		system = system;
		config = {
			allowUnfree = base-config.allow-unfree;
			cudaSupport = base-config.cuda-support;
		};
	};

	extra-modules = [
		sops-nix.nixosModules.sops
		envfs.nixosModules.envfs
		# nix-ld = inputs.nix-ld;

	];

	extra-packages = [
		inputs.endoreg-usb-encrypter.packages.x86_64-linux.default
	];

	os-base-args = {
		nixpkgs = nixpkgs;
		pkgs = pkgs;
		base-config = base-config;
		inputs = inputs;
		extra-modules = extra-modules;
		extra-packages = extra-packages;
        hostnames = import ./config/hostnames.nix {};
	};

	network-config = import ./config/main.nix (
		{
			lib = pkgs.lib;
		}
	);

	os-configurations = import ./os-config/main.nix (
		{
			os-base-args = os-base-args;
			network-config = network-config;
			extra-modules = extra-modules;
		}
	);
	
in {
		nixosConfigurations = os-configurations;
	};
}
