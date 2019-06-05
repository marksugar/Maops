# nmp
* Application version
USE ： nginx-1.10.2  php-5.6.29  mariadb-10.1.19-linux-x86_64
```
curl -Lks4 https://raw.githubusercontent.com/marksugar/Maops/master/nmp/nginx-install.sh |bash
curl -LKs4 https://raw.githubusercontent.com/marksugar/Maops/master/nmp/php-install%20.sh |bash
curl -LKs4 https://raw.githubusercontent.com/marksugar/Maops/master/nmp/mariadb-install.sh |bash
```
* Databases Create table:
Delete the test tables, modify the root password, as follows
```
mysql -e "DELETE FROM mysql.user WHERE User='';"
mysql -e "DELETE FROM mysql.db WHERE Db LIKE 'test%';"
mysql -e "DROP DATABASE test;"
mysql -e "CREATE DATABASE bbs charset='utf8';"
mysql -e "GRANT ALL PRIVILEGES ON bbs.* To 'bbs'@'%' IDENTIFIED BY '8K7ucb5uXC';"
mysql -e "UPDATE mysql.user SET password = password('abc8K7123') WHERE user = 'root';"
mysql -e "flush privileges;"
myqsl -uroot -pabc8K7123 -e "flush privileges;"
```

* download discuz_x3.2
```
down load Discuz
cd /usr/local
wget http://download.comsenz.com/DiscuzX/3.2/Discuz_X3.2_SC_UTF8.zip && unzip Discuz_X3.2_SC_UTF8.zip 
rm -rf readme utility/ Discuz_X3.2_SC_UTF8.zip &&  chown -R nginx.nginx /data/wwwroot/
```
