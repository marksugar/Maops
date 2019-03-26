#!/bin/bash
npt=/usr/local/
npp=/data/mysql
itt=/etc/init
groupadd -r -g 499 nginx && useradd -u 499 -s /sbin/nologin -c 'web server' -g nginx nginx -M
curl -s http://nginx.org/download/nginx-1.10.2.tar.gz -o${npt}nginx-1.10.2.tar.gz
cd $npt && tar xf nginx-1.10.2.tar.gz && rm -rf nginx-1.10.2.tar.gz
yum install openssl-devel pcre pcre-devel gcc make -y
cd nginx-1.10.2 && ./configure --prefix=/usr/local/nginx --conf-path=/etc/nginx/nginx.conf --user=nginx --group=nginx --error-log-path=/data/logs/nginx/error.log --http-log-path=/data/logs/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/lock/nginx.lock --with-http_ssl_module --with-http_stub_status_module --with-http_gzip_static_module --with-http_flv_module --with-http_mp4_module --with-http_realip_module --http-client-body-temp-path=/var/tmp/nginx/client --http-proxy-temp-path=/var/tmp/nginx/proxy --http-fastcgi-temp-path=/var/tmp/nginx/fastcgi --http-uwsgi-temp-path=/var/tmp/nginx/uwsgi 
make && make install &&  mkdir -p /var/tmp/nginx/{client,fastcgi,proxy,uwsgi} /data/logs/nginx /data/wwwroot && rm -rf /etc/nginx/nginx.conf
curl -Lks4 https://raw.githubusercontent.com/LinuxEA-Mark/nmp/master/nginx.conf -o /etc/nginx/nginx.cnf
curl -Lks4 https://raw.githubusercontent.com/LinuxEA-Mark/nmp/master/nginx -o $itt/nginx && chmod +x $itt/nginx
