{ ... }:
let 
    groups = {
        maintenance = {
            name = "maintenance";
            gid = 1100;
        };
        service = {
            name = "service";
            gid = 1101;
        };
        logging = {
            name = "logging";
            gid = 1102;
        };
        center = {
            name = "center";
            gid = 1103;
        };
    };
in groups