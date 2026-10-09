#!/bin/bash
# usage: ROOT_PASSWORD=yourpassword ./run.sh
if [ -z "$ROOT_PASSWORD" ]; then
  echo "Set ROOT_PASSWORD first: ROOT_PASSWORD=... ./run.sh"
  exit 1
fi
docker build --build-arg ROOT_PASSWORD="$ROOT_PASSWORD" -t myssh .
docker rm -f ssh1 2>/dev/null
docker run -d -p 2222:22 --name ssh1 myssh
docker ps --filter name=ssh1
echo "Connect with: ssh root@localhost -p 2222"
