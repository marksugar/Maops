#!/bin/bash
read -p "You install role MASTER/BACKUP ?
         please enter(block letter):" role $role
read -p "Please enter the use VIP: " vvp $vvp

yum install openssl openssl-devel libnl libnl-devel -y
curl -Lk http://www.keepalived.org/software/keepalived-2.0.10.tar.gz|tar xz -C /usr/local/
mkdir /usr/local/keepalived /etc/keepalived -p

cd /usr/local/keepalived-2.0.10 
./configure --prefix=/usr/local/keepalived
make
make install  
cp /usr/local/keepalived-2.0.10/keepalived/etc/init.d/keepalived /etc/init.d/ 
cp /usr/local/keepalived/etc/sysconfig/keepalived  /etc/sysconfig/ 
cp /usr/local/keepalived/sbin/keepalived /usr/sbin/ 

chkconfig keepalived on
systemctl enable keepalived.service

if [ "${role}" == MASTER ];then
   curl -Lk https://raw.githubusercontent.com/marksugar/lvs/master/keepliaved/conf/master -o /etc/keepalived/keepalived.conf
fi
if [ "${role}" == BACKUP ];then
   curl -Lk https://raw.githubusercontent.com/marksugar/lvs/master/keepliaved/conf/backup -o /etc/keepalived/keepalived.conf
fi

sed -i "s/role/${role}/g" /etc/keepalived/keepalived.conf
sed -i "s/172.25.50.15/${vvp}/g" /etc/keepalived/keepalived.conf

#sed -i '/-A INPUT -j REJECT/i\-A INPUT -p 112 -j ACCEPT' /etc/sysconfig/iptables
#systemctl restart iptables
echo -e "\033[044m keeplived role you deploy is:\033[0m"  $role
 
echo -e "\033[044m VIP address is:\033[0m" $vvp


#iptables -I INPUT 5 -p 112 -j ACCEPT
#-A INPUT -p 112 -s 172.25.12.101 -j ACCEPT

systemctl start keepalived.service
ip a
