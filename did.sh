#!/usr/bin/env sh

echo
echo '启动守护进程使用自定义桥接网络'
echo

docker network create dind-network

docker run -d --privileged \
	--name docker-dind \
	--network dind-network \
	--network-alias docker \
	-e DOCKER_TLS_CERTDIR=/certs \
	-v dind-certs-ca:/certs/ca \
	-v dind-certs-client:/certs/client \
	caiyuan/docker:19.03.12-dind

echo
echo '等待守护进程就绪 (15s)'

sleep 15s

echo
echo ' 输出客户端和服务端的版本信息: '
echo

docker run -it --rm \
	--network dind-network \
	-e DOCKER_TLS_CERTDIR=/certs \
	-v dind-certs-client:/certs/client:ro \
	caiyuan/docker:19.03.12-zsh version

echo
echo '执行痕迹清理'
echo

docker rm -f docker-dind
docker network rm dind-network
docker volume rm dind-certs-ca
docker volume rm dind-certs-client

echo
