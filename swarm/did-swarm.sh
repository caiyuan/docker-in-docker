#!/usr/bin/env sh

##
docker-compose up -d
docker-compose ps

##
echo 'Wait for the daemon to be ready.'; sleep 60s;

##
docker exec -it s1 docker swarm init
manager_token=$(docker exec -it s1 docker swarm join-token -q manager | sed 's/[^a-zA-z0-9-]//g')
worker_token=$(docker exec -it s1 docker swarm join-token -q worker | sed 's/[^a-zA-z0-9-]//g')

##
docker exec -it s2 docker swarm join --token $manager_token s1:2377
docker exec -it s3 docker swarm join --token $manager_token s1:2377
docker exec -it s4 docker swarm join --token $worker_token s1:2377
docker exec -it s5 docker swarm join --token $worker_token s1:2377
docker exec -it s6 docker swarm join --token $worker_token s1:2377

##
docker exec -it s1 docker network ls
docker exec -it s1 docker node ls

##
docker-compose down -v
