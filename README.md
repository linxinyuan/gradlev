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
$ ./ginit.sh #执行初始化脚本#
```

2.  初始化
进入你的荔枝 Android 项目的根目录,进入你的荔枝 Android 项目的根目录,进入你的荔枝 Android 项目的根目录(重要的事说三次)，执行
```
$ gradlev
按照如下提示输入相关信息(只需要输入一次)：
please input your user space: #@林新源 申请用户编译空间#
please input your login server password: #@林新源 获取密码#
```

3.  使用
至此，可以像使用gradlew一样来使用gradlev了，比如
```
##直接编译(不需要点斜杠)##
$ gradlev

##手动执行clean操作并编译(不需要点斜杠)##
$ gradlev -c 

##适配胡步军单模块编译分支(不需要点斜杠)##
$ gradlev -a

$ 如果遇到其他问题未能走到编译阶段，请截图异常 @林新源 企业微信沟通
```

4.  重置
如果在步骤2的时候设置错误或者中途退出了，需要切换到gradlev主目录并执行脚本，比如
```
$ ./greset.sh 

$ ./ginit.sh
$ 重新输入用户名和密码

$ gradlev - 开始编译
```

脚本执行完毕会自动通过adb命令帮你安装，但是不会自动帮你启动应用，如果编译成功但是adb由于环境问题安装失败
编译完的apk放于本地当前工程根目录的```build/outputs/apk/```，可使用adb命令手动安装

>如果有问题，欢迎提issue；如果觉得不错，欢迎star
