{   

    config, pkgs, lib, # by default, these are passed to the function from nixosSystem function
    inputs, system, hostname, extra-packages,
    network-config, is-endoreg-client ? false,
    system-encrypted ? false, ssh-by-default ? false,
    dual-gpu ? false,
  ... 
}:

let 
    ip = network-config.ips.hostnames.${hostname};
    custom-hardware = import ../config/hardware/${hostname}.nix;

    usb-key-config-path = builtins.toPath ../config/hardware/${hostname}-usb-key.nix;

    is-nginx-host = hostname == network-config.services.nginx.hostname;
    is-openvpn-host = hostname == network-config.services.openvpn.hostname;
    is-keycloak-host = hostname == network-config.services.keycloak.hostname;
    is-base-db-host = hostname == network-config.services.databases.base.host;
    is-base-db-backup-host = hostname == network-config.services.databases.base-backup.host;


    nginx-modules = if is-nginx-host then [
        ( import ./shared/nginx.nix { inherit config pkgs lib network-config; }) 
    ] else [];

    keycloak-modules = if is-keycloak-host then [
        ( import ./shared/keycloak.nix { inherit config pkgs lib network-config; }) 
    ] else [];

    openvpn-host-modules = if is-openvpn-host then [
        # ( import ./shared/dnsmasq.nix { inherit config pkgs lib network-config; }) 
    ] else [];

    ssh-modules = if ssh-by-default then [ ( import ./shared/ssh.nix { inherit network-config config pkgs lib; }) ] else [];

    base-db-modules = if is-base-db-host then [
        ( import ./shared/postgresql-base.nix { inherit config pkgs lib network-config; }) 
    ] else [];

    base-db-backup-modules = if is-base-db-backup-host then [
        ( import ./shared/postgresql-base-backup.nix { inherit config pkgs lib network-config; }) 
    ] else [];

    is-base-db-api-host = hostname == "agl-gpu-client-02";
    # is-base-db-api-host = hostname == network-config.services.databases.endoreg-db-api.host;
    endoreg-db-api-modules = if is-base-db-api-host then [
        ( import ./shared/endoreg-base-db-api.nix { inherit config pkgs lib network-config; })
    ] else [];


    extra-service-modules = [] ++ nginx-modules 
        ++ keycloak-modules 
        ++ openvpn-host-modules
        ++ ssh-modules
        ++ base-db-modules
        ++ base-db-backup-modules
        ++ endoreg-db-api-modules
    ;

in {
    

    system.stateVersion = custom-hardware.system-state;
    users.mutableUsers = false;

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
        ./customization.nix # File is in gitignore, so its safe to test stuff here without accidental commits

        # Base Configurations
        ./shared/bootloader.nix
        ./shared/networking.nix
        ./shared/polkit.nix
        ./shared/power-settings.nix
        ./shared/locale-settings.nix
        ./shared/printer.nix
        ./shared/audio.nix
        ./shared/xserver.nix
        ./shared/users.nix
        ./shared/sops.nix
        ./shared/logging.nix
        ./shared/power-management.nix
        ./shared/zsh.nix
        ./shared/nix-ld.nix
        (import ./shared/hosts.nix { inherit config pkgs lib network-config; })

        # load endoreg-client modules if is-endoreg-client is true using nix library
        ( import ./endoreg-client/main.nix {
            inherit config pkgs lib network-config is-endoreg-client;
        })

        # load nvidia modules if dual_gpu is true using nix library
        ( import ./shared/gpu_init.nix {
            inherit config pkgs lib network-config dual-gpu is-endoreg-client;
        })


        # import filesystems, inherit from custom-hardware
        (import ./shared/filesystem.nix { 
            inherit config lib pkgs custom-hardware system-encrypted;
        }) 
        usb-key-config-path

        # ( import ./deployment-test.nix {
        #     inherit config pkgs lib;
        # } )

        # AglNet Stuff
        ./shared/dev-tools.nix
        ( import ./shared/openvpn.nix {
            inherit config pkgs lib network-config;
        })

        # Utility Scripts Stuff
        ./shared/util-scripts.nix # Includes scripts/utils/base-directories.nix

    ] ++ extra-service-modules;

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

        python3Full

        bc
        gptfdisk
        parted
        util-linux
        devenv
        dbeaver-bin
    ];
}
