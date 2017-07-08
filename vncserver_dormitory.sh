#!/bin/bash

screen_size=1520x860

echo ""
if [[ `vncserver -list |grep :1` != "" ]]; then
    echo "已存在localhost:1"
    echo "删除..."
    vncserver -kill :1
    echo ""
fi

echo "创建localhost:1，屏幕尺寸为$screen_size"
vncserver :1 -geometry 1520x860
vncserver -list
