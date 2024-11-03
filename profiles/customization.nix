{config, pkgs, ...}:
{
    environment.systemPackages = with pkgs; [
        udisks
        nixfmt-rfc-style
        # libreoffice # asd
    ];
}