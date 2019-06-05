PRDIR=/usr/local/haproxy
curl -Lk https://www.haproxy.org/download/1.9/src/haproxy-1.9.0.tar.gz |tar xz -C /usr/local/
cd /usr/local/haproxy-1.9.0 && make TARGET=linux2628 ARCH=x86_64 PREFIX=$PRDIR
make install PREFIX=$PRDIR

cd /usr/local/haproxy-1.9.0/contrib/halog && make
cp halog /usr/local/bin/

mkdir /etc/haproxy/ -p
useradd haproxy -s /sbin/nologin -M
cp /usr/local/haproxy/sbin/haproxy /usr/sbin/
cp /usr/local/haproxy-1.9.0/examples/haproxy.init /etc/init.d/haproxy


chmod +x /etc/init.d/haproxy
chkconfig haproxy on
chkconfig --add haproxy

curl -Lk https://raw.githubusercontent.com/marksugar/Maops/master/haproxy/conf/haproxy.cfg -o /etc/haproxy/haproxy.cfg
systemctl start haproxy
haproxy -v
