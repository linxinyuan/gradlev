# gradlev

## 前言
随着Android项目规模的扩大，编译时间是越来越长。

除了一些优化手段，提升硬件配置是提高编译速度最直接有效的方法。

该脚本的作用就是自动将编译过程放于服务器上进行，对使用者来说是完全透明的。

>另外，使用该方法会有额外的上传代码和下载代码的消耗，使用前请确保 额外的时间+服务器编译时间<本地编译时间

## 使用方法

1. 安装
执行下面的命令：
```
$ git clone git@github.com:linxinyuan/gradlev.git
$ cd gradlev
$ echo "export PATH=$(pwd)/:\$PATH" >>~/.bash_profile
$ echo "$(pwd)/tools/buildServer.sh" >>gradlev
$ source ~/.bash_profile
```
2.  初始化
进入Android 项目的根目录，执行
```
$ gradlev
按照如下提示输入相关信息：
please input your name: linxinyuan #个人编译空间-/build/$name，重配置清空重写#
please input git repositories to sync code: git@XXX #Git仓库地址-git@github.com:linxinyuan/LoggerSystem.git#
please input server's 'user@host' : root@192.168.1.1 #远程服务器地址-linxinyuan@192.168.24.199#
please input server's password: 123456 #远程服务器登录密码-linxinyuan#
please input server's path to build: /build #服务器编译空间-/build#
```
3.  使用
至此，可以像使用gradlew一样来使用gradlev了，比如
```
$ gradlev

```
编译完的apk放于当前工程根目录的```build/outputs/apk/```

>如果有问题，欢迎提issue；如果觉得不错，欢迎star
