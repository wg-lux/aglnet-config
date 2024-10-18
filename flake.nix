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

	home-manager = {
		url = "github:nix-community/home-manager/release-24.05";
		inputs.nixpkgs.follows = "nixpkgs";
	};

	nix-index-database.url = "github:Mic92/nix-index-database";
	nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

	sops-nix.url = "github:Mic92/sops-nix";
	sops-nix.inputs.nixpkgs.follows = "nixpkgs";

	# nix-ld.url = "github:Mic92/nix-ld";
	# nix-ld.inputs.nixpkgs.follows = "nixpkgs";

	# add for flake usage with nixos stable
	flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";

  };


outputs = { 
	self, nixpkgs, nix-index-database,
	vscode-server, sops-nix, 
	...
}@inputs: #

let
	base-config = {
		system = "x86_64-linux";
		allow-unfree = true;
	};

	system = base-config.system;

	extra-modules = {
		sops-nix = sops-nix;
		# nix-ld = inputs.nix-ld;
	};

	os-base-args = {
		nixpkgs = nixpkgs;
		base-config = base-config;
		inputs = inputs;
		extra-modules = extra-modules;
        hostnames = import ./config/hostnames.nix;
	};

	os-configurations = import ./os-configs/main.nix (
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
