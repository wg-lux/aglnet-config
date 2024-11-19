{ pkgs, lib, config, ... }:

let
  hostname = config.networking.hostName;

  ROOT_DIR = "/home/setup-user/dev";
  REPO_ROOT = ROOT_DIR + "/devenv-deployment-example";
  REPO_URL = "https://github.com/wg-lux/devenv-deployment-example";

  DB_PWD_FILE_SOURCE = "/run/secrets/db-pwd";
  DB_PWD_FILE_DEST = "${REPO_ROOT}/data/db-pwd";

  devenvScriptPath = pkgs.writeShellScriptBin "devenv-deploy-script" ''
    #!/usr/bin/env zsh
    
    # Define an environment variable whether the repo is fresh or not
    FRESH_REPO=false

    # Check if the REPO_ROOT directory exists, if not create it by cloning the repo to the ROOT_DIR
    if [ ! -d "${REPO_ROOT}" ]; then
      mkdir -p ${ROOT_DIR}
      git clone ${REPO_URL} ${REPO_ROOT}
      # ${pkgs.direnv}/bin/direnv allow ${REPO_ROOT}
      FRESH_REPO=true
    fi

    # Change to the REPO_ROOT directory
    cd ${REPO_ROOT}
    git pull

    # running db migration
    if [ $FRESH_REPO = true ]; then
      echo "Running db migration"
      devenv tasks run deploy:make-migrations
      devenv tasks run deploy:migrate
      devenv tasks run deploy:load-base-db-data
    fi

    # Print the current working directory
    echo "Current working directory: $(pwd)"

    # Run devenv up
    echo "activating virtual environment"
    . .devenv/state/venv/bin/activate
    echo "running server"
    devenv tasks run prod:runserver
  '';

in
{
  # Systemd service configuration
  systemd.services.devenv-deploy = {
    description = "Run devenv up in REPO_ROOT directory";
    path = [
      pkgs.sudo pkgs.util-linux pkgs.coreutils pkgs.gnugrep pkgs.jq
      pkgs.devenv pkgs.git pkgs.direnv pkgs.zsh
    ];

    serviceConfig = {
      ExecStart = "${pkgs.zsh}/bin/zsh ${devenvScriptPath}/bin/devenv-deploy-script";

      User = "setup-user";
      Group = "service";

      # Restart on failure to ensure service resiliency
      Restart = "on-failure";
      StandardOutput = "journal+console";
      StandardError = "journal+console";
      RestartSec = 5;

      WorkingDirectory = REPO_ROOT;

      # Timeout for startup
      TimeoutStartSec = "30s";
    };
    # Wait for the network to be up before starting the service
    after = [ "network-online.target" ];

    # Install section to specify targets for enabling the service
    wantedBy = [ "multi-user.target" ];
  };
}
