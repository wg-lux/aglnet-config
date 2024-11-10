{ lib ? import <nixpkgs/lib>, ...}:

let 
  databases = {
    base = import ./base-db.nix { inherit lib; };
  };

in databases