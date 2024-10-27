{   

    config, pkgs, lib, # by default, these are passed to the function from nixosSystem function
    inputs, system, hostname, extra-packages,
    network-config, is-endoreg-client ? false,
  ... 
}:

let 
    ip = network-config.ips.hostnames.${hostname};
    custom-hardware = import ../config/hardware/${hostname}.nix;
    usb-key-config-path = builtins.toPath ../config/hardware/${hostname}-usb-key.nix;

    

in {
    system.stateVersion = custom-hardware.system-state;
    users.mutableUsers = false;

    networking.hostName = hostname;

    services.openssh.enable = true;
    services.autorandr.enable = true; # Manages sleep and hot plugging monitors
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
        ./customization.nix # File is in gitignore, so its safe to test stuff here without accidental commits

        # Base Configuration
        ./shared/bootloader.nix
        ./shared/networking.nix
        ./shared/polkit.nix
        ./shared/power-settings.nix
        ./shared/locale-settings.nix
        ./shared/printer.nix
        ./shared/audio.nix
        ./shared/xserver.nix
        ( import ./shared/ssh.nix { inherit network-config config pkgs lib; })
        ./shared/users.nix
        ./shared/sops.nix
        ./shared/logging.nix
        ./shared/power-management.nix
        ./shared/zsh.nix

        # load endoreg-client modules if is-endoreg-client is true using nix library
        ( import ./endoreg-client/main.nix {
            inherit config pkgs lib network-config is-endoreg-client;
        })


        # import filesystems, inherit from custom-hardware
        (import ./shared/filesystem.nix { 
            inherit config lib pkgs custom-hardware;
        }) 
        usb-key-config-path

        # AglNet Stuff
        ./shared/dev-tools.nix

        # Utility Scripts Stuff
        ./shared/util-scripts.nix # Includes scripts/utils/base-directories.nix

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
        direnv
        easyrsa
        openvpn

        bc
        gptfdisk
        parted
        util-linux
    ];
}
