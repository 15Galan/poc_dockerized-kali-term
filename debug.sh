#!/bin/bash


clear

# Reiniciar el proyecto
docker stop dotkali
docker rm dotkali
docker rmi kali-dotfiles

# Construir la imagen
docker build . -t kali-dotfiles

# Crear un contenedor
docker run \
	-itd \
        --name dotkali \
        -p 5555:5555 \
        -h ${HOSTNAME}-kali \
        -e DISPLAY \
        -v /tmp/.X11-unix/:/tmp/.X11-unix/ \
        kali-dotfiles

docker ps

ssh-keygen -f "$HOME/.ssh/known_hosts" -R "[localhost]:2222"

ssh user@localhost -p 2222

