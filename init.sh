#!/usr/bin/env sh

echo
echo '移除以前的容器'

docker rm -f docker-dind

##

echo
echo '创建并启动容器'

docker run -d --privileged \
	--name docker-dind \
	-h docker-dind \
	caiyuan/docker:19.03.12-dind

echo
echo '导入镜像到容器: '

echo ' 1. 保存本地的副本'

docker save -o docker-dind.tar caiyuan/docker:19.03.12-dind

echo ' 2. 向容器拷贝副本'

docker cp docker-dind.tar docker-dind:/root/

echo ' 3. 容器中加载副本'

docker exec -it docker-dind docker load -i /root/docker-dind.tar

echo
docker exec -it docker-dind docker images

echo
echo '完成并执行清理'

rm docker-dind.tar ; docker exec -it docker-dind rm /root/docker-dind.tar

echo
