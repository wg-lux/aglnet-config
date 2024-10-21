{   

    config, pkgs, lib, # by default, these are passed to the function from nixosSystem function
    inputs, system, hostname,
    network-config,
  ... 
}:

let 
    ip = network-config.ips.hostnames.${hostname};

    # build paths to hostname specific config files
    # custom-hardware-path = builtins.toPath ../config/hardware/${hostname}-hardware-configuration.nix;
    # custom-hardware-path = builtins.toPath ../config/hardware/${hostname}.nix;

    custom-hardware = import ../config/hardware/${hostname}.nix;
    usb-key-config-path = builtins.toPath ../config/hardware/${hostname}-usb-key.nix;

in {
    system.stateVersion = custom-hardware.system-state;


    networking.hostName = hostname;


    services.openssh.enable = true;
    programs.ssh.startAgent = true;

    nix.settings = {
        trusted-users = [
            "root"
            network-config.users.admin.name
            network-config.users.setup.name #TODO REMOVE AFTER DEV PHASE
        ];
        experimental-features = [ "nix-command" "flakes" ];
        auto-optimise-store = true;
    };

    nixpkgs.config.allowUnfree = true;
    

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
        # Base Configuration
        ./shared/bootloader.nix
        ./shared/networking.nix
        ./shared/polkit.nix
        ./shared/power-settings.nix
        ./shared/locale-settings.nix
        ./shared/printer.nix
        ./shared/audio.nix
        ./shared/xserver.nix
        ./shared/ssh.nix
        ./shared/users.nix
        
        # import filesystems, inherit from custom-hardware
        (import ./shared/filesystem.nix { 
            inherit config lib pkgs custom-hardware;
        }) 
        usb-key-config-path

        # AglNet Stuff
        ./shared/dev-tools.nix
        ./shared/util-scripts.nix

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
        firefox
        chromium
        cachix
        tmux
        tmuxp
        tree
        usbutils
        whois
    ];
}
