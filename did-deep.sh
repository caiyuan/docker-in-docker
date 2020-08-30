#!/usr/bin/env sh

    docker run --name docker-o -h docker-o -d --privileged caiyuan/docker:19.03.12-dind --registry-mirror https://hub-mirror.c.163.com

sleep 15s; docker exec -it docker-o \
    docker run --name docker-i -h docker-i -d --privileged caiyuan/docker:19.03.12-dind --registry-mirror https://hub-mirror.c.163.com

sleep 15s; docker exec -it docker-o docker exec -it docker-i \
    docker run --name nginx -h nginx -d nginx

sleep 5s; docker exec -it docker-o docker exec -it docker-i \
    wget -S -P /root 172.17.0.2:80

    docker rm -f docker-o
