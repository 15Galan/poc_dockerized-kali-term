# Imagen padre
FROM kalilinux/kali-rolling


# Variables de entoro
ENV DISPLAY :0
ENV PORTS 5555


# Paquetes necesarios
RUN apt update
RUN apt install sudo man tldr zsh nano vim curl wget openssh-server git -y
RUN apt install xauth -y


# Configuracion del SSH
RUN mkdir -p /run/sshd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN ssh-keygen -A
RUN echo 'root:root' | chpasswd
RUN useradd -m -s /bin/zsh user
RUN echo 'user:user' | chpasswd
RUN mkdir /home/user/.ssh
RUN touch /home/user/.ssh/authorized_keys
RUN chown -R user:user /home/user/.ssh
RUN chmod 700 /home/user/.ssh
RUN chmod 600 /home/user/.ssh/authorized_keys


# Configuracion de 'user'
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
CMD ["/usr/sbin/sshd", "-D"]
