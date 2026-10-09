#!/bin/bash
# Job 06: named volume shared by two containers, read-only volume, bind mount

echo "--- create the volume"
docker volume create shared
docker volume ls

echo "--- two containers share the volume"
docker run -d --name vako1 -v shared:/data debian:bookworm-slim sleep 3600
docker run -d --name vako2 -v shared:/data debian:bookworm-slim sleep 3600
docker exec vako1 sh -c 'echo "hello from vako1" > /data/test.txt'
docker exec vako2 cat /data/test.txt

echo "--- delete the containers, the data stays in the volume"
docker rm -f vako1 vako2
docker run --rm -v shared:/data debian:bookworm-slim cat /data/test.txt

echo "--- read-only volume (this write must fail)"
docker run --rm -v shared:/data:ro debian:bookworm-slim sh -c 'echo test > /data/new.txt'

echo "--- bind mount: a VM folder shared with nginx"
mkdir -p ~/site
echo "<h1>Test</h1>" > ~/site/index.html
docker run -d --name nginx-test -p 8081:80 -v ~/site:/usr/share/nginx/html nginx
sleep 2
curl localhost:8081

echo "--- clean up"
docker rm -f nginx-test
docker volume rm shared
