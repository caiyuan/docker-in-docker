#!/usr/bin/env sh

docker-compose up -d docker-server

echo 'Wait for the daemon to be ready.'; sleep 15s;

docker-compose up docker-client

docker-compose down -v
