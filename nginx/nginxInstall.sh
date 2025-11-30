#!/bin/bash
#########################################################################
# File Name: nginxInstall.sh
# Author: mark
# Email: www.linuxea.com
# Version:
# Created Time: Fri 02 Aug 2019 05:52:39 PM CST
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

groupadd -r -g 499 ${hpUser} && useradd -u 499 -s /sbin/nologin -c 'web server' -g ${hpUser} ${hpUser} -M
curl -Lk http://nginx.org/download/nginx-${version}.tar.gz  |tar xz -C $phpath
yum install openssl-devel pcre pcre-devel gcc make tar zlib-devel -y
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
--with-http_flv_module \
--with-file-aio \
--with-stream \
--with-http_mp4_module \
--http-client-body-temp-path=/var/tmp/nginx/client \
--http-proxy-temp-path=/var/tmp/nginx/proxy \
--http-fastcgi-temp-path=/var/tmp/nginx/fastcgi \
--http-uwsgi-temp-path=/var/tmp/nginx/uwsgi &&
make && make install 
if [ `echo $?` == '0' ];then 
	mkdir -p /var/tmp/nginx/{client,fastcgi,proxy,uwsgi} /data/logs/nginx /data/wwwroot && mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak \
	&& curl -Lk4  https://raw.githubusercontent.com/marksugar/Maops/master/nginx/conf/nginx.conf -o /etc/nginx/nginx.conf \
	&& curl -Lk4 https://raw.githubusercontent.com/marksugar/Maops/master/nginx/conf/nginx.service -o /lib/systemd/system/nginx.service \
	&& systemctl daemon-reload \
cat > /data/wwwroot/index.php	<<EOF
<?php
phpinfo();
phpinfo(INFO_MODULES);
?>
EOF
systemctl start nginx.service
systemctl status nginx.service
ln -s /usr/local/nginx/sbin/nginx /usr/local/sbin/nginx
if [ `curl 127.0.0.1:80 -s |grep ${version}|wc -l` > 0 ];then nginx -v && echo "##########################配置完成 ##########################";fi
else 
	exit;
fi
fi
