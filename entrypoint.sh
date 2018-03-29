#!/bin/bash

PORT=$1
HOST=$2

# docker in docker service
wrapdocker &
sleep 5

# rails server
bundle exec rails s -p $PORT -b $HOST

while true
    do sleep 10
done