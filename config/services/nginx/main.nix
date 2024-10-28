{ lib ? <nixpkgs/lib> , ... }:
let
    base = import ./base.nix { inherit lib; };

    main-nginx-host = base.hostname;
    secret-root = ../../secrets + "/${main-nginx-host}/nginx";

    main = {
        secrets = import ./secrets.nix { inherit lib; };
    } // base;


in main