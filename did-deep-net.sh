#!/usr/bin/env sh

##
docker exec -it docker-dind docker exec -it docker-1 \
    docker run --name busybox-1 --network none -d caiyuan/busybox:1.32.0 sleep infinite

docker exec -it docker-dind docker exec -it docker-1 \
    docker run --name busybox-2 --network none -d caiyuan/busybox:1.32.0 sleep infinite

docker exec -it docker-dind docker exec -it docker-1 \
    docker run --name busybox-3 --network none -d caiyuan/busybox:1.32.0 sleep infinite

docker exec -it docker-dind docker exec -it docker-1 \
    docker run --name busybox-4 --network none -d caiyuan/busybox:1.32.0 sleep infinite

##
docker exec -it docker-dind docker exec -it docker-1 \
    docker network create net-1

docker exec -it docker-dind docker exec -it docker-1 \
    docker network create net-2

##
docker exec -it docker-dind docker exec -it docker-1 \
    docker network disconnect none busybox-1

docker exec -it docker-dind docker exec -it docker-1 \
    docker network disconnect none busybox-2

docker exec -it docker-dind docker exec -it docker-1 \
    docker network disconnect none busybox-3

docker exec -it docker-dind docker exec -it docker-1 \
    docker network disconnect none busybox-4

##
docker exec -it docker-dind docker exec -it docker-1 \
    docker network connect net-1 busybox-1

docker exec -it docker-dind docker exec -it docker-1 \
    docker network connect net-1 busybox-2

docker exec -it docker-dind docker exec -it docker-1 \
    docker network connect net-1 busybox-3

docker exec -it docker-dind docker exec -it docker-1 \
    docker network connect net-2 busybox-3

docker exec -it docker-dind docker exec -it docker-1 \
    docker network connect net-2 busybox-4

docker exec -it docker-dind docker exec -it docker-1 \
    docker network connect bridge busybox-4

##
echo 'docker-1: brctl show'
docker exec -it docker-dind docker exec -it docker-1 \
    brctl show

echo 'docker-1: ip link | grep UP'
docker exec -it docker-dind docker exec -it docker-1 \
    ip link | grep UP

##
docker exec -it docker-dind docker exec -it docker-1 \
    docker rm -f busybox-1 busybox-2 busybox-3 busybox-4

docker exec -it docker-dind docker exec -it docker-1 \
    docker system prune -a

