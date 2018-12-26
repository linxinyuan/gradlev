#!/usr/bin/env bash
echo "export PATH=$(pwd)/:\$PATH" >~/.bash_profile
source ~/.bash_profile

#进行服务器编译shell写入#
echo "$(pwd)/tools/buildServer.sh" >gradlev

#进行shell格式化doc->unix#
dos2unix ./tools/buildServer.sh ./tools/loginssh.sh ./tools/scp.sh ./tools/spawnssh.sh