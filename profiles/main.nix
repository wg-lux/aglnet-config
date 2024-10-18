{   

    config, pkgs, lib, # by default, these are passed to the function from nixosSystem function
    inputs, system, 
    network-config, 
  ... 
}@args:

let 
    hostname = config.networking.hostName;
    ip = network-config.ips.hostnames.${hostname};

    # build paths to hostname specific config files
    custom-hardware-path = builtins.toPath ../config/hardware/${hostname}-hardware-configuration.nix;
    
in {

    nix.settings = {
        trusted-users = [
            "root"
            network-config.users.admin-user
            experimental-features = [ "nix-command" "flakes" ];
            auto-optimise-store = true;
        ];
    };

    programs.git = {
        enable = true;
    };

    security.pam.loginLimits = [{
        domain = "*";
        type = "soft";
        item = "nofile";
        value = "8192";
    }];

    imports = [
        ./shared/bootloader.nix
        ./shared/networking.nix
        ./shared/polkit.nix
        ./shared/power-settings.nix
        ./shared/locale-settings.nix
        ./shared/printer.nix
        ./shared/audio.nix
        # (import ./xserver.nix {inherit pkgs; } )
        ./shared/users.nix
        ./shared/xserver.nix
    ];

    environment.systemPackages = with pkgs; [ 
        vim
        wget
        pciutils
        sops
        age
        vscode
        ethtool
        screen
        cryptsetup
        nfs-utils
        brightnessctl
        tldr
        powertop
        unixtools.quota
        chromium
        cachix
        tmux
        tmuxp
        tree
    ];
}
