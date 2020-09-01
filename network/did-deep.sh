#!/usr/bin/env sh

##
    docker run --name docker-dind -h docker-dind -d --privileged caiyuan/docker:19.03.12-dind --registry-mirror https://hub-mirror.c.163.com

##
sleep 15s; docker exec -it docker-dind \
    docker run --name docker-1 -h docker-1 -d --privileged caiyuan/docker:19.03.12-dind

sleep 15s; docker exec -it docker-dind \
    docker run --name docker-2 -h docker-2 -d --privileged caiyuan/docker:19.03.12-dind

##
sleep 15s; docker exec -it docker-dind docker exec -it docker-2 \
    docker network create --driver bridge local-net

sleep  5s; docker exec -it docker-dind docker exec -it docker-2 \
    docker run --name busybox --network local-net -d caiyuan/busybox:1.32.0 sleep infinite

##
sleep 15s; docker exec -it docker-dind docker exec -it docker-1 \
    ip route add 172.19.0.0/16 via 172.18.0.3 dev eth0

sleep  5s; docker exec -it docker-dind docker exec -it docker-1 \
    ping 172.19.0.2
