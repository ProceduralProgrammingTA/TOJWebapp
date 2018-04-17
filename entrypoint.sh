#!/bin/bash

PORT=$1
HOST=$2

# Retries a command on failure.
# $1 - the max number of attempts
# $2... - the command to run
retry() {
    local -r -i max_attempts="$1"; shift
    local -r cmd="$@"
    local -i attempt_num=1

    until $cmd
    do
        if (( attempt_num == max_attempts ))
        then
            echo -e "\nAttempt $attempt_num failed and there are no more attempts left!\n"
            return 1
        else
            echo -e "\nAttempt $attempt_num failed! Trying again in $attempt_num seconds...\n"
            sleep $(( attempt_num++ ))
        fi
    done
}

# Abort with showing error message
# $1... - error message
abort() {
    echo "$@" 1>&2; exit 1
}


#### main ####

# start docker in docker service
wrapdocker &


## check differences of tables
retry 10 "bundle exec rake ridgepole:dry-run"  || abort "failed to exec ridgepole:dry-run"
## create tables in database
retry 10 "bundle exec rake ridgepole:apply"  || abort "failed to exec ridgepole:apply"


# run rails server
echo "running rails server ..."
bundle exec rails s -p $PORT -b $HOST
