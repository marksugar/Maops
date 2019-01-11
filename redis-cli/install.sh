git clone http://github.com/antirez/redis.git && mv redis /usr/local/
cd /usr/local/redis && git checkout 3.0 
make redis-cli 
ln -s /usr/local/redis/src/redis-cli /bin/redis-cli 
