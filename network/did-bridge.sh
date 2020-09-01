#!/usr/bin/env sh

##
docker exec -it docker-dind \
    docker network create \
    --driver=bridge \
    --subnet=192.168.0.0/16 \
    --ip-range=192.168.1.0/24 \
    --gateway=192.168.1.0 \
    local-net

##
docker exec -it docker-dind \
    docker run --name docker-3 -h docker-3 --network local-net --privileged -d caiyuan/docker:19.03.12-dind --registry-mirror https://hub-mirror.c.163.com

docker exec -it docker-dind \
    docker run --name docker-4 -h docker-4 --network local-net --privileged -d caiyuan/docker:19.03.12-dind --registry-mirror https://hub-mirror.c.163.com





##
# docker exec -it docker-dind \
#     docker rm -f docker-3 docker-4
# 
# docker exec -it docker-dind \
#     docker network rm local-net
