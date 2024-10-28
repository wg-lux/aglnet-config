{ lib ? <nixpkgs/lib> , ... }:
let
    base = import ./base.nix { inherit lib; }; 

    main = {
        secrets = import ./secrets.nix { inherit lib; };
    } // base;


in main