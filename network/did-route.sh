#!/usr/bin/env sh

echo
echo '启动同网段内的两台 docker 主机'
echo

docker exec -it docker-dind \
    docker run --name docker-1 -h docker-1 -d --privileged caiyuan/docker:19.03.12-dind

docker exec -it docker-dind \
    docker run --name docker-2 -h docker-2 -d --privileged caiyuan/docker:19.03.12-dind

sleep 15s; 

echo
echo '在 docker-1 上启动 busybox 容器并使用自定义网桥'
echo

docker exec -it docker-dind docker exec -it docker-1 \
    docker network create \
    --driver bridge \
    --subnet=172.28.0.0/16 \
    --ip-range=172.28.0.0/24 \
    --gateway=172.28.0.1 \
    local-net

docker exec -it docker-dind docker exec -it docker-1 \
    docker run --name busybox --network local-net -d caiyuan/busybox:1.32.0 sleep infinite

echo
echo ' 输出两台主机的路由信息: '

echo
echo '  docker-1: '

docker exec -it docker-dind docker exec -it docker-1 \
    ip route

echo
echo '  busybox in docker-1: '

docker exec -it docker-dind docker exec -it docker-1 \
    docker exec -it busybox ip route

echo
echo '  docker-2: (1)'

docker exec -it docker-dind docker exec -it docker-2 \
    ip route

echo
echo '为 docker-2 添加路由并访问 busybox 容器'

docker exec -it docker-dind docker exec -it docker-2 \
    ip route add 172.28.0.0/16 via 172.18.0.2 dev eth0

echo
echo '  docker-2: (2)'

docker exec -it docker-dind docker exec -it docker-2 \
    ip route

echo
docker exec -it docker-dind docker exec -it docker-2 \
    ping 172.28.0.2
