{config, pkgs, lib, network-config, ...}:

let 
  conf = network-config.services.databases.base-api;

  conf-dir = conf.paths.conf-dir;

  REPO_URL = conf.repo-url;
  ROOT_DIR = conf.paths.parent;
  REPO_ROOT = conf.paths.repo-dir;

  SYSTEM_USER = conf.user;
  SYSTEM_GROUP = conf.group;

  DB_USER = conf.db-user;
  DB_HOST = conf.db-ip;
  DB_PORT = conf.db-port;
  DB_NAME = conf.db-name;
  
  DB_USER_FILE = conf.paths.db-user;
  DB_HOST_FILE = conf.paths.db-host;
  DB_PORT_FILE = conf.paths.db-port;
  DB_NAME_FILE = conf.paths.db-name;

  DB_PWD_FILE = conf.paths.db-pwd;


  service-script = pkgs.writeShellScriptBin "launch-endoreg-db-api" ''
    #!/bin/sh
    # Check if ROOT_DIR exists, if not create it
    if [ ! -d "${ROOT_DIR}" ]; then
      mkdir -p ${ROOT_DIR}
    fi

    # Check if the REPO_ROOT directory exists, if not create it by cloning the repo to the ROOT_DIR
    if [ ! -d "${REPO_ROOT}" ]; then
      git clone ${REPO_URL} ${REPO_ROOT}
      ${pkgs.direnv}/bin/direnv allow ${REPO_ROOT}
    fi

    # Write DB_USER, DB_HOST, DB_PORT, DB_NAME to files; override if they exist
    echo "${DB_USER}" > ${DB_USER_FILE}
    echo "${DB_HOST}" > ${DB_HOST_FILE}
    echo "${toString DB_PORT}" > ${DB_PORT_FILE}
    echo "${DB_NAME}" > ${DB_NAME_FILE}
  
    # Change to the REPO_ROOT directory
    cd ${REPO_ROOT}
    git pull

    echo "Current working directory: $(pwd)"

    export CONF_DIR=${conf-dir}
    devenv shell
    devenv up
    # devenv tasks run dev:runserver

    # keep the script running
    # while true; do
    #   sleep 10
    # done
  '';

in {
  # make sure conf directory exists using tmpfile rules
  systemd.tmpfiles.settings = {
    "endoreg-db-api-conf-dir" = {
      "${conf-dir}" = { 
          d = {
            mode = "0750";
            user = conf.user;
            group = conf.group;
          };
      };
    };
  };

  # deploy secrets
  sops.secrets."endoreg-db-api/db/password" = {
    sopsFile = conf.secrets-file;
    path = conf.paths.db-pwd;
    owner = conf.user;
    # owner = "root";
    mode = "0440";
  };

  systemd.services.endoreg-db-api = {
    description = "Run endoreg-db-api in REPO_ROOT directory";
    path = [
      pkgs.sudo pkgs.util-linux pkgs.coreutils pkgs.gnugrep pkgs.jq
      pkgs.devenv pkgs.git pkgs.direnv pkgs.zsh
    ];

    serviceConfig = {
      ExecStart = "${pkgs.zsh}/bin/zsh ${service-script}/bin/launch-endoreg-db-api";
      User = SYSTEM_USER;
      Group = SYSTEM_GROUP;
      Restart = "on-failure";
    };

    wantedBy = [ "multi-user.target" ];
  };
} 