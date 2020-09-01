#!/usr/bin/env sh

##
docker exec -it docker-dind \
    docker run --name docker-3 -h docker-3 -d --privileged caiyuan/docker:19.03.12-dind --registry-mirror https://hub-mirror.c.163.com

##
sleep 15s

##
docker exec -it docker-dind docker exec -it docker-3 \
    docker run --name busybox-1 --network none -d caiyuan/busybox:1.32.0 sleep infinite

docker exec -it docker-dind docker exec -it docker-3 \
    docker run --name busybox-2 --network none -d caiyuan/busybox:1.32.0 sleep infinite

docker exec -it docker-dind docker exec -it docker-3 \
    docker run --name busybox-3 --network none -d caiyuan/busybox:1.32.0 sleep infinite

docker exec -it docker-dind docker exec -it docker-3 \
    docker run --name busybox-4 --network none -d caiyuan/busybox:1.32.0 sleep infinite

##
docker exec -it docker-dind docker exec -it docker-3 \
    docker network create net-3-1

docker exec -it docker-dind docker exec -it docker-3 \
    docker network create net-3-2

##
docker exec -it docker-dind docker exec -it docker-3 \
    docker network disconnect none busybox-1

docker exec -it docker-dind docker exec -it docker-3 \
    docker network disconnect none busybox-2

docker exec -it docker-dind docker exec -it docker-3 \
    docker network disconnect none busybox-3

docker exec -it docker-dind docker exec -it docker-3 \
    docker network disconnect none busybox-4

##
docker exec -it docker-dind docker exec -it docker-3 \
    docker network connect net-3-1 busybox-1

docker exec -it docker-dind docker exec -it docker-3 \
    docker network connect net-3-1 busybox-2

docker exec -it docker-dind docker exec -it docker-3 \
    docker network connect net-3-1 busybox-3

docker exec -it docker-dind docker exec -it docker-3 \
    docker network connect net-3-2 busybox-3

docker exec -it docker-dind docker exec -it docker-3 \
    docker network connect net-3-2 busybox-4

docker exec -it docker-dind docker exec -it docker-3 \
    docker network connect bridge busybox-4

##
echo 'docker-3: brctl show'
docker exec -it docker-dind docker exec -it docker-3 \
    brctl show

echo 'docker-3: ip link | grep UP'
docker exec -it docker-dind docker exec -it docker-3 \
    ip link | grep UP

##
docker exec -it docker-dind \
    docker rm -f docker-3
