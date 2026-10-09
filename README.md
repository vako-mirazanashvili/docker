[README.md](https://github.com/user-attachments/files/33247683/README.md)
# Projet Docker (La Plateforme_)

Vako Mirazanashvili

Ce dépôt contient les fichiers que j'ai utilisés pour le projet RT - Docker (Jobs 01 à 11).
J'ai tout fait sur une VM Debian (sans bureau) avec Docker installé depuis le dépôt officiel de Docker.
Il n'y a aucun mot de passe ni adresse IP dans les fichiers. Quand il en faut un, le script le demande (voir Job 04 et Job 07).

## Dossiers

| Dossier | Job | Contenu |
|---|---|---|
| `job03` | Dockerfile | `Dockerfile` (Debian qui affiche un message), `run.sh` |
| `job04` | Image SSH | `Dockerfile` (ma propre image de serveur SSH), `run.sh` |
| `job05` | Alias | `aliases.sh` (lignes à ajouter à la fin de `~/.bashrc`) |
| `job06` | Volumes | `volumes.sh` (volume nommé, volume en lecture seule, bind mount) |
| `job07` | nginx + FTP | `docker-compose.yml`, `.env.example`, `index.html`, `run.sh` |
| `job08` | nginx avec un Dockerfile | `Dockerfile`, `index.html`, `run.sh` |
| `job09` | Registry local + interface web | `docker-compose.yml`, `run.sh` |
| `job10` | Scripts d'installation / suppression | `install_docker.sh`, `remove_docker.sh` |
| `job11` | Portainer | `run.sh` |

Le Job 01 (VM et installation de Docker) est fait par `job10/install_docker.sh`. Le Job 02 est `docker run hello-world`.

## Lancer un job

```bash
cd job08
./run.sh
```

Il faut lancer les scripts depuis leur propre dossier. Les scripts sont déjà exécutables (`chmod +x`).

- **Job 04 :** le mot de passe root n'est pas dans le Dockerfile. Il se donne au lancement : `ROOT_PASSWORD=monmotdepasse ./run.sh`, puis `ssh root@localhost -p 2222`.
- **Job 07 :** copier `.env.example` en `.env` et écrire le mot de passe FTP et l'IP de la VM (`ip -4 a`). `run.sh` fait cette copie tout seul la première fois. `.env` est dans `.gitignore`. Après `./run.sh`, envoyer `index.html` avec FileZilla (hôte = IP de la VM, port 21), puis ouvrir `http://IP_VM:8080`.
- **Job 08 avant Job 09 :** le Job 09 envoie l'image `mynginx` construite au Job 08.
- **Job 09 :** la page web du registry est sur `http://IP_VM:8083`.
- **Job 11 :** la page de Portainer est `https://IP_VM:9443`. La première fois, récupérer le token d'installation avec `docker logs portainer`.
- **Job 10 :** `remove_docker.sh` supprime TOUS les conteneurs, images et volumes, et enlève Docker. Il demande de taper `YES`. Après, lancer `sudo ./install_docker.sh`, puis refaire les jobs ci-dessus.

## Ports utilisés

| Port | Job | Utilisation |
|---|---|---|
| 2222 | 04 | SSH vers le conteneur |
| 8080 | 07 | site nginx |
| 21, 21000-21010 | 07 | FTP et FTP passif |
| 8081 | 06 | test du bind mount |
| 8082 | 08 | mon image nginx |
| 5000 | 09 | registry |
| 8083 | 09 | page web du registry |
| 8084 | 09 | conteneur de test depuis mon registry |
| 9443 | 11 | Portainer (https) |

## Images téléchargées ou construites

| Job | Image | Téléchargée ou construite |
|---|---|---|
| 02 | `hello-world` | téléchargée |
| 03 | `myhello` | construite (base `debian:bookworm-slim` téléchargée) |
| 04 | `myssh` | construite (serveur SSH installé avec `apt-get`) |
| 06 | `debian:bookworm-slim`, `nginx` | téléchargées |
| 07 | `nginx`, `delfer/alpine-ftp-server` | téléchargées |
| 08 | `mynginx` | construite (nginx installé avec `apt-get`) |
| 09 | `registry:2`, `joxit/docker-registry-ui` | téléchargées |
| 11 | `portainer/portainer-ce:lts` | téléchargée |

## Remarque sur le Job 07

L'image FTP s'arrêtait toute seule quelques secondes après le démarrage. La ligne `entrypoint` du `docker-compose.yml` lance son script avec `sh -c` et garde le conteneur en vie. Ça marche, mais je ne sais pas pourquoi le démarrage par défaut s'arrête.
Le `index.html` par défaut de nginx appartient à root, donc `run.sh` change le propriétaire avec `chown` pour que le FTP puisse l'écraser.
