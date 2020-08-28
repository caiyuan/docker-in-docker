#!/usr/bin/env sh

##

docker network create some-network

docker run -d --privileged --name some-docker \
	--network some-network --network-alias docker \
	-e DOCKER_TLS_CERTDIR=/certs \
	-v some-docker-certs-ca:/certs/ca \
	-v some-docker-certs-client:/certs/client \
		caiyuan/docker:19.03.12-dind

echo 'Wait for the daemon to be ready.'; sleep 15s;

docker run -it --rm --network some-network \
	-e DOCKER_TLS_CERTDIR=/certs \
	-v some-docker-certs-client:/certs/client:ro \
		caiyuan/docker:19.03.12-zsh version

##

docker rm -f some-docker
docker network rm some-network
docker volume rm some-docker-certs-ca
docker volume rm some-docker-certs-client
