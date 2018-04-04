# TOJWebApp

Tiny Programming Test Platform for Checking User's Programs


## Features

- Testing user-defined programs
    - create the user-defined assignment (markdown format)
    - upload user programs into database
    - run user programs in docker container (**only for `C`**)
    - automatically check user-defined test cases
    - show test result to user

- Submission of User Report File (only PDF)

- Easy deploy using `docker-compose`


## Requirements
- [docker](https://docs.docker.com/install/)
- [docker-compose](https://docs.docker.com/compose/install/)


## Usage

### 1. Configure Environments Variable

#### Sample of `.env` File
```sh
TOJ_DB_CONTAINER_NAME=toj_mysql
TOJ_DB_PORT=3306
TOJ_DB_ROOT_PASSWORD=root
TOJ_DB_NAME=tojdb
TOJ_DB_FILE_PATH=/opt/TOJWebapp/toj_data
TOJ_FILE_DIR=/opt/TOJWebapp/toj_files
RAILS_FILE_DIR=
RAILS_ENV=production
SECRET_KEY_BASE=0aa2f8696739925c481bfe7b0410f8b6921251234fcec13fedfe6dab86a5c7f6d1dcf2eb79bee1b14fa6c41ef3eaa699a113b91c0bd8b4658525d0e72bddd70a
RAILS_SERVE_STATIC_FILES=0
```

### 2. Deploy Containers
```sh
# run docker containers (if updating container required, add `--build` option)
$ docker-compose up -d
```

TOJWebApp will be launched at `http://localhost:3000` on by default. (PORT specified in `docker-compose.yml`)
> NOTE: You MUST add users into DB using following commands.

### 3. Create Users
```sh
# NOTE: $app_container is the web-application container name of TOJWebApp (e.g. "tojwebapp_app_1")

# Check the differences of tables
docker exec $app_container bundle exec rake ridgepole:dry-run
# Create the tables in DB
docker exec $app_container bundle exec rake ridgepole:apply

# Create User data
# A) using interactive shell to create users one by one
docker exec -it $app_container bundle exec rake generator:interactive

# B) using seed values from .csv file to create users
docker exec -it $app_container bundle exec rake generator:admins
docker exec -it $app_container bundle exec rake generator:students
```

### 4. Undeploy
```sh
# remove all running containers (with keeping volumes)
$ docker-compose down
```