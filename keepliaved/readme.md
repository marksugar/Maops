
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
