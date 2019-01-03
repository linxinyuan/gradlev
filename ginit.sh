#!/usr/bin/env bash
initial=".gradlevInitial"

rw=`dirname $0`
SCRIPTPATH=$(cd $rw && pwd)/tools

#服务器编译脚本仓库绝对路径写入配置文件#
echo "depotPath=$SCRIPTPATH" > ~/$initial

#全局配置可执行文件软链接>执行脚本#
ln -s $SCRIPTPATH/buildServer.sh /usr/bin/gradlev