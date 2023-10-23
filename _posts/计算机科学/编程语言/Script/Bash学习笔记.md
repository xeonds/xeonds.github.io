---
title: Bash学习笔记
date: 2023-06-03 21:43:09
author: xeonds
toc: true
excerpt: 积累起来的bash使用技巧，用来处理日常的一些问题
tags:
  - Bash
  - 数据统计
  - 技巧
---

Bash对于绝大多数任务来说够用。所以没必要太折腾，先试试Bash吧。

第一部分我会记录一些Linux自带（绝大多数情况）程序的用法，第二部分会把它们组合起来使用。

## 命令介绍

### 数据操作类指令

head命令用于显示文件的开头几行，sort命令用于对文件或标准输入进行排序，可以按照字母顺序、数字大小、日期等方式进行排序，uniq命令则用于去除重复的行，可以通过参数指定只保留重复行的数量或只显示重复行。

head命令的语法：`head [选项] [文件]`。例如，要查看文件file.txt的前10行，请使用以下命令：`head -n 10 file.txt`。¹\

sort命令的语法：`sort [选项] [文件]`。例如，要按字母顺序对文件file.txt进行排序，请使用以下命令：`sort file.txt`。要按数字大小对文件进行排序，请使用以下命令：`sort -n file.txt`。

uniq命令的语法：`uniq [选项] [输入文件] [输出文件]`。例如，要从文件file.txt中删除重复的行并将结果写入新文件newfile.txt，请使用以下命令：`uniq file.txt newfile.txt`。要显示重复行及其出现次数，请使用以下命令：`uniq -c file.txt`。

### Bash的语法

bash的一行语句结尾可以写分号`;`，也可以不写。用分号可以将多条指令串联起来运行，比如`cmd1; cmd2; cmd3; ...`

它的管道是一个相当好用的东西，可以将几个命令的输入输出相互串起来，得到一个组合后的工具，并且管道是系统级工具，因此十分灵活且高效。比如`cmd1 | cmd2 | xargs cmd3 | ...`。

这里的`xargs`是另一个工具，它可以将它得到的stdin转化成后面跟随指令的参数列表。比如`find . -type f -name "* *" -print0 | xargs -0 rm -f`，它就可以将符合条件的文件作为一个参数列表传递给`rm -f`指令。另外，这里的`-0`是告诉xargs，在读入stdin时，使用 null 作为分隔符。

除了管道和分号，还有`&&`，也可以连接多条指令。它和分号类似，不过区别是它会检查前一条指令的运行结果（返回值），并且根据这个来决定是否运行下一条指令。例如，`cmd1 && cmd2 && cmd3`，这样写的话，只要任意一个指令运行失败，那么它之后的所有指令都会不执行，这样可以有效防止发生一些难以预料的情况。

## 一些用法

黑魔法开始了（不是

### 统计输出情况

```bash
./a.out | head -n 100000 | sort | uniq -c
```

这样就能得到统计好的输出数据。

### 随机输出一行

看到同学发的抽奖现场用Python现写程序，节目效果拉满（）不过，都用Linux了，还不用Bash？

```bash
fname="lab6.c"; rand=$((RANDOM%$(cat "$fname" | wc -l))); sed -n "$rand"p "$fname"
```

上面的命令其实是3行命令，但是每行都比较短就合成一行了。第一个和第二个都是赋值命令，设置文件名，并根据文件行数生成随机数。第三行用`sed`从文件中读取指定的行。

对于第三行指令，其实不用`sed`也行，用`head -n "$rand" | tail -n 1"`也是能得到相同的结果。完整指令：

```bash
fname="lab6.c"; rand=$((RANDOM%$(cat "$fname" | wc -l))); cat $fname | head -n "$rand" | tail -n 1
```

总之能看出，对于操作数据，Linux自带的工具也很强大了。

### 保留最近三天的文件

这东西用来清log和冗余备份确实好用。

清文件夹记得把-f换成-rf。

```bash
find [target file in path] -mtime +2 |xargs rm -f
```

### Ubuntu内存释放 

>2020.12.18 11:05:00

下面的指令用来释放系统内存，只在Ubuntu上测试过。长期运行的服务器最好严密监督内存使用情况：

```
 echo 3 >/proc/sys/vm/drop_caches
```

啊对了注意指令里是vm不是mv。

### ln-强大的软链接工具

常用用法：

```bash
ln –s 源文件 软连接文件
```

这可以帮我们把一个文件链接到另一个地方，类似Windows的快捷方式。

我一般会用它把正在开发的项目链接到nginx的目录下，来实时预览效果。

### 端口占用解除

有时候一些网络应用会启动失败，提示端口被占用。那么一般怎么解决呢？

#### 系统环境  

我的系统是Ubuntu20.04，其他Linux应该也大同小异。

#### 解决步骤  

就两步。先找到进程：  

```
netstat -anlp| grep 端口号
```

然后结束进程：  

```
kill -9 进程pid
```

完事儿。

或者可以用awk和管道把命令缩短到一行：

```bash
netstat -anlp | grep 3000 | awk '{print $7}' | awk -F '/' '{print $1}' | xargs kill -9
```

不太好看但是还挺方便。起码手不疼了（

### nc

用`nc`可以进行局域网聊天（不是
  
用 `socat` 还可以群聊： 局域网内所有 Linux 机器，输入下方命令加入群聊（指 UDP 广播）（狗头）（狗头）  

```bash
socat - UDP-DATAGRAM:255.255.255.255:12345,broadcast,bind=0.0.0.0:12345
```

### 根据nginx日志自动ban异常IP

```bash
#!/bin/bash  
  
line=1000  
times=10  
conf=/opt/nginx/conf/blockip.conf  
  
tail /data/logs/nginx/access.log -n $line | \  
grep -E '("status":"404"|"status":"302")' | awk '{print $1}' | \  
sort | uniq -c | \  
awk '$1>$times{print "deny "$2 ";"}' >> $conf  
  
deny=$(sort $conf | uniq -c | awk '{print "deny "$3}')  
echo $deny | sed "s/; /;\n/g" > $conf  
  
/usr/local/sbin/nginx -t || exit  
/usr/bin/systemctl reload nginx
```

### 一些小工具

lazygit ，Git 的终端界面  
ranger ，终端文件管理器  
lolcat ，对输出做渐变色处理  
trash ，mv 的垃圾回收站版本  
icdiff ，diff 的样式改进版本  
lsd ，带文件类型图标的 ls

### 跟踪某网页特定内容

```bash
#!/bin/bash

url="http://v2ex.com"
want="好玩"
wget "$url" -O contents
if
    result=$(cat contents | ack -i "$want")
then
    echo "$result" | mail -s "Notification" youe@mail.com
else
    echo "nothing"
fi
```

### 空间查看

最近经常在用这个指令查看空间使用情况：

```bash
du -sh ./* 2>/dev/null | sort -u
```

比如看下缓存占用情况啥的：

```bash
❯ sudo du -sh ./* 2>/dev/null | sort -u
0       ./motd-news
1.4M    ./apparmor
2.0M    ./man
20K     ./snapd
228K    ./fontconfig
3.8M    ./debconf
32K     ./ldconfig
4.0K    ./pollinate
4.0K    ./private
8.0K    ./PackageKit
8.0K    ./apache2
8.0K    ./app-info
971M    ./apt
```

### 用PushPlus集成事件通知服务

这个脚本读取第一，二个命令行参数，然后发送通知。可以跟其他工具串一块，简单实现服务器监控报警功能：

```bash
#!/bin/bash

token=PUSH_PLUS_TOKEN
url=http://www.pushplus.plus/send

json="{\"token\": \"$token\", \"title\": \"$1\", \"content\": \"$2\"}"
curl -H "Content-Type: application/json" -X POST -d "$json" $url
```

单行脚本：

```bash
tail -F /var/log/syslog | grep -E --line-buffered "error|fail|warn" | while read line; do bash /path/to/pushplus.sh "服务器异常日志" "$line"; done
```

效果如下：

![添加一个“错误”消息](img/Pasted%20image%2020230610193751.png)

![发送成功](img/Pasted%20image%2020230610193904.png)

![](img/Pasted%20image%2020230610193940.png)

测试就完成了。然后直接nohup丢到后台，就能很方便地实现异常告警了。

- 集成到crontab

用了一段时间之后，发现是挺舒服，配合crontab定时触发更是自动运维的好东西。

假设有一个运维工具将信息直接输出到stdout，那么我们可以在crontab里这么写：

```bash
output=$(/path/to/script.sh); pushplus "自动任务完成" "$output"
```

不过得先将上面的`pushplus.sh`去掉后缀放在`/usr/local/bin/`之类的地方才能全局使用。

### 文本文件合并

This is technically what `cat` ("concatenate") is supposed to do, even though most people just use it for outputting files to stdout. If you give it multiple filenames it will output them all sequentially, and then you can redirect that into a new file; in the case of all files just use `./*` (or `/path/to/directory/*` if you're not in the directory already) and your shell will expand it to all the filenames (excluding hidden ones by default).

```
$ cat ./* > merged-file
```

Make sure you don't use the `csh` or `tcsh` shells for that which expand the glob _after_ opening the `merged-file` for output, and that `merged-file` doesn't exist before hand, or you'll likely end up with an infinite loop that fills up the filesystem.

The list of files is sorted lexically. If using `zsh`, you can change the order (to numeric, or by age, size...) with glob qualifiers.

To include files in sub-directories, use:

```
find . ! -path ./merged-file -type f -exec cat {} + > merged-file
```

Though beware the list of files is not sorted and hidden files are included. `-type f` here restricts to _regular_ files only as it's unlikely you'll want to include other types of files. With GNU `find`, you can change it to `-xtype f` to also include symlinks to regular files.

With the zsh shell,

```
cat ./**/*(-.) > merged-file
```

Would do the same (`(-.)` achieving the equivalent of `-xtype f`) but give you a sorted list and exclude hidden files (add the `D` qualifier to bring them back). `zargs` can be used there to work around _argument list too long_ errors.

### 更改时区

今天看系统日志的时候发现时间不太对，估计应该是没设置对时区。所以就记录一下。只需要一行：

```bash
 sudo timedatectl set-timezone Asia/Shanghai
 # 如果要查看所有可用时区的话
 timedatectl list-timezones
 # 查看当前时区信息
 timedatectl
```

或者也可以用创建符号链接的方式更改：

```bash
sudo rm -rf /etc/localtime && \
sudo ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
```

### 监控硬盘状态信息

借助`smartctl`就能做到。这工具输出十分丰富，还能跑硬盘测试，这里演示下最简单的用法：

```bash
for DEVICE in "sda sdb sdc"; do
  smartctl -a $DEVICE | \
   grep 'SMART overall-health self-assessment test result'
done
```

加强版，输出报告：

```bash
#!/bin/bash
SMARTCTL="smartctl"
DEVICES="sdb sdc"

get_model() {
  DEVICE=$1
  $SMARTCTL -i $DEVICE | grep "Device Model" | awk '{print $3}'
}
check_disk() {
  DEVICE=$1
  MODEL=$(get_model $DEVICE)
  STATUS=$($SMARTCTL -a $DEVICE | grep 'SMART overall-health self-assessment test result')
  RESULT=$(echo $STATUS | awk '{print $NF}')
  if [ "$RESULT" != "PASSED" ]; then
    ALERTS="$ALERTS\n硬盘异常：$DEVICE ($MODEL)\n$STATUS\n" # 追加到变量中，用换行符分隔不同的硬盘信息
  else
    ALERTS="$ALERTS\n硬盘正常：$DEVICE ($MODEL)\n$STATUS\n" # 追加到变量中，用换行符分隔不同的硬盘信息
  fi
}

ALERTS=""
for DEV in $DEVICES; do
  check_disk /dev/$DEV
done

echo "$ALERTS"
```

### 批量压缩

基本就是个用`ls`和`awk`组装起来的工具，没啥技术含量。使用时会把目录下的所有东西压缩为以文件为名的压缩包：

```bash
ls | awk '{print "zip -r \"" $0".zip\" \""$0"\""}' | bash
```

### 图片生成

>JYY的奇妙课堂.jpg

Linux原生支持PPM图片(Portable Pixel Map)格式。它的结构很简单：

```
P6              // magic number
WIDTH HEIGHT
MAX COLOR       // number of single color, mostly be 255
...PIXELS       // pixels
```

每一个像素都是一个结构体，存储了图像的rgb信息：

```c
// A struct to represent a RGB pixel
typedef struct {
    unsigned char r, g, b;
} Pixel;
```

所以，理论上可以直接~~手写二进制~~写出一张图片，或者用C实现：

```c
#include <stdio.h>
#include <stdlib.h>

// Define the image dimensions and the maximum color value
#define WIDTH 200
#define HEIGHT 100
#define MAX_COLOR 255

// A struct to represent a RGB pixel
typedef struct {
    unsigned char r, g, b;
} Pixel;

// A function to write a PPM image to a file
void write_ppm(const char *filename, Pixel *image) {
    // Open the file for writing in binary mode
    FILE *fp = fopen(filename, "wb");
    if (!fp) {
        fprintf(stderr, "Error: cannot open file %s\n", filename);
        exit(1);
    }

    // Write the PPM header
    fprintf(fp, "P6\n"); // Magic number for binary PPM
    fprintf(fp, "%d %d\n", WIDTH, HEIGHT); // Image width and height
    fprintf(fp, "%d\n", MAX_COLOR); // Maximum color value

    // Write the pixel data
    fwrite(image, sizeof(Pixel), WIDTH * HEIGHT, fp);

    // Close the file
    fclose(fp);
}

// A function to create a gradient image
void create_gradient(Pixel *image) {
    // Loop over each pixel
    for (int y = 0; y < HEIGHT; y++) {
        for (int x = 0; x < WIDTH; x++) {
            // Compute the pixel index
            int i = y * WIDTH + x;

            // Set the pixel color based on its position
            image[i].r = x * MAX_COLOR / WIDTH; // Red component
            image[i].g = y * MAX_COLOR / HEIGHT; // Green component
            image[i].b = (x + y) * MAX_COLOR / (WIDTH + HEIGHT); // Blue component
        }
    }
}

// The main function
int main() {
    // Allocate memory for the image
    Pixel *image = malloc(sizeof(Pixel) * WIDTH * HEIGHT);
    if (!image) {
        fprintf(stderr, "Error: cannot allocate memory for the image\n");
        exit(1);
    }

    // Create the gradient image
    create_gradient(image);

    // Write the image to a file
    write_ppm("gradient.ppm", image);

    // Free the memory
    free(image);

    return 0;
}
```

完成之后，可以用`ImageMagick`的`convert gradient.ppm gradient.jpg`将图片转换成jpg格式的图片。

### rsync的使用

>好东西，比`scp`好用

```bash
# 同步多个文件/文件夹到远程服务器目录
rsync -av files-or-dirs user@remote-server:/path/to/destination/

# 如果远程服务器的ssh端口不是默认22
rsync -av -e "ssh -p PORT_NUMBER" files-or-dirs user@remote-server:/path/to/destination/
```

其中的`-a`代表archive，`-v`代表verbose。它的优点在于能够断点续传，以及增量同步。这样的特性使得它在镜像站搭建上也有重要地位。

