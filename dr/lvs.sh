#!/bin/bash

#注：下文中LVS_IP_INF变量中的信息为需要配置的需求变量，变量之间分别以@符合隔开，总共有7个变量。以本例的需求来解析：
#lvs节点通过172.25.8.204的vip,将20880端口以DR模型的方式转发到172.25.8.59 172.25.8.60 节点的20880端口
#[-g|i|m]: LVS类型
#   -g: DR
#   -i: TUN
#   -m: NAT
#本脚本中默认的调度模式为rr
#通过以上解析，第一个变量绑定vip的网卡，第二个变量为vip，第三个变量为lvs-RS转发节点（可多个，以空格隔开），
#第四个变量为lvs-RS节点端口号，第五个变量为该业务备注信息，第六个变量为lvs节点中使用的端口号，第七个变量为lvs的类型

#Note: The information in the LVS_IP_INF variable below is the requirement variable that needs to be configured. The variables are separated by @ matching, and there are 7 variables in total. Parsed by the requirements of this example:
The #lvs node forwards the port 20880 to the port 18880 of the 172.25.8.59 172.25.8.60 node by means of the vip of 172.25.8.204.
#[-g|i|m]: LVS type
# -g: DR
# -i: TUN
# -m: NAT
# The default scheduling mode in this script is rr
# Through the above analysis, the first variable is bound to the NIC of the vip, the second variable is vip, and the third variable is the lvs-RS forwarding node (multiple, separated by spaces),
# The fourth variable is the lvs-RS node port number, the fifth variable is the service remark information, the sixth variable is the port number used in the lvs node, and the seventh variable is the lvs type.

LVS_IP_INF=`cat << EOF
eth0@172.25.8.204@172.25.8.59 172.25.8.60@20880@yewu20880@20880@g
EOF`

case "$1" in
start)
    /usr/sbin/ipvsadm -C
    echo "$LVS_IP_INF" | while read line;do
        read NET_FACE VIP PROJ SPORT MODE < <(echo "$line" | awk -F"@" '{print $1 " " $2 " " $5 " " $6 " " $7}')
        RIPS=$(echo $line | awk -F"@" '{print $3}')
        PORTS=$(echo $line | awk -F"@" '{print $4}')

        echo "添加项目LVS ${PROJ}:   网卡--- ${NET_FACE}   虚拟IP--- ${VIP}   真实主机--- ${RIPS}    代理端口---     ${PORTS}"
        for port in ${PORTS};do
            echo "添加虚拟服务器记录      ipvsadm -At ${VIP}:${SPORT} -s rr"
            /usr/sbin/ipvsadm -At ${VIP}:${SPORT} -s rr
            for rip in ${RIPS};do
                echo "添加真实服务器记录      ipvsadm -at ${VIP}:${SPORT} -r ${rip}:${port} -${MODE}"
                /usr/sbin/ipvsadm -at ${VIP}:${SPORT} -r ${rip}:${port} -${MODE}
            done
            echo
        done
        echo
    done
    echo "当前LVS状态："
    /usr/sbin/ipvsadm -Ln
    ;;
stop)
    /usr/sbin/ipvsadm -C
    /usr/sbin/ipvsadm -Ln
    ;;
add)
    date 
    echo "$LVS_IP_INF" | while read line;do
        read NET_FACE VIP PROJ SPORT MODE < <(echo "$line" | awk -F"@" '{print $1 " " $2 " " $5 " " $6 " " $7}')
        RIPS=`echo $(echo $line | awk -F"@" '{print $3}')`
        PORTS=`echo $(echo $line | awk -F"@" '{print $4}')`

        echo "添加LVS项目 ${PROJ}:     网卡---${NET_FACE}   虚拟IP---${VIP}   真实主机---${RIPS}        代理端口---${PORTS}" 
        for port in ${PORTS};do
            /usr/sbin/ipvsadm -Ln | grep -v '-' | grep ${VIP}:${SPORT} > /dev/null
            [ $? -eq 0 ] && echo $VIP:${SPORT}"已存在" && continue
            echo "添加虚拟服务器记录      ipvsadm -At ${VIP}:${SPORT} -s rr" 
            /usr/sbin/ipvsadm -At ${VIP}:${SPORT} -s rr
            for rip in ${RIPS};do
                echo "添加真实服务器记录      ipvsadm -at ${VIP}:${SPORT} -r ${rip}:${port} -${MODE}"
                /usr/sbin/ipvsadm -at ${VIP}:${SPORT} -r ${rip}:${port} -${MODE}
            done
            echo 
        done
        echo 
    done
    echo "当前LVS状态：" 
    /usr/sbin/ipvsadm -Ln
    ;;
*)
    echo "Usage: $0 {start|stop|add}"
    ;;
esac
