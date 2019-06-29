#!/bin/bash
install_redis_cli(){
  git clone http://github.com/antirez/redis.git && mv redis /usr/local/
  cd /usr/local/redis && git checkout 3.0 
  make redis-cli
  ln -s /usr/local/redis/src/redis-cli /bin/redis-cli 
}
if type redis-cli > /dev/null 2>&1; then
    echo "redis-cli exists"
    exit 1;
else
    if type git >/dev/null 2>&1; then
      install_redis_cli
    else
      echo 'no exists git'
      echo "git packets not fount"
    fi
fi
