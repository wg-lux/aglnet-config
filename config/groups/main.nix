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
        endoreg-dropoff = {
            name = "endoreg-dropoff";
            gid = 1104;
        };
        endoreg-processing = {
            name = "endoreg-processing";
            gid = 1105;
        };
        endoreg-processed = {
            name = "endoreg-processed";
            gid = 1106;
        };
        openvpn = {
            name = "openvpn";
            gid = 1107;
        };
    };
in groups