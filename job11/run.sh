#!/bin/bash
docker volume create portainer_data
docker rm -f portainer 2>/dev/null
docker run -d \
  -p 8000:8000 -p 9443:9443 \
  --name portainer --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:lts
docker ps --filter name=portainer
echo "Open https://VM_IP:9443 (first time: get the setup token with: docker logs portainer)"
