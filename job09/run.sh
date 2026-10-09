#!/bin/bash
# needs the image mynginx from job08
docker compose up -d
sleep 3
docker tag mynginx localhost:5000/mynginx:v1
docker push localhost:5000/mynginx:v1
curl localhost:5000/v2/_catalog
curl localhost:5000/v2/mynginx/tags/list

# pull test: delete the local copies first, then pull from my registry
docker rm -f nginx-perso from-registry 2>/dev/null
docker rmi localhost:5000/mynginx:v1 mynginx
docker pull localhost:5000/mynginx:v1
docker run -d -p 8084:80 --name from-registry localhost:5000/mynginx:v1
sleep 1
curl localhost:8084
docker rm -f from-registry
echo "Registry web page: http://VM_IP:8083"
