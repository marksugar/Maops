#!/bin/bash
npt=/usr/local/
npp=/data/mysql
itt=/etc/init
curl -s  http://tw1.php.net/distributions/php-5.6.29.tar.gz -o${npt}php-5.6.29.tar.gz && cd $npt
tar xf php-5.6.29.tar.gz && rm -rf php-5.6.29.tar.gz && cd php-5.6.29
groupadd -g 498 -r php-fpm && useradd -u 498 -g php-fpm -r php-fpm -s /sbin/nologin && yum install epel-release -y && \
yum install -y gcc gcc-c++ automake autoconf libtool make \
       libxml2-devel \
       openssl \
       openssl-devel \
       bzip2 \
       bzip2-devel \
       libpng \
       libpng-devel \
       freetype \
       freetype-devel \
       libcurl-devel \
       libcurl libjpeg \
       libjpeg-devel \
       libpng \
       libpng-devel \
       freetype \
       freetype-devel \
       libmcrypt-devel \
       libmcrypt \
       libtool-ltdl-devel \
       libxslt-devel \
       mhash \
       mhash-devel \
       php-bcmath \ libxslt-devel mhash  mhash-devel
    mkdir /usr/local/freetype -p && cd /usr/local
    curl -Lks https://ncu.dl.sourceforge.net/project/freetype/freetype2/2.6.5/freetype-2.6.5.tar.gz -o ./freetype-2.6.5.tar.gz 
    tar xf freetype-2.6.5.tar.gz && rm -rf freetype-2.6.5.tar.gz && cd freetype-2.6.5 && ./configure --prefix=/usr/local/freetype && make && make install 
    mkdir /usr/local/gettext -p && cd /usr/local 
    curl -Lks http://ftp.gnu.org/pub/gnu/gettext/gettext-0.19.tar.gz -o ./gettext-0.19.tar.gz 
    tar xf gettext-0.19.tar.gz && rm -rf gettext-0.19.tar.gz && cd gettext-0.19 && ./configure --prefix=/usr/local/gettext && make && make install && cd /usr/local 
    curl -sO http://ftp.ntu.edu.tw/php/distributions/php-5.6.29.tar.gz && tar xf php-5.6.29.tar.gz -C /usr/local/ && cd /usr/local/php-5.6.29 
#   && mv /usr/local/php-5.6.29 /usr/local/php && rm -rf php-5.6.29.tar.gz && cd  /usr/local/php-5.6.29 \
    groupadd -g 499 -r nginx 
    useradd -u 499 -g nginx -r nginx -s /sbin/nologin 
     ./configure --prefix=/usr/local/php \
       --disable-pdo \
       --disable-debug \
       --disable-rpath \
       --enable-inline-optimization \
       --enable-sockets \
       --enable-sysvsem \
       --enable-sysvshm \
       --enable-pcntl \
       --enable-mbregex \
       --enable-xml \
       --enable-zip \
       --enable-fpm \
       --enable-bcmath \
       --enable-mbstring \
       --with-pcre-regex \
       --with-mysql \
       --with-mysqli \
       --with-gd \
       --with-jpeg-dir \
       --with-bz2 \
       --with-zlib \
       --with-mhash \
       --with-curl \
       --with-mcrypt \
       --with-jpeg-dir \
       --with-png-dir \
       --with-freetype-dir=/usr/local/freetype \
       --with-gettext=/usr/local/gettext && make && make install && mkdir /data/logs/php-fpm -p
cp /usr/local/php-5.6.29/php.ini-production /usr/local/php/lib/php.ini
sed -i 's/;date.timezone =/date.timezone = Asia\/Shanghai/' /usr/local/php/lib/php.ini
curl -Lks4 https://raw.githubusercontent.com/marksugar/Maops/master/nmp/php-fpm -o $itt/php-fpm && chmod +x $itt/php-fpm
curl -Lks4 https://raw.githubusercontent.com/marksugar/Maops/master/nmp/php-fpm.conf -o /usr/local/php/etc/php-fpm.conf
