#!/bin/bash

COMPOSE="/usr/local/bin/docker-compose --no-ansi"

cd /home/devuser/proxy/
$COMPOSE run certbot renew $@ && $COMPOSE kill -s SIGHUP proxy
