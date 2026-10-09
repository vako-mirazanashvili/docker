#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Run it with sudo: sudo ./remove_docker.sh"
  exit 1
fi

echo "This deletes ALL Docker containers, images, volumes, networks and packages."
read -p "Type YES to continue: " answer
if [ "$answer" != "YES" ]; then
  echo "Cancelled."
  exit 1
fi

docker rm -f $(docker ps -aq) 2>/dev/null
docker system prune -a --volumes -f 2>/dev/null
docker volume rm $(docker volume ls -q) 2>/dev/null

systemctl stop docker docker.socket containerd 2>/dev/null

apt-get purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin \
  docker-compose-plugin docker-ce-rootless-extras docker.io docker-compose || true
apt-get autoremove -y --purge

rm -rf /var/lib/docker /var/lib/containerd /etc/docker
rm -f /etc/apt/sources.list.d/docker.list /etc/apt/keyrings/docker.asc

echo "Docker removed. Check with: docker --version"
