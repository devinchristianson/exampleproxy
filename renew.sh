#!/bin/bash

COMPOSE="/usr/local/bin/docker-compose --no-ansi"
$COMPOSE run certbot renew $@ && $COMPOSE kill -s SIGHUP proxy
