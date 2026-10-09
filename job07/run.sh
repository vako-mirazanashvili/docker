#!/bin/bash
if [ ! -f .env ]; then
  cp .env.example .env
  echo "Created .env. Edit it (password and VM IP), then run ./run.sh again."
  exit 1
fi
docker compose down
docker compose up -d
sleep 3
# the default index.html belongs to root, so FTP could not overwrite it
. ./.env
docker exec ftp chown -R "$FTP_USER:$FTP_USER" /usr/share/nginx/html
docker compose ps
echo "Now upload index.html with FileZilla (port 21), then open http://VM_IP:8080"
