{ lib, ... }:

let 
  # Define ports and services in an organized structure
  services = {
    ssh = {
      port = 9238;
    };

    dnsmasq = {
      port = 53;
    };

    openvpn = {
      udp = 1194;
      tcp = 1194;
    };

    keycloak = {
      http = 9240;  # was 8080
      https = 9241;  # was 8443
    };

    nginx = {
      local = 9249;
      aglnet = 443;
    };

    endoregClientManager = {
      django = 9251;  # was 9100
      redis = 9252;   # was 6379
    };

    monitor = {
      django = 9261;  # was 9243
      redis = 9262;   # was 6382
    };

    anonymizer = {
      django = 9271;  # was 9123
      redis = 9272;   # was 6383
    };

    endoregHome = {  # was agl-home-django
      django = 9281;  # was 9129
      redis = 9282;   # was 6379
    };

    postgresql = {
      base = 5432;
    };
  };


in services