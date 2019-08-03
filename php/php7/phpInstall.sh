#!/bin/bash
#########################################################################
# File Name: phpInstall.sh
# Author: mark
# Email: www.linuxea.com
# Version:
# Created Time: Fri 02 Aug 2019 05:52:39 PM CST
#########################################################################

hpUser=$1
version=$2
phpath=/opt
installPath=/usr/local/php


if [ "$#" == "0" ];then
echo """Usage: php-fpm [options]
Options:
	\$1 Username
	\$2 php version
Enter \$1 and \$2, respectively, which are the running user and version number of the php to be installed.
"""
exit
else
groupadd -r -g 499 $hpUser
useradd -u 499 -s /sbin/nologin -c 'web server' -g $hpUser $hpUser -M
curl -Lk https://www.php.net/distributions/php-${version}.tar.gz|tar xz -C $phpath


yum install gcc autoconf gcc-c++ -y
yum install libxml2 libxml2-devel openssl openssl-devel bzip2 bzip2-devel libcurl libcurl-devel libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel gmp gmp-devel readline readline-devel libxslt libxslt-devel -y 
yum install systemd-devel -y
yum install openjpeg-devel -y
yum install -y  curl-devel 
yum install libzip-devel -y

cd $phpath
wget https://raw.githubusercontent.com/marksugar/Maops/master/php/php7/libzip-1.2.0.tar.gz
tar -zxvf libzip-1.2.0.tar.gz
cd libzip-1.2.0
./configure
make && make install

yum install systemd-devel -y

echo '/usr/local/lib64
/usr/local/lib
/usr/lib
/usr/lib64'>>/etc/ld.so.conf
ldconfig -v


cp /usr/local/lib/libzip/include/zipconf.h /usr/local/include/zipconf.h

cd $phpath/php-7.3.8
./configure \
--prefix=${installPath} \
--with-config-file-path=${installPath}/etc \
--with-zlib-dir \
--with-freetype-dir \
--enable-mbstring \
--with-libxml-dir=/usr \
--enable-xmlreader \
--enable-xmlwriter \
--enable-soap \
--enable-calendar \
--with-curl \
--with-zlib \
--with-gd \
--with-pdo-sqlite \
--with-pdo-mysql \
--with-mysqli \
--with-mysql-sock \
--enable-mysqlnd \
--disable-rpath \
--enable-inline-optimization \
--with-bz2 \
--with-zlib \
--enable-sockets \
--enable-sysvsem \
--enable-sysvshm \
--enable-pcntl \
--enable-mbregex \
--enable-exif \
--enable-bcmath \
--with-mhash \
--enable-zip \
--with-pcre-regex \
--with-jpeg-dir=/usr \
--with-png-dir=/usr \
--with-openssl \
--enable-ftp \
--with-kerberos \
--with-gettext \
--with-xmlrpc \
--with-xsl \
--enable-fpm \
--with-fpm-user=${hpUser} \
--with-fpm-group=${hpUser} \
--with-fpm-systemd \
--disable-fileinfo && make && make install 

if [ `echo $?` == '0' ];then 

cp php.ini-production ${installPath}/lib/php.ini
cp ${installPath}/etc/php-fpm.conf.default ${installPath}/etc/php-fpm.conf
ln -s /usr/local/php/sbin/php-fpm /usr/local/bin

cat > ${installPath}/etc/php-fpm.d/www.conf  << EOF
[www]
listen = 127.0.0.1:9000
listen.mode = 0666
User = ${hpUser}
Group = ${hpUser}
pm = dynamic
pm.max_children = 128
pm.start_servers = 20
pm.min_spare_servers = 5
pm.max_spare_servers = 35
pm.max_requests = 10000
rlimit_files = 1024
slowlog = log/\$pool.log.slow
EOF
ln -s /usr/local/php/sbin/php-fpm /usr/local/sbin/
ln -s /usr/local/php/bin/php /usr/local/sbin/
cp ${phpath}/php-${version}/sapi/fpm/php-fpm.service /usr/lib/systemd/system/
systemctl start php-fpm
systemctl status php-fpm

else 
	exit;
fi
fi
