cat > /etc/yum.repos.d/MariaDB.repo << EOF
[mariadb]
name = MariaDB
baseurl = https://mirrors.xtom.com/mariadb/yum/10.6/centos8-amd64 
gpgkey = https://mirrors.xtom.com/mariadb/yum/RPM-GPG-KEY-MariaDB
gpgcheck=1 
EOF
yum install  MariaDB-client -y
