{ lib ? import <nixpkgs/lib>, ...}:

let 
  databases = {
    base = import ./base-db.nix { inherit lib; };
    base-backup = import ./base-db-backup.nix { inherit lib; };
  };

in databases