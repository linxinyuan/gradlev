#! /bin/sh
config=".gradlevConfig"
startTime=`date +%s`
cd ~
home=`pwd`
cd -
myPath="$home/$config"

rw=`dirname $0`

SCRIPTPATH=$(cd $rw && pwd )

cur_git_branch() {
  curBranch=`git branch | grep "*"`
  echo "You are now checkout in branch ${curBranch/* /}"
}

#获取当前分支#
cur_git_branch

#配置全局常量#
#gitRepo="git@github.com:linxinyuan/LoggerSystem.git"
#serverName="linxinyuan@192.168.24.199"
#password="linxinyuan"
path="/build"

init_gradlev_config(){
    chmod +x $SCRIPTPATH/loginssh.sh 
    chmod +x $SCRIPTPATH/scp.sh
    chmod +x $SCRIPTPATH/spawnssh.sh

	#个人编译空间-/build/$name，重配置清空重写#
    read -p "please input your name: "  name
    echo "name=$name" > ~/$config

	#Git仓库地址-git@github.com:linxinyuan/LoggerSystem.git#
    read -p "please input git repositories to sync code: "  gitRepo
    echo "gitRepo=$gitRepo" >> ~/$config
	
	#远程服务器地址-linxinyuan@192.168.24.199#
    read -p "please input server's 'user@host' : "  serverName
    echo "serverName=$serverName" >> ~/$config

	#远程服务器登录密码-linxinyuan#
    read -p "please input server's password: "  password
    echo "password=$password" >> ~/$config

    #远程服务器登录端口-12330#
    read -p "please input server's port: "  port
    echo "port=$port" >> ~/$config

	#服务器编译空间-/build#
    #read -p "please input server's path to build: "  path
    echo "path=$path" >> ~/$config

	#项目编译地址#
    echo "buildPath=$path/gradlev/$name/*/app/" >> ~/$config

    #远程切换到编译主目录并尝试建立gradlev文件夹#
    #删除用户初始化文件夹并检出远程android项目源码#
    #添加gradlew脚本的执行权限#
    #拷贝gradle.properties文件到工程下(覆盖)#
    #拷贝local.properties文件到工程下(覆盖)#
    #完成初始化并结束远程连接1#
	$SCRIPTPATH/loginssh.sh "cd $path && mkdir -p gradlev && cd gradlev \
	&& rm -rf $name && mkdir -p $name && cd $name && git clone $gitRepo \
	&& chmod +x $path/gradlev/$name/*/gradlew \
	&& cp -rf $path/gradlev/gradle.properties $path/gradlev/$name/*/ \
	&& cp -rf $path/gradlev/local.properties $path/gradlev/$name/*/ \
	&& exit"
}

#配置文件初始化
if [ ! -e "$myPath" ]
then
 	init_gradlev_config
fi

source ~/$config

#远程连接创建并切换到当前分支-新代码拉取-保存上次改动现场#
#先尝试进行本地的分支切换，失败则直接从远程分支检出新分支#
#新分支拉取或者切换进行local与gradle.p文件的覆盖添加#
#拉取新代码并删除apk文件夹用于重新编译#
#完成分支切换任务并退出#
$SCRIPTPATH/loginssh.sh "cd $path/gradlev/$name && cd */ && git fetch && git stash \
&& git checkout ${curBranch/* /} || git checkout origin/${curBranch/* /} && git pull \
&& cp -rf $path/gradlev/gradle.properties $path/gradlev/$name/*/ \
&& cp -rf $path/gradlev/local.properties $path/gradlev/$name/*/ \
&& rm -rf ./build/outputs/apk/ && mkdir -p build/outputs/apk/ \
&& exit"

#执行远程的Clean命令#
#$SCRIPTPATH/loginssh.sh "cd $path/gradlev/$name && cd */ && ./gradlew clean"

#执行远程的Build命令执行Debug包编译#
$SCRIPTPATH/loginssh.sh "cd $path/gradlev/$name && cd */ && ./gradlew assembleDebug"

#切换到master-本地切换分支删除#
#$SCRIPTPATH/loginssh.sh "cd $path/gradlev/$name && cd */ && git checkout master && git branch -D ${curBranch/* /} && exit"

#远程Apk包拷贝到本地#
##$SCRIPTPATH/scp.sh $serverName $password $port $buildPath "app/build/outputs/"

##adb install -r app/build/outputs/app-debug.apk

endTime=`date +%s`
useTime=`expr $endTime - $startTime`
min=`expr $useTime / 60`
sec=`expr $useTime % 60`
#gradlew assembleDebug执行时长打印#
echo "ServerBuildTime:${min}分${sec}秒"
date "+%Y-%m-%d %H:%M:%S"