#!/bin/sh
RUN_DIR=`pwd`
cd ../appserver/vehicle
docker-compose down
docker system prune -f
cd $RUN_DIR
