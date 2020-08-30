#!/usr/bin/env sh

    docker run --name docker-dind -h docker-dind -d --privileged caiyuan/docker:19.03.12-dind --registry-mirror https://hub-mirror.c.163.com

sleep 10s; docker exec -it docker-dind \
    docker run --name docker-1 -h docker-1 -d --privileged caiyuan/docker:19.03.12-dind --registry-mirror https://hub-mirror.c.163.com

sleep 10s; docker exec -it docker-dind \
    docker run --name docker-2 -h docker-2 -d --privileged caiyuan/docker:19.03.12-dind --registry-mirror https://hub-mirror.c.163.com

sleep 10s; docker exec -it docker-dind docker exec -it docker-2 \
    docker run --name nginx -h nginx -d nginx

sleep 5s; docker exec -it docker-dind docker exec -it docker-2 \
    wget -S -P /root 172.17.0.2:80

    docker rm -f docker-dind
