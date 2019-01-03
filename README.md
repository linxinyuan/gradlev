# gradlev

## 前言
随着Android项目规模的扩大，编译时间是越来越长。

除了一些优化手段，提升硬件配置是提高编译速度最直接有效的方法。

该脚本的作用就是自动将编译过程放于服务器上进行，对使用者来说是完全透明的。

>另外，使用该方法会有额外的上传代码和下载代码的消耗，使用前请确保 额外的时间+服务器编译时间<本地编译时间

## 使用方法
## 打开桌面Cygwin-Terminate,切换到一个任意的空目录，准备做脚本项目的checkout，依次执行下面的命令

1. 安装
执行下面的命令：
```
$ git clone https://github.com/linxinyuan/gradlev.git #检出脚本远程仓#
$ cd gradlev #切换到gradlev主目录#
$ dos2unix ginit.sh greset.sh #脚本格式转化#
$ ./ginit.sh #执行初始化脚本#
```

2.  初始化
进入你的荔枝 Android 项目的根目录，执行
```
$ gradlev
按照如下提示输入相关信息：
please input your user name: linxinyuan #你的名字缩写，例如linxinyuan#
please input your user password: linxinyuan2019 #你的名字的缩写+2019，例如linxinyuan2019#

如果你后面执行失败了，那估计是管理员没有帮你创建账号和空间，找一下天河彭于晏反馈这个问题
```
3.  使用
至此，可以像使用gradlew一样来使用gradlev了，比如
```
##直接编译##
$ gradlev

##手动执行clean操作并编译，如果你编译失败的话可以试一下##
$ gradlev -c 

```
4.  重置
如果在步骤3的时候设置错误或者中途退出了，需要切换到gradlev主目录并执行脚本，比如
```
##谨慎执行此脚本，重新init需要重新拉取一次远程仓库代码##
$ ./greset.sh 
$ ./ginit.sh

```
然后重新从第2步骤重新设置编译参数

编译完的apk放于本地当前工程根目录的```build/outputs/apk/```，可使用adb命令直接安装

>如果有问题，欢迎提issue；如果觉得不错，欢迎star
