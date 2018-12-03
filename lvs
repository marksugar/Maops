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
