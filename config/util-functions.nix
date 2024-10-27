{lib ? <nixpkgs/lib>, ...}: 

let 
    util-functions = {
        removeEtcPrefix = path: lib.strings.removePrefix "/etc/" path;
    };

in util-functions