version=${1:-2.40.3}
dnf -y install dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable --now docker

curl -Lk https://github.com/docker/compose/releases/download/v${version}/docker-compose-linux-x86_64 -o /usr/local/sbin/docker-compose
chmod +x /usr/local/sbin/docker-compose

docker-compose  -v
docker -v
