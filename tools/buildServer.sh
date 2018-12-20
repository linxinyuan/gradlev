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

init_gradles_config(){
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

	#服务器编译空间-/build#
    read -p "please input server's path to build: "  path
    echo "path=$path" >> ~/$config

	#项目编译地址#
    echo "buildPath=$path/gradles/$name/*/app/" >> ~/$config

	$SCRIPTPATH/loginssh.sh "cd $path && mkdir -p gradles && cd gradles && rm -rf $name && mkdir -p $name \
	&& cd $name && git clone $gitRepo && cp $path/gradles/local.properties $path/gradles/$name/*/ \
	&& chmod +x $path/gradles/$name/*/gradlew && exit"
}

#配置文件初始化
if [ ! -e "$myPath" ]
then
 	init_gradles_config
fi

source ~/$config

#远程连接创建并切换到当前分支-新代码拉取-执行新一轮的编译命令#
$SCRIPTPATH/loginssh.sh "cd $path/gradles/$name && cd */ && git fetch && git checkout origin/${curBranch/* /} -b ${curBranch/* /} \
&& git pull && rm -rf ./build/outputs/apk/ && mkdir -p build/outputs/apk/ && exit"

#执行远程的Clean命令#
$SCRIPTPATH/loginssh.sh "cd $path/gradles/$name && cd */ && ./gradlew clean"

#执行远程的Build命令#
$SCRIPTPATH/loginssh.sh "cd $path/gradles/$name && cd */ && ./gradlew assembleDebug"

#切换到master-本地切换分支删除#
$SCRIPTPATH/loginssh.sh "cd $path/gradles/$name && cd */ && git checkout master && git branch -D ${curBranch/* /} && exit"

#远程Apk包拷贝到本地#
$SCRIPTPATH/scp.sh $serverName $password $buildPath "app/build/outputs/apk/"

endTime=`date +%s`
useTime=`expr $endTime - $startTime`
min=`expr $useTime / 60`
sec=`expr $useTime % 60`
echo "buildTime:${min}分${sec}秒"
date "+%Y-%m-%d %H:%M:%S"