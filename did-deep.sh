#!/usr/bin/env sh

##
    docker run --name docker-dind -h docker-dind -d --privileged caiyuan/docker:19.03.12-dind --registry-mirror https://hub-mirror.c.163.com

##
sleep 15s; docker exec -it docker-dind \
    docker run --name docker-1 -h docker-1 -d --privileged caiyuan/docker:19.03.12-dind --registry-mirror https://hub-mirror.c.163.com

sleep 15s; docker exec -it docker-dind \
    docker run --name docker-2 -h docker-2 -d --privileged caiyuan/docker:19.03.12-dind --registry-mirror https://hub-mirror.c.163.com

##
sleep 15s; docker exec -it docker-dind docker exec -it docker-2 \
    docker network create --driver bridge nginx-net

sleep  5s; docker exec -it docker-dind docker exec -it docker-2 \
    docker run --name nginx -h nginx --network nginx-net -d nginx

##
sleep 15s; docker exec -it docker-dind docker exec -it docker-1 \
    ip route add 172.19.0.0/16 via 172.18.0.3 dev eth0

sleep  5s; docker exec -it docker-dind docker exec -it docker-1 \
    wget -S -P /root 172.19.0.2:80

##
echo 'docker-dind: brctl show'
docker exec -it docker-dind \
    brctl show

echo 'docker-dind: ip link | grep UP'
docker exec -it docker-dind \
    ip link | grep UP

echo 'docker-1: ip link | grep UP'
docker exec -it docker-dind docker exec -it docker-1 \
    ip link | grep UP

echo 'docker-2: ip link | grep UP'
docker exec -it docker-dind docker exec -it docker-2 \
    ip link | grep UP

##
docker exec -it docker-dind \
    docker rm -f docker-1 docker-2
