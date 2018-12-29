#! /bin/sh
config=".gradlevConfig"
gitBranch=".gradlevBranch"
cd ~
home=`pwd`
cd -
myPath="$home/$config"

#rw=`dirname $0`
#SCRIPTPATH=$(cd $rw && pwd )

#配置shell局部常量#
#gitRepo="git@github.com:linxinyuan/LoggerSystem.git"
#serverName="linxinyuan@192.168.24.199"
#password="linxinyuan"
originBranch="master"
branchDiff=false
path="/build"

cur_git_branch() {
  curBranch=`git branch | grep "*"`
  echo "You are now checkout in branch ${curBranch/* /}"

  #如果不同变为false-后续要执行clean命令#
  if [[ ${curBranch/* /} != $buildBranch ]]; then
      branchDiff=true
  fi
}

init_gradlev_config(){
    chmod +x $depotPath/loginssh.sh
    chmod +x $depotPath/scp.sh
    chmod +x $depotPath/spawnssh.sh

	#个人编译空间-/build/$name，重配置清空重写#
    read -p "please input your name: "  name
    echo "name=$name" >> ~/$config

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
	$depotPath/loginssh.sh "cd $path && mkdir -p gradlev && cd gradlev \
	    && rm -rf $name && mkdir -p $name && cd $name && git clone $gitRepo \
	    && chmod +x $path/gradlev/$name/*/gradlew \
	    && cp -rf $path/gradlev/release-app-build.gradle $path/gradlev/$name/*/build-config \
	    && cp -rf $path/gradlev/gradle.properties $path/gradlev/$name/*/ \
	    && cp -rf $path/gradlev/local.properties $path/gradlev/$name/*/ \
	    && cp -rf $path/gradlev/build.gradle $path/gradlev/$name/*/ \
	    && exit"

	#写入原始分支master进入配置文件#
	echo "buildBranch=$originBranch" > ~/$gitBranch
}

source ~/$config
source ~/$gitBranch

#配置文件初始化
if [ ! -e "$myPath" ]
then
 	init_gradlev_config
fi

#获取当前分支#
cur_git_branch

echo "## 上次完成打包分支~$buildBranch ##"
echo "## 本次准备打包分支~${curBranch/* /} ##"
echo "## 是否需要自动进行Gradle-clean操作~$branchDiff ##"

if [ $branchDiff = 'true' ]; then
    #尝试重新拉取远程分支,成功-本地不存在该远程分支副本,失败-本地存在该远程分支副本#
    $depotPath/loginssh.sh "cd $path/gradlev/$name && cd */ && git fetch && git stash \
        && git checkout origin/${curBranch/* /} && exit"

    #进行分支切换,上一步失败直接切换分支,上一步失败则变成无效操作#
    $depotPath/loginssh.sh "cd $path/gradlev/$name && cd */ && git stash \
        && git checkout ${curBranch/* /} \
        && cp -rf $path/gradlev/release-app-build.gradle $path/gradlev/$name/*/build-config \
        && cp -rf $path/gradlev/gradle.properties $path/gradlev/$name/*/ \
        && cp -rf $path/gradlev/local.properties $path/gradlev/$name/*/ \
        && cp -rf $path/gradlev/build.gradle $path/gradlev/$name/*/ \
        && exit"
fi

#新分支拉取或者切换进行local与gradle.p文件的覆盖添加#
#拉取新代码并删除apk文件夹用于重新编译#
#完成分支切换任务并退出#
$depotPath/loginssh.sh "cd $path/gradlev/$name && cd */ && git pull \
    && rm -rf ./build/outputs/apk/ && mkdir -p build/outputs/apk/ \
    && exit"


#执行远程的Clean命令-是否切换了分支#
if [ $branchDiff = 'true' ]; then
    $depotPath/loginssh.sh "cd $path/gradlev/$name && cd */ && ./gradlew clean"
fi

while getopts "c" opt; do
  case $opt in
    c)
      $depotPath/loginssh.sh "cd $path/gradlev/$name && cd */ && ./gradlew clean"
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      ;;
  esac
done


echo "###################### Start Gradle Build ########################"
startTime=`date +%s`

#执行远程的Build命令执行Debug包编译#
$depotPath/loginssh.sh "cd $path/gradlev/$name && cd */ && ./gradlew assembleDebug"

endTime=`date +%s`
echo "###################### Finish Gradle Build ########################"
useTime=`expr $endTime - $startTime`
min=`expr $useTime / 60`
sec=`expr $useTime % 60`
#gradlew assembleDebug执行时长打印#
echo "服务器当前编译分支:$curBranch"
echo "服务器完成本次编译总耗时:${min}分${sec}秒"
date "+%Y-%m-%d %H:%M:%S"


echo "######################## Start Apk Download ########################"
#删除原来的apk存放文件夹
#rm -rf app/build/outputs/apk
#尝试创建一个新的apk文件夹用于远程传输
mkdir -p app/build/outputs/apk

#远程Apk包拷贝到本地#
$depotPath/scp.sh $serverName $password $port $buildPath "app/build/outputs/apk"


#改变最后一次打包的标志位#
echo "buildBranch=${curBranch/* /}" > ~/$gitBranch


echo "######################### ADB install Apk ##########################"
#Cygwin路径转化为windows绝对路径
proHome=`pwd`
appPath=`cygpath -p $proHome/app/build/outputs/apk/app-debug.apk -a -w`

#执行adb命令安装
adb install -r ${appPath}