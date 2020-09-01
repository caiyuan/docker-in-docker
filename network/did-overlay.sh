#!/usr/bin/env sh

##
docker exec -it docker-dind \
    docker network create \
    --driver=bridge \
    --subnet=172.27.0.0/16 \
    --ip-range=172.27.0.0/24 \
    --gateway=172.27.0.1 \
    net-5

docker exec -it docker-dind \
    docker network create \
    --driver=bridge \
    --subnet=172.28.0.0/16 \
    --ip-range=172.28.0.0/24 \
    --gateway=172.28.0.1 \
    net-6

##
docker exec -it docker-dind \
    docker run --name docker-5 -h docker-5 --network net-5 --privileged -d caiyuan/docker:19.03.12-dind --registry-mirror https://hub-mirror.c.163.com

docker exec -it docker-dind \
    docker run --name docker-6 -h docker-6 --network net-6 --privileged -d caiyuan/docker:19.03.12-dind --registry-mirror https://hub-mirror.c.163.com

##




##
# docker exec -it docker-dind \
#     docker rm -f docker-5 docker-6
# 
# docker exec -it docker-dind \
#     docker network rm net-5 net-6
