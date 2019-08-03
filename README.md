

- ![#f03c15](https://placehold.it/15/f03c15/000000?text=+) `红色` `echo -e "\033[31m\033[01m[ $1 ]\033[0m"`
- ![#f03c15](https://placehold.it/15/f03c15/000000?text=+) `红色动态` `echo -e "\033[31m\033[01m\033[05m[ $1 ]\033[0m"`
- ![#335BFF](https://placehold.it/15/335BFF/000000?text=+) `蓝色` `echo -e "\033[34m[ $1 ]\033[0m"`
- ![#4CFF33](https://placehold.it/15/4CFF33/000000?text=+) `绿色` `echo -e "\033[32m[ $1 ]\033[0m"`

- ![#c5f015](https://placehold.it/15/c5f015/000000?text=+) `黄色` `echo -e "\033[33m\033[01m[ $1 ]\033[0m"`
- ![#c5f015](https://placehold.it/15/c5f015/000000?text=+) `黄色动态` `echo -e "\033[33m\033[01m\033[05m[ $1 ]\033[0m"`

# version


|#|App| Version         |   scripts    | type          | User ID | port      |date      |
|-|-|----------------|------------- | ------------- | ------- | --------- |--------- |
|1|haproxy|1.9.0           |    shell     | ![haproxy](http://www.haproxy.org/img/HAProxyCommunityEdition_60px.png)       |  haproxy       | 1080      |2018      |
|2|Linux Virtual Server|1.27-7.el7      |    shell     | ![Linux Virtual Server](https://raw.githubusercontent.com/marksugar/Maops/master/image/lvs.png)   | root    | 112       |2018      |
|3|keepalived|2.0.10          |    shell     | ![Keepalived](https://raw.githubusercontent.com/marksugar/Maops/master/image/keepalived.png)   | root    | 112       |2018      |
|4|redis-cli|3.0.0           |    shell     |<img src="https://cdn-images-1.medium.com/max/1200/1*i1d88Q8NNrRv6kjf7Ssw4g.png" width="244" height="68">       | None    | None      |20190111  |
|5|nginx|1.16.0         |    shell     |<img src="http://nginx.org/nginx.png" width="244" height="68">       | None    | None      |20190803  |
|6|php-fpm|7.3.8      |    shell     |<img src="https://www.php.net/images/logos/php-logo.svg" width="244" height="68">       | None    | None      |20190803  |



# 目录

* [lvs-dr](#lvs)
* [haproxy](#haproxy)
* [keepalived](#keepalived)
* [redis-cli](#redis-cli)
* [mariadb-client](#mariadb-cli)
* [nginx](#nginx)
* [php](#php)

# lvs

lvs-dr-deploy

```
bash <(curl -s https://raw.githubusercontent.com/marksugar/lvs/master/dr/lvs-dr-deploy.sh|more)

```

# haproxy

curl -Lk https://raw.githubusercontent.com/marksugar/Maops/master/haproxy/scripts/install.sh|bash

# keepalived


部署：

```
bash <(curl -s  https://raw.githubusercontent.com/marksugar/lvs/master/keepliaved/install.sh|more )
```

而后根据提示,输入角色是MASTER或者BACKUP,以及VIP
```
[root@linuxea ~]# bash <(curl -s  https://raw.githubusercontent.com/marksugar/lvs/master/keepliaved/install.sh|more)
You install role MASTER/BACKUP ?
         please enter(block letter):MASTER
Please enter the use VIP: 172.16.100.1
```

如果有必要，你需要放行iptables
```
sed -i '/-A INPUT -j REJECT/i\-A INPUT -p 112 -j ACCEPT' /etc/sysconfig/iptables
systemctl restart iptables
```
# redis-cli 
```
curl -Lk https://raw.githubusercontent.com/marksugar/Maops/master/redis-cli/install.sh|bash
```
# mariadb-cli
```
curl -Lk https://raw.githubusercontent.com/marksugar/Maops/master/mariadb-client/mariadb-cli.sh |bash
```
# nginx
bash -s nginx用户名 nginx版本号
```
curl -Lk https://raw.githubusercontent.com/marksugar/Maops/master/nginx/nginxInstall.sh|bash -s www 1.16.0
```
# php
bash -s php用户名 php版本号
```
curl -Lk https://raw.githubusercontent.com/marksugar/Maops/master/php/php7/phpInstall.sh |bash -s www 7.3.8
```