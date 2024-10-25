{ lib, pkgs, ...}@inputs:
let 
    conf = import ./zsh.nix {};
in {

    users.defaultUserShell = pkgs.zsh;

    environment.systemPackages = with pkgs; [
        zsh
        zsh-autosuggestions
        zsh-syntax-highlighting
        zsh-completions
        zsh-history-substring-search
        # zsh-lovers
        # zsh-navigation-tools
        # zsh-pure
    ];

    programs.zsh = {
        enable = true;
    } // inputs.network-config.services.utils.zsh;

}