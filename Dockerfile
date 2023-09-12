# Imagen padre
FROM kalilinux/kali-rolling


# Variables de entoro
ENV DISPLAY :0
ENV PORTS 5555


# Paquetes necesarios
RUN apt update
RUN apt install sudo man tldr zsh nano vim curl wget git -y
RUN apt install xauth -y


# Configuracion de los usuarios
RUN useradd -m -s /bin/zsh user
RUN echo 'user:user' | chpasswd
RUN echo 'root:root' | chpasswd
RUN usermod -aG sudo user


# Instalacion de 'dotfiles'
WORKDIR /home/user/

COPY dotfiles-rijaba1 dotfiles-rijaba1

RUN chmod +x dotfiles-rijaba1/install.sh
RUN chown -R user:user dotfiles-rijaba1
# RUN sudo -u user ./dotfiles-rijaba1/install.sh
RUN apt install kitty -y


# Configuracion del X11
RUN echo 'X11UseLocalhost no' >> /etc/ssh/sshd_config
RUN echo 'AddressFamily inet' >> /etc/ssh/sshd_config


# Exponer los puertos
EXPOSE ${PORTS}


# Dependencias de errores de 'kitty'
RUN apt install fontconfig-config fonts-guru-extra libfontconfig-dev -y
RUN export PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig
RUN apt install mesa-utils -y


# Servicio necesario
USER user
CMD ["kitty"]
