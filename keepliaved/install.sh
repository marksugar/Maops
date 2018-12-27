#!/bin/bash
yum install openssl openssl-devel -y
curl -Lk http://www.keepalived.org/software/keepalived-2.0.10.tar.gz|tar xz -C /usr/local/
mkdir /usr/local/keepalived /etc/keepalived -p

cd /usr/local/keepalived-2.0.10 && ./configure --prefix=/usr/local/keepalived
make && make install 
cp /usr/local/keepalived-2.0.10/keepalived/etc/init.d/keepalived /etc/init.d/
cp /usr/local/keepalived/etc/sysconfig/keepalived  /etc/sysconfig/
cp /usr/local/keepalived/sbin/keepalived /usr/sbin/

chkconfig keepalived on
systemctl enable keepalived.service
curl -Lk https://raw.githubusercontent.com/marksugar/lvs/master/keepliaved/conf/master -o /etc/keepalived//etc/keepalived/keepalived.conf

#iptables -I INPUT 5 -p 112 -j ACCEPT
#-A INPUT -p 112 -s 172.25.12.101 -j ACCEPT

systemctl start keepalived.service && ip a
