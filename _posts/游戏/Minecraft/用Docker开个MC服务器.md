---
title: 用Docker开个MC服务器
date: 2023-06-07 21:26:19
author: xeonds
toc: true
excerpt: Docker真香.jpg
tags:
  - Docker
  - Minecraft
cover: /img/79c2fe8bd08250e6505ed783980d3739.jpeg
---

前段时间好好学了下Docker，于是想试着用它去部署一些比较麻烦的服务端。所以首先就是试试MC了，毕竟能实现服务端跟地图数据分离以及服务端自动化部署，便于迁移确实很爽。

虽然MC服务端的性能敏感性比较高，但是Docker+MC的性能问题比较小，因为基于KVM，虚拟化由内核支持，所以Docker性能开销相当小，日用基本可以忽略。

## 目标

部署好之后，目录下应该只有一个地图文件夹，一个服务端程序，以及一个明确指示了地图文件夹和服务端程序路径的dockerfile。如果使用docker-compose去实现包括mc服务端的外围功能（比如bluemap等地图功能，以及geyser这样的be兼容转换服务端），那也可以，不过得保证数据程序的分离，以及可维护、易于修改的特质。

基于上面的目标，可以使用Volume完成资源的映射。我们需要的只是一个基础的jre镜像。

## 代码

Dockerfile很简单，就是基础的jre镜像，以及启动指令。

```dockerfile
FROM openjdk:17

WORKDIR /app
RUN echo "eula=true" > /app/eula.txt

CMD ["java", "-jar", "server.jar"]
```

然后是启动脚本，我将几个常用指令封装成一个Bash脚本了：

```bash
#!/bin/bash

# 获取第一个参数
action=$1

# 根据参数执行不同的操作
case $action in
  run) # 运行容器
    docker run -d \
      -p 25565:25565 \
      -v $(pwd)/world:/app/world \
      -v $(pwd)/server.jar:/app/server.jar \
      -v $(pwd)/server.properties:/app/server.properties \
      --name mc \
      mc-server
    ;;
  build) # 构建镜像
    docker build -t mc-server .
    ;;
  stop) # 停止容器
    docker stop mc
    ;;
  start) # 启动容器
    docker start mc
    ;;
  restart) # 重启容器
    docker restart mc
    ;;
  backup) # 备份文件
    timestamp=$(date +%Y%m%d%H%M%S)
    zip -r [backup]mc-server-$timestamp.zip world server.properties mc.sh Dockerfile server.jar
    ;;
  log) # 输出日志
    docker logs -f mc
    ;;
  sh) # 进入shell
    docker exec -it mc sh
    ;;

  *) # 输出帮助信息并退出
    echo "Usage: $0 {run|build|stop|start|restart|log|sh}"
    exit 1
    ;;
esac
```

然后，在保证目录下有`server.jar`和`server.properties`的前提下，使用`./mc.sh run`来初始化并运行服务端。剩下的用法参考上面的代码，或者参考[这里](https://github.com/xeonds/docker-mc/)。

## 外围

开了服务器之后，肯定需要对公网/内网开放。我在这里用了一个frp的镜像，同样也将它封装为了启动脚本：

```bash
#!/bin/bash

# 定义容器名称和配置文件路径
CONTAINER_NAME=frpc
CONFIG_FILE=$(pwd)/frpc.ini

# 检查参数个数
if [ $# -eq 0 ]; then
    echo "Usage: $0 run|start|stop|restart"
    exit 1
fi

# 根据参数执行相应操作
case $1 in
    run)
        # 部署容器
        docker run --restart=always --network host -d -v $CONFIG_FILE:/etc/frp/frpc.ini --name $CONTAINER_NAME snowdreamtech/frpc
        ;;
    start)
        # 启动容器
        docker start $CONTAINER_NAME
        ;;
    stop)
        # 停止容器
        docker stop $CONTAINER_NAME
        ;;
    restart)
        # 重启容器
        docker restart $CONTAINER_NAME
        ;;
 	log) # 输出日志
    	docker logs -f $CONTAINER_NAME
	    ;;
  	sh) # 进入shell
    	docker exec -it $CONTAINER_NAME sh
	    ;;
    *)
        # 无效参数
        echo "Invalid argument: $1"
        echo "Usage: $0 run|start|stop|restart|log"
        exit 2
        ;;
esac

# 打印容器状态
docker ps -a | grep $CONTAINER_NAME
```

同样，保证目录下有一个`frpc.ini`文件。每次编辑完成后，需要删除原来的容器重新启动一个。

还有一个使用`pushplus`简单的监控脚本：

```bash
#!/bin/bash

token="your_token_here"
url=http://www.pushplus.plus/send

bash mc.sh log | grep -E --line-buffered "error|fail|warn" |\
while read line; 
	do json="{\"token\": \"$token\", \"title\": \"MC服务端异常报警\", \"content\": \"$line\"}"
	curl -H "Content-Type: application/json" -X POST -d "$json" $url
done
```

它会**每次从日志开始读取日志**，将报错信息发送给PushPlus API。我一般会在微信上收报警消息。不过每次从日志开始读取日志确实不太好（会重复发送以前的错误信息）。这个回头得改一改。要么每次退出时清空日志，要么设置个读取行指示的全局变量。

就是这样啦。
