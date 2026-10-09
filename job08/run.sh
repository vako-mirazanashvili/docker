#!/bin/bash
docker build -t mynginx .
docker rm -f nginx-perso 2>/dev/null
docker run -d -p 8082:80 --name nginx-perso mynginx
sleep 1
curl localhost:8082
