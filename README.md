# TOJWebApp

Tiny Programming Test Platform for Checking User's Programs


## Features

- Testing user-defined programs like competitive programming
    - create admin-defined programs and test cases
    - upload user programs into database
    - run user programs in docker container (using `library/gcc:latest`)
    - automatically check admin-defined test cases
    - show test results to user

- Uploading user's report files (only PDF)

- Providing easy deploy using `docker-compose`


## Requirements
- [docker](https://docs.docker.com/install/)
- [docker-compose](https://docs.docker.com/compose/install/)


## Usage

### 1. Configure Environments Variable

Edit `.env.sample` and save as `.env` at the root of this repository.

#### Example of `.env` configuration
```sh
TOJ_DB_CONTAINER_NAME=toj_mysql           # container name of database
TOJ_DB_PORT=3306                          # port of database
TOJ_DB_ROOT_PASSWORD=root                 # password to login database
TOJ_DB_NAME=tojdb                         # database name
TOJ_DB_FILE_PATH=/opt/TOJWebapp/toj_data  # volume path for database
TOJ_FILE_DIR=/opt/TOJWebapp/toj_files     # volume path for web-application
RAILS_ENV=production
SECRET_KEY_BASE=0aa2f8696739925c481bfe7b0410f8b6921251234fcec13fedfe6dab86a5c7f6d1dcf2eb79bee1b14fa6c41ef3eaa699a113b91c0bd8b4658525d0e72bddd70a
RAILS_SERVE_STATIC_FILES=0
```

### 2. Deploy Containers
```sh
# run docker containers (if updating container required, add `--build` option)
docker-compose up -d
```

TOJWebApp will be launched at `http://localhost:80` on by default. (PORT specified in `docker-compose.yml`)

### 3. Create Users
```sh
# NOTE: $app_container is the web-application container name of TOJWebApp (e.g. "tojwebapp_app_1")

# Create User data
## A) using interactive shell to create users one by one (password must be longer than 8 characters)
docker exec -it $app_container bundle exec rake generator:interactive

## B) using seed values from .csv file to create users
docker exec -it $app_container bundle exec rake generator:admins
docker exec -it $app_container bundle exec rake generator:students
```

### 4. Undeploy
```sh
# remove all running containers (with keeping volumes)
docker-compose down
```
