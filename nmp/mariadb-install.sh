#!/bin/bash
npt=/usr/local/
npp=/data/mysql
itt=/etc/init
cd $npt && axel -n 30 http://sgp1.mirrors.digitalocean.com/mariadb//mariadb-10.1.19/bintar-linux-x86_64/mariadb-10.1.19-linux-x86_64.tar.gz
tar xf mariadb-10.1.19-linux-x86_64.tar.gz && ln -s mariadb-10.1.19-linux-x86_64 mysql
groupadd -g 497 -r mysql && useradd -u 497 -g mysql -r mysql -s /sbin/nologin && mkdir $npp
cd mysql && scripts/mysql_install_db --user=mysql --datadir=/data/mysql 
chown -r mysql.mysql $npp && cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld && chown +x /etc/init.d/mysqld
#cp /usr/local/mysql/support-files/my-large.cnf /etc/my.cnf 
curl -Lks4 https://raw.githubusercontent.com/LinuxEA-Mark/nmp/master/my.cnf -o /etc/my.cnf
ln -s /usr/local/mysql/bin/mysql /usr/bin/
systemcrt start mysqld && systemct start nginx  && systemctl start php-fpm
