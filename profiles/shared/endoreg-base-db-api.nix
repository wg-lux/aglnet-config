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

  get-repo-script = pkgs.writeShellScriptBin "get-endoreg-db-api-repo" ''
    #!/usr/bin/env zsh

    FRESH_REPO=false

    # Check if ROOT_DIR exists, if not create it
    if [ ! -d "${ROOT_DIR}" ]; then
      mkdir -p ${ROOT_DIR}
    fi

    # Check if the REPO_ROOT/devenv.nix file exists, if not create it by cloning the repo to the ROOT_DIR
    if [ ! -f "${REPO_ROOT}/devenv.nix" ]; then
      git clone ${REPO_URL} ${REPO_ROOT}
      FRESH_REPO=true
    fi

    # if FRESH_REPO is true, we create a file named "fresh_repo" in the REPO_ROOT directory
    if [ $FRESH_REPO = true ]; then
      touch ${REPO_ROOT}/fresh_repo
    fi

  '';

  service-script = pkgs.writeShellScriptBin "launch-endoreg-db-api" ''
    #!/usr/bin/env zsh

    # check if ${REPO_ROOT}/fresh_repo exists, if so set FRESH_REPO to true
    FRESH_REPO=false

    if [ -f "${REPO_ROOT}/fresh_repo" ]; then
      FRESH_REPO=true
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

    if [ $FRESH_REPO = true ]; then
      echo "Running db migration"
      devenv tasks run deploy:make-migrations
      devenv tasks run deploy:migrate
      devenv tasks run deploy:load-base-db-data

      # remove the fresh_repo file
      rm ${REPO_ROOT}/fresh_repo
    fi
    
    echo "activating virtual environment"
    . .devenv/state/venv/bin/activate
    echo "running server"
    export CONF_DIR="${conf-dir}"
    export DJANGO_SETTINGS_MODULE="endoreg_db_api.settings_prod"
    export DJANGO_DEBUG="False"
    devenv tasks deploy:collectstatic
    devenv tasks run prod:runserver
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
    mode = "0440";
  };

  # get repo service
  systemd.services.endoreg-db-api-cloner = {
    description = "Get endoreg-db-api repo in ${REPO_ROOT} directory";
    path = [
      pkgs.sudo pkgs.util-linux pkgs.coreutils pkgs.gnugrep pkgs.jq
      pkgs.devenv pkgs.git pkgs.direnv pkgs.zsh
    ];

    serviceConfig = {
      ExecStart = "${pkgs.zsh}/bin/zsh ${get-repo-script}/bin/get-endoreg-db-api-repo";
      User = SYSTEM_USER;
      Group = SYSTEM_GROUP;
      # Restart on failure to ensure service resiliency
      Restart = "on-failure";
      StandardOutput = "journal+console";
      StandardError = "journal+console";
      RestartSec = 5;

      # Timeout for startup
      TimeoutStartSec = "30s";
    };
    # Requires network-online.target to ensure network is up before cloning
    after = [ "network-online.target" ];
    requires = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
  };

  # api service
  systemd.services.endoreg-db-api = {
    description = "Run endoreg-db-api in ${REPO_ROOT} directory using devenv (ConfDir: ${conf-dir})";
    path = [
      pkgs.sudo pkgs.util-linux pkgs.coreutils pkgs.gnugrep pkgs.jq
      pkgs.devenv pkgs.git pkgs.direnv pkgs.zsh
    ];

    serviceConfig = {
      ExecStart = "${pkgs.zsh}/bin/zsh ${service-script}/bin/launch-endoreg-db-api";
      User = SYSTEM_USER;
      Group = SYSTEM_GROUP;
      # Restart on failure to ensure service resiliency
      Restart = "on-failure";
      StandardOutput = "journal+console";
      StandardError = "journal+console";
      RestartSec = 5;

      WorkingDirectory = REPO_ROOT;

      # Timeout for startup
      TimeoutStartSec = "30s";
    };
    # Ensure that this service runs only after the cloner has completed successfully
    requires = [ "endoreg-db-api-cloner.service" "network-online.target" ];
    after = [ "network-online.target" "endoreg-db-api-cloner.service" ];
    wantedBy = [ "multi-user.target" ];
  };

} 