#!/bin/bash
#########################################################################
# File Name: nginxInstall.sh
# Author: mark
# Email: www.linuxea.com
# Version:
# Created Time: Fri 02 Aug 2019 05:52:39 PM CST
##############################change time: Sun Nov 30 14:27:34 IST 2025
# fix: 
# os: AlmaLinux 9.4 
# error: the geoip module requires the geoip library, us GeoIP-1.6.12.tar.gz install 
# error: the geoip2 module requires the maxminddb library, us libmaxminddb-1.12.2.tar.gz install 
# list pages:
# 1.https://github.com/leev/ngx_http_geoip2_module.git
# 2.https://github.com/maxmind/geoip-api-c/releases/download/v1.6.12/GeoIP-1.6.12.tar.gz
# 3.https://github.com/maxmind/libmaxminddb/releases/download/1.12.2/libmaxminddb-1.12.2.tar.gz
#########################################################################
hpUser=$1
version=$2
phpath=/opt
installPath=/usr/local/nginx

if [ "$#" == "0" ];then
echo """Usage: nginx [options]
Options:
	\$1 Username
	\$2 nginx version
Enter \$1 and \$2, respectively, which are the running user and version number of the php to be installed.
"""
exit
else

yum install openssl-devel pcre pcre-devel gcc make tar zlib-devel git  perl cpanminus -y 

curl -Lk https://github.com/maxmind/geoip-api-c/releases/download/v1.6.12/GeoIP-1.6.12.tar.gz | tar xz -C /$phpath
cd $phpath/GeoIP-1.6.12 && ./configure && make &&  make install
sudo ldconfig

curl -Lk https://github.com/maxmind/libmaxminddb/releases/download/1.12.2/libmaxminddb-1.12.2.tar.gz | tar xz -C /$phpath
cd $phpath/libmaxminddb-1.12.2 && ./configure && make &&  make install
sh -c "echo /usr/local/lib  >> /etc/ld.so.conf.d/local.conf"
ldconfig

git clone  https://github.com/leev/ngx_http_geoip2_module.git  $phpath/ngx_http_geoip2_module

groupadd -r -g 499 ${hpUser} && useradd -u 499 -s /sbin/nologin -c 'web server' -g ${hpUser} ${hpUser} -M
curl -Lk http://nginx.org/download/nginx-${version}.tar.gz  |tar xz -C $phpath

cd $phpath/nginx-${version} && ./configure --prefix=${installPath} \
--conf-path=/etc/nginx/nginx.conf \
--user=${hpUser} \
--group=${hpUser} \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--pid-path=/var/run/nginx/nginx.pid \
--lock-path=/var/lock/nginx.lock \
--with-http_ssl_module \
--with-http_stub_status_module \
--with-http_gzip_static_module \
--with-http_geoip_module \
--add-module=$phpath/ngx_http_geoip2_module \
--with-http_ssl_module \
--with-http_flv_module \
--with-file-aio \
--with-stream \
--with-http_mp4_module \
--http-client-body-temp-path=/var/tmp/nginx/client \
--http-proxy-temp-path=/var/tmp/nginx/proxy \
--http-fastcgi-temp-path=/var/tmp/nginx/fastcgi \
--http-uwsgi-temp-path=/var/tmp/nginx/uwsgi &&
make && make install 
[ `echo  $?` == '0' ] || (echo "->>>>>>>>>>>>>>>> error: nginx install error!";exit)

echo "->>>>>>>>>>>>>>>> nginx install is ok!"

mkdir -p /var/tmp/nginx/{client,fastcgi,proxy,uwsgi} /data/logs/nginx /data/wwwroot
[ ! -f /etc/nginx/nginx.conf ] || (echo "->>>>>>>>>>>>>>>> nginx config default backup!";mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak )
curl -Lk4  https://raw.githubusercontent.com/marksugar/Maops/master/nginx/conf/nginx.conf -o /etc/nginx/nginx.conf
curl -Lk4 https://raw.githubusercontent.com/marksugar/Maops/master/nginx/conf/nginx.service -o /lib/systemd/system/nginx.service
echo "hello. how are you doing" > /data/wwwroot/index.html
chmod +x /lib/systemd/system/nginx.service
systemctl daemon-reload
systemctl start nginx.service
systemctl status nginx.service
ln -s /usr/local/nginx/sbin/nginx /usr/local/sbin/nginx
nginx -v
echo "####### you see port 80 "
