---
title: Linux误删文件恢复
date: 2023-08-30 02:52:00
author: xeonds
toc: true
excerpt: 希望人没事.jpg
---

>删了私有云上几百个文件，不过好在最后发现只是删除了数据库里边的记录。万幸万幸。

注意，**下面的操作只适用于删文件的进程已经挂了的情况，请根据自己情况选择合适的方法**。

## 首先要做的

赶紧杀掉所有进程，防止数据写入到磁盘覆盖`inode`，如果被覆盖基本就凉了。比如说，停止当前分区的服务，赶紧卸载当前分区设备，甚至直接断网都是有必要的。

```bash
unmount /dev/sda1
# 如果设备忙的话，用下面的命令强制卸载
fuser -m -v -i -k /dir
```

然后用`dd`备份分区，防止恢复失败。比如可以用下面的指令：

```bash
dd if=/dev/sda1 of=/tmp/sda1.img
```

## 工具准备

根据分区类型使用`extundelete`或者`ntfsundelete`。后者直接安装`ntfs-3g`即可，前者使用apt安装`extundelete`。

## 恢复

[官方文档](https://manpages.ubuntu.com/manpages/focal/en/man8/ntfsundelete.8.html)

如果是ntfs分区的话，用这个命令得到文件列表：

```bash
# 这个-f是因为我懒得卸载卷了
# 正常情况下还是先unmount了再操作，比较安全
# 这样就不用加-f了
sudo ntfsundelete -s /dev/sdc2 -f > rec-list.txt

# 或者还有下面这些指令

# Look for deleted files on /dev/hda1.
ntfsundelete /dev/hda1

# Look for deleted documents on /dev/hda1.
ntfsundelete /dev/hda1 -s -m '*.doc'

# Look for deleted files between 5000 and 6000000 bytes, with  at  least  90%  of  the  data
# recoverable, on /dev/hda1.
ntfsundelete /dev/hda1 -S 5k-6m -p 90

# Look for deleted files altered in the last two days
ntfsundelete /dev/hda1 -t 2d

```

然后可以按删除日期来筛查文件：

```bash
cat rec-list.txt | grep 2023-08-30 > res-filtered.txt
```

最后恢复文件：

```bash
# Undelete inodes 2, 5 and 100 to 131 of device /dev/sda1
ntfsundelete /dev/sda1 -u -i 2,5,100-131

# Undelete  inode number 3689, call the file 'work.doc', set it to recovered size and put it
# in the user's home directory.
ntfsundelete /dev/hda1 -u -T -i 3689 -o work.doc -d ~

# Save MFT Records 3689 to 3690 to a file 'debug'
ntfsundelete /dev/hda1 -c 3689-3690 -o debug
```