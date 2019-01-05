#!/bin/bash
echo -e '''
\033[32m Welcome to this script! \033[0m
\033[32m 请输入数字1，2，3来选择初始化配置 \033[0m
\033[32m Please enter the numbers 1, 2, 3 to select the initial configuration.  \033[0m
\033[32m good luck ! \033[0m
'''

while read -p '
############################################
#		q, 退出
#		1, lvs-master 初始配置
#		2, lvs-slave  初始配置
#		3, 代理节点初始配置
#		q, quit
#		1, lvs-mast
#		2, lvs-slav
#		3, the initial configuration of the proxy node
#############################################
Enter A Number:' ENZ;do
	case $ENZ in
	q)
	exit 1;;
	1)	
	read -p "请输入对端lvs IP地址:" IPADDERS
		#sed -i '/openstacklocal/a\nameserver 10.10.100.100' /etc/resolv.conf 
		
		
		#if [ `grep 10.10.100.100 /etc/sysconfig/network-scripts/ifcfg-eth0|wc -l` -lt 1 ]; then 
		#	echo -e "Note: Start using intranet DNS1: 10.10.100.100"		
		#	echo "DNS1=10.10.100.100" >> /etc/sysconfig/network-scripts/ifcfg-eth0;
		#	systemctl restart network
	    #fi			
		
		
			
		if [ `grep DNS1 /etc/sysconfig/network-scripts/ifcfg-eth0|wc -l` -lt 1 ]; then 
			echo -e "\033[32m Note: Start using intranet DNS1: 10.10.100.100\033[0m"		
			echo "DNS1=10.10.100.100" >> /etc/sysconfig/network-scripts/ifcfg-eth0;
			systemctl restart network
	    fi
        
		if [ `grep DNS1 /etc/sysconfig/network-scripts/ifcfg-eth0|wc -l` -ge 1 ]; then 
			echo -e "\033[32m Note: Start using intranet DNS1: 10.10.100.100\033[0m"
			sed -i '/DNS1/d' /etc/sysconfig/network-scripts/ifcfg-eth0						
			echo "DNS1=10.10.100.100" >> /etc/sysconfig/network-scripts/ifcfg-eth0;
			#sed -i 's/DNS1=.*/DNS1=10.10.100.100/g'  /etc/sysconfig/network-scripts/ifcfg-eth0
			systemctl restart network			
		fi		
		

		
		if [ `echo $(curl -I -s -w "%{http_code}" -o /dev/null http://mirrors.ds.com)` == 200 ];then 
			echo -e "\033[32mUpcoming intranet mirrors : http://mirrors.ds.com\033[0m"
			if ! grep -q mirrors.ds.com /etc/hosts; then sed -i '/^::1/a \\n10.10.10.250    mirrors.ds.com' /etc/hosts;fi;
			curl -Lk https://raw.githubusercontent.com/LinuxEA-Mark/lvs/master/CentOS-LocalBase.repo > /etc/yum.repos.d/CentOS-Base.repo
			curl -Lk https://raw.githubusercontent.com/LinuxEA-Mark/lvs/master/epel.repo  > /etc/yum.repos.d/epel.repo
		else
			echo -e "\033[32mUnable to use intranet mirror http://mirrors.ds.com and use public network http://mirror.centos.org/\033[0m"
			curl -Lk https://raw.githubusercontent.com/LinuxEA-Mark/lvs/master/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo
			[ -f /etc/yum.repos.d/CentOS-Base.repo ]|| rm -rf /etc/yum.repos.d/epel.repo
			yum install epel* -y
		fi
		

		
		#IPADDERS=$(ip a|awk '/eth0/'|awk '/inet/{print $2}')
		ADDVIPCONF=/usr/lib/systemd/system/addvip.service
		KEEPCONF=/etc/keepalived/keepalived.conf
		LVSCONF=/scripts/lvs.sh
				
		mkdir -p /scripts 
		curl -Lks https://raw.githubusercontent.com/LinuxEA-Mark/lvs/master/dr/lvs.sh -o /scripts/lvs.sh
		chmod +x /scripts/lvs.sh 
		systemctl daemon-reload
		systemctl enable addvip.service
		
		if [ `rpm -qa ipvsadm |wc -l` != 1 ];then
			echo -e "\033[32m install ipvsadm now \033[0m"
			yum install keepalived ipvsadm -y
		fi	
		
		if [ `rpm -qa keepalived |wc -l` != 1 ];then
			echo -e "\033[32m install ipvsadm keepalived \033[0m"
			yum install keepalived  -y
		fi	
		[ ! -f /etc/keepalived/keepalived.conf ]|| rm -rf /etc/keepalived/keepalived.conf && curl -Lks https://raw.githubusercontent.com/LinuxEA-Mark/lvs/master/dr/keepalived-master -o ${KEEPCONF}
	

		echo -e "\033[32m add iptables and ${IPADDERS} \033[0m"
		curl -Lks https://raw.githubusercontent.com/LinuxEA-Mark/lvs/master/dr/addvip.service -o ${ADDVIPCONF}	
		sed -i  "/-A INPUT -j REJECT/i\-A INPUT -p 112 -s ${IPADDERS}  -j ACCEPT" /etc/sysconfig/iptables
		sed -i  "/-A INPUT -j REJECT/i\-A INPUT -s 172.25.0.0/16 -p tcp -m tcp -m state --state NEW -m multiport --dports 20880 -m comment --comment "yewu" -j ACCEPT"   /etc/sysconfig/iptables
		systemctl daemon-reload
		systemctl enable addvip.service	
		systemctl restart iptables 
		echo -e "
		\033[32m 请修改配置文件: "${KEEPCONF}" \033[0m     
		\033[32m 请修改配置文件: "${LVSCONF}" \033[0m 
		\033[32m 而后systemctl start keepalived.service addvip.service \033[0m 
		\033[32m 你可能还需要放行防火墙规则，master/backup都要 \033[0m 		
		"		
		#echo -e "请修改配置文件:    ${KEEPCONF} \n            ${ADDVIPCONF} \n而后systemctl start keepalived.service addvip.service"
		exit 1;;
	2)
	read -p "请输入对端lvs IP地址:" IPADDERS
		#sed -i '/openstacklocal/a\nameserver 10.10.100.100' /etc/resolv.conf 
		
		
		#if [ `grep 10.10.100.100 /etc/sysconfig/network-scripts/ifcfg-eth0|wc -l` -lt 1 ]; then 
		#	echo -e "Note: Start using intranet DNS1: 10.10.100.100"		
		#	echo "DNS1=10.10.100.100" >> /etc/sysconfig/network-scripts/ifcfg-eth0;
		#	systemctl restart network
	    #fi			
		
		
			
		if [ `grep DNS1 /etc/sysconfig/network-scripts/ifcfg-eth0|wc -l` -lt 1 ]; then 
			echo -e "\033[32m Note: Start using intranet DNS1: 10.10.100.100\033[0m"		
			echo "DNS1=10.10.100.100" >> /etc/sysconfig/network-scripts/ifcfg-eth0;
			systemctl restart network
	    fi
        
		if [ `grep DNS1 /etc/sysconfig/network-scripts/ifcfg-eth0|wc -l` -ge 1 ]; then 
			echo -e "\033[32m Note: Start using intranet DNS1: 10.10.100.100\033[0m"
			sed -i '/DNS1/d' /etc/sysconfig/network-scripts/ifcfg-eth0						
			echo "DNS1=10.10.100.100" >> /etc/sysconfig/network-scripts/ifcfg-eth0;
			#sed -i 's/DNS1=.*/DNS1=10.10.100.100/g'  /etc/sysconfig/network-scripts/ifcfg-eth0
			systemctl restart network			
		fi		
		

		
		if [ `echo $(curl -I -s -w "%{http_code}" -o /dev/null http://mirrors.ds.com)` == 200 ];then 
			echo -e "\033[32mUpcoming intranet mirrors : http://mirrors.ds.com\033[0m"
			if ! grep -q mirrors.ds.com /etc/hosts; then sed -i '/^::1/a \\n10.10.10.250    mirrors.ds.com' /etc/hosts;fi;
			curl -Lk https://raw.githubusercontent.com/LinuxEA-Mark/lvs/master/CentOS-LocalBase.repo > /etc/yum.repos.d/CentOS-Base.repo
			curl -Lk https://raw.githubusercontent.com/LinuxEA-Mark/lvs/master/epel.repo  > /etc/yum.repos.d/epel.repo
		else
			echo -e "\033[32mUnable to use intranet mirror http://mirrors.ds.com and use public network http://mirror.centos.org/\033[0m"
			curl -Lk https://raw.githubusercontent.com/LinuxEA-Mark/lvs/master/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo
			[ -f /etc/yum.repos.d/CentOS-Base.repo ]|| rm -rf /etc/yum.repos.d/epel.repo
			yum install epel* -y
		fi
		

		
		#IPADDERS=$(ip a|awk '/eth0/'|awk '/inet/{print $2}')
		ADDVIPCONF=/usr/lib/systemd/system/addvip.service
		KEEPCONF=/etc/keepalived/keepalived.conf
				
		mkdir -p /scripts 
		curl -Lks https://raw.githubusercontent.com/LinuxEA-Mark/lvs/master/dr/lvs.sh -o /scripts/lvs.sh
		chmod +x /scripts/lvs.sh 
		systemctl daemon-reload
		systemctl enable addvip.service
		
		if [ `rpm -qa ipvsadm |wc -l` != 1 ];then
			echo -e "\033[32m install ipvsadm now \033[0m"
			yum install keepalived ipvsadm -y
		fi	
		
		if [ `rpm -qa keepalived |wc -l` != 1 ];then
			echo -e "\033[32m install ipvsadm keepalived \033[0m"
			yum install keepalived  -y
		fi
		[ ! -f /etc/keepalived/keepalived.conf ]|| rm -rf /etc/keepalived/keepalived.conf && curl -Lks https://raw.githubusercontent.com/LinuxEA-Mark/lvs/master/dr/keepalived-slave -o ${KEEPCONF}
			

		echo -e "\033[32m add iptables and ${IPADDERS} \033[0m"
		curl -Lks https://raw.githubusercontent.com/LinuxEA-Mark/lvs/master/dr/addvip.service -o ${ADDVIPCONF}	
		sed -i  "/-A INPUT -j REJECT/i\-A INPUT -p 112 -s ${IPADDERS}  -j ACCEPT" /etc/sysconfig/iptables
		sed -i  "/-A INPUT -j REJECT/i\-A INPUT -s 172.25.0.0/16 -p tcp -m tcp -m state --state NEW -m multiport --dports 20880 -m comment --comment "yewu" -j ACCEPT"   /etc/sysconfig/iptables
		systemctl daemon-reload
		systemctl enable addvip.service	
		systemctl restart iptables 
		echo -e "
		\033[32m 请修改配置文件: "${KEEPCONF}" \033[0m     
		\033[32m 请修改配置文件: "${LVSCONF}" \033[0m 
		\033[32m 而后systemctl start keepalived.service addvip.service \033[0m 
		"
		exit 1;;
	3)
	read -p "请输入VIP IP地址:" IPADDERS
		ADDVIPCONF=/usr/lib/systemd/system/addvip.service
		mkdir -p /scripts
		curl -Lk https://raw.githubusercontent.com/LinuxEA-Mark/lvs/master/dr/lvs-env.sh -o /scripts/lvs.sh
		sed -i "s/IPADDERSVIP/${IPADDERS}/g"  /scripts/lvs.sh
		chmod +x /scripts/lvs.sh
		curl -Lks https://raw.githubusercontent.com/LinuxEA-Mark/lvs/master/dr/addvip.service -o ${ADDVIPCONF}	
		systemctl daemon-reload
		systemctl enable addvip.service	
		systemctl start addvip.service
		sed -i "/-A INPUT -j REJECT/i\-A INPUT -s 172.25.0.0/16 -p tcp -m tcp -m state --state NEW -m multiport --dports 20880 -m comment --comment "yewu" -j ACCEPT"   /etc/sysconfig/iptables
		cat /scripts/lvs.sh
		exit 1;;
	esac
done
