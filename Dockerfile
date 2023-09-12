# Imagen padre
FROM kalilinux/kali-rolling


# Paquetes necesarios
RUN apt update
RUN apt install sudo man tldr zsh nano vim curl wget openssh-server git -y

# Configuración del SSH
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

# Configuración de 'user'
RUN usermod -aG sudo user

# Instalación de 'dotfiles'
WORKDIR /home/user/
COPY dotfiles-rijaba1 dotfiles-rijaba1
RUN chmod +x dotfiles-rijaba1/install.sh
RUN chown -R user:user dotfiles-rijaba1
RUN sudo -u user ./dotfiles-rijaba1/install.sh

# Habilitar nosequé del X11
RUN sed -i 's/#   ForwardX11 no/    ForwardX11 yes/' /etc/ssh/ssh_config
RUN sed -i 's/#   ForwardX11Trusted yes/    ForwardX11Trusted yes/' /etc/ssh/ssh_config


#Servicio necesario
CMD ["/usr/sbin/sshd", "-D"]
