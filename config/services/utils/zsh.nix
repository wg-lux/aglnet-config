{ ... }:
let

    conf = {
        autosuggestions.enable = true;
        syntaxHighlighting.enable = true;
        interactiveShellInit = ''
            eval "$(direnv hook zsh)"
        '';

        ohMyZsh = {
            enable = true;
            theme = "robbyrussell";
            plugins = [
            "git"
            "npm"
            "history"
            "node"
            "rust"
            "deno"
            ];
        };
        
        shellAliases = {
            l = "ls -alh";
            ll = "ls -l";
            ls = "ls --color=tty";
            un = "update-nix";
            cleanup = "nix-collect-garbage -d";
            cleanup-roots = "sudo rm /nix/var/nix/gcroots/auto/*";
            optimize = "nix-store --optimize";
            journalctl-clear = "sudo journalctl --flush --rotate --vacuum-time=1s";
            
            # m-pseudo = "sudo mountPseudo";
            # m-proc = "sudo mountProcessed";
            # m-do = "sudo mountDropOff";
            # um-pseudo = "sudo umountPseudo";
            # um-proc = "sudo umountProcessed";
            # um-do = "sudo umountDropOff";

            # vpn-start = "systemctl start openvpn-aglNet";
            # vpn-stop = "systemctl stop openvpn-aglNet";
            # vpn-restart = "systemctl restart openvpn-aglNet";
            # vpn-status = "systemctl status openvpn-aglNet";
            
            # vpn-log = "cat /etc/custom-logs/openvpn-aglNet-log.csv";
            # vpn-log-errors = "cat /etc/custom-logs/openvpn-aglNet-error.log";
            # vpn-log-run = "log-openvpn";
        };
    };

in conf