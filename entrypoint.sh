#!/bin/bash

PORT=$1
HOST=$2
RELATIVE_ROOT=$3

# docker in docker service
wrapdocker &
sleep 5

# rails server
RAILS_RELATIVE_URL_ROOT=$RELATIVE_ROOT bundle exec rails s -p $PORT -b $HOST

while true
    do sleep 10
done
