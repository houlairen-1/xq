#-*-coding:utf-8-*-
# /bin/bash
# Author: xq
# Date: Fri April 27, 2018
# Application: 找寻ip地址。
# Thinking: 确定域名，遍历ip地址空间
# 本代码分两步($step)：
# 第一步，找寻所有可用ip，保存到$available_ips
# 第二步，尝试rdesktop连接$available_ips中所有的ip，
#         根据错误信息判断结果。

domin='172.29.107' # 2017-10-16
available_ips='available_ips.txt'
result='rdp_result.txt'
# $result中含有这一句
# “Failed to negotiate protocol, retrying with plain RDP.”
# 即为所求。
step=$1

if [ $step == 1 ]; then
    if [ -f $available_ips ]; then
        rm -f $available_ips
        echo 'remove '$available_ips
    fi
    # 搜索所有可以用的ip地址
    for ((subnet=3;subnet<255;subnet++));
    do
        ip=$domin'.'$subnet
        ping -w 1 $ip
        if [ $? == 0 ]; then
            echo $ip >> $available_ips
        fi
    done
elif [ $step == 2 ]; then
    if [ -f $result ]; then
        rm -f $result
        echo 'remove '$result
    fi
    for ip in $(cat $available_ips)
    do
        echo $ip >> $result
        # >> filename 2>&1 
        # 把标准输出和标准错误一起重定向到filename文件中(追加)
        # refer: https://www.cnblogs.com/emanlee/p/5375496.html
        timeout 3 rdesktop-vrdp $ip -g 1920x1080 -f >> $result 2>&1
    done
fi
