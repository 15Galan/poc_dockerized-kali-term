clear

docker stop dotkali
docker rm dotkali
docker rmi kali-dotfiles

docker build . -t kali-dotfiles
docker run --name dotkali -itd -p 2222:22 kali-dotfiles

docker ps

ssh-keygen -f "$HOME/.ssh/known_hosts" -R "[localhost]:2222"

ssh user@localhost -p 2222

