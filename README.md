

- ![#f03c15](https://placehold.it/15/f03c15/000000?text=+) `红色` `echo -e "\033[31m\033[01m[ $1 ]\033[0m"`
- ![#f03c15](https://placehold.it/15/f03c15/000000?text=+) `红色动态` `echo -e "\033[31m\033[01m\033[05m[ $1 ]\033[0m"`
- ![#335BFF](https://placehold.it/15/335BFF/000000?text=+) `蓝色` `echo -e "\033[34m[ $1 ]\033[0m"`
- ![#4CFF33](https://placehold.it/15/4CFF33/000000?text=+) `绿色` `echo -e "\033[32m[ $1 ]\033[0m"`

- ![#c5f015](https://placehold.it/15/c5f015/000000?text=+) `黄色` `echo -e "\033[33m\033[01m[ $1 ]\033[0m"`
- ![#c5f015](https://placehold.it/15/c5f015/000000?text=+) `黄色动态` `echo -e "\033[33m\033[01m\033[05m[ $1 ]\033[0m"`



# lvs



lvs-dr-deploy

```
bash < (curl -s https://raw.githubusercontent.com/marksugar/lvs/master/dr/lvs-dr-deploy.sh|more)

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
