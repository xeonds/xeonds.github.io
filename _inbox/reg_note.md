---
title: Windows注册表手记
date: 2023-12-09 20:08:46
author: xeonds
toc: true
excerpt: 注册表实际上就是一个树形数据库，最初就是为了解决Windows3.0的.ini配置文件满天飞的问题而诞生的。但是，注册表的出现到底是解决了一个问题，还是带来了另一个问题？对于注册表要解决的问题，是否存在比它更好的方案？刚试着导出了下当前系统的注册表，然后我看着800多MiB的.reg文件，感到一阵胃疼
tags:
  - Windows
---
# Windows注册表系统简介

## 一、注册表存在的原因，以及历史原因，以及它的功能

注册表是Windows中的一个重要的数据库，用于存储系统和应用程序的设置信息。注册表的出现是为了解决Windows 3.0时代的配置文件（如INI文件）的问题，如：

- 配置文件分散在不同的目录和驱动器中，不便于管理和备份；
- 配置文件的格式和内容没有统一的标准，不利于程序间的数据交换和兼容性；
- 配置文件的读写效率低，影响系统的性能和稳定性；[^1^][1]

注册表的功能是：

- 提供一个统一的、结构化的、安全的、高效的方式来存储和检索系统和应用程序的配置数据；
- 提供一个可扩展的、动态的、分层的数据库，可以根据不同的Windows版本和用户需求进行调整和扩展；
- 提供一个可编程的接口，让开发者可以使用注册表API来访问和操作注册表数据；[^1^][1]

## 二、注册表的大致结构，以及工作机制

注册表的结构是一个分层的树形结构，树中的每个节点称为键，每个键可以包含子项和值。值是键的属性，包含一个值名称和一个数据项。数据项可以是不同的数据类型，如字符串、整数、二进制等。[^2^][2]

注册表的根节点有五个，分别是：

- HKEY_CLASSES_ROOT：存储文件关联和对象链接与嵌入（OLE）信息，用于确定打开某种类型的文件时要使用的应用程序；
- HKEY_CURRENT_USER：存储当前登录用户的配置信息，如桌面设置、环境变量、网络连接等；
- HKEY_LOCAL_MACHINE：存储本地计算机的配置信息，如硬件设备、系统服务、软件安装等；
- HKEY_USERS：存储所有用户的配置信息，包括默认用户和当前用户；
- HKEY_CURRENT_CONFIG：存储当前硬件配置信息，如显示器分辨率、打印机设置等；[^2^][2]

注册表的工作机制是：

- 当Windows启动时，会从磁盘上的注册表文件（如SYSTEM.DAT、USER.DAT等）中读取注册表数据，并加载到内存中，形成一个虚拟的注册表；
- 当系统或应用程序需要访问或修改注册表数据时，会通过注册表API来操作内存中的虚拟注册表；
- 当系统或应用程序对注册表数据进行修改时，会将修改的内容写入到一个事务日志文件（如USERDIFF.LOG等）中，以保证数据的一致性和完整性；
- 当系统关闭时，会将内存中的虚拟注册表和事务日志文件中的修改内容同步到磁盘上的注册表文件中，以保证数据的持久性；[^3^][3]

## 三、一般Windows系统的注册表结构以及注册表内容

一般Windows系统的注册表结构可以用注册表编辑器（regedit.exe）来查看和编辑。注册表编辑器是一个图形化的工具，可以显示注册表的树形结构，以及每个键和值的名称和数据。注册表编辑器也可以用来导入和导出注册表文件，以及搜索和替换注册表数据。[^4^][4]

注册表的内容是根据不同的Windows版本和用户需求而变化的，不可能一一列举出来。不过，一般来说，注册表的内容可以分为以下几类：

- 系统设置：包括系统的基本信息、启动选项、安全策略、服务控制、事件日志等；
- 硬件设置：包括硬件的识别、配置、资源分配、驱动程序等；
- 用户设置：包括用户的个人信息、桌面环境、网络连接、应用程序偏好等；
- 应用程序设置：包括应用程序的安装信息、版本信息、功能选项、数据源等；[^5^][5]

## 四、参考文献

[^1^][1]: 注册表 - Win32 apps | Microsoft Learn [1]
[^2^][2]: 注册表的结构 - Win32 apps | Microsoft Learn [2]
[^3^][3]: 注册表的工作原理 - Windows Server | Microsoft Learn [4]
[^4^][4]: 使用注册表编辑器 - Windows Server | Microsoft Learn [6]
[^5^][5]: 注册表内容 - Windows Server | Microsoft Learn [7]

---

[注册表系统的分层结构可以分为逻辑层和物理层两个部分。逻辑层是注册表的树形结构，由键、子键和值组成，可以通过注册表编辑器或注册表API来访问和操作。物理层是注册表的文件存储，由一组称为储巢（hive）的二进制文件组成，存放在磁盘上的不同位置，可以通过配置管理器来加载和卸载。](https://learn.microsoft.com/zh-cn/windows/win32/sysinfo/structure-of-the-registry)[1](https://learn.microsoft.com/zh-cn/windows/win32/sysinfo/structure-of-the-registry)[2](https://learn.microsoft.com/zh-cn/windows/win32/com/registry-hierarchy)

注册表的逻辑层由五个根键组成，分别是：

- HKEY_CLASSES_ROOT：存储文件关联和对象链接与嵌入（OLE）信息，用于确定打开某种类型的文件时要使用的应用程序；
- HKEY_CURRENT_USER：存储当前登录用户的配置信息，如桌面设置、环境变量、网络连接等；
- HKEY_LOCAL_MACHINE：存储本地计算机的配置信息，如硬件设备、系统服务、软件安装等；
- HKEY_USERS：存储所有用户的配置信息，包括默认用户和当前用户；
- [HKEY_CURRENT_CONFIG：存储当前硬件配置信息，如显示器分辨率、打印机设置等；](https://learn.microsoft.com/zh-cn/windows/win32/sysinfo/structure-of-the-registry)[2](https://learn.microsoft.com/zh-cn/windows/win32/com/registry-hierarchy)

[这五个根键实际上是指向储巢文件中的某些子键的别名，也称为预定义句柄。](https://learn.microsoft.com/zh-cn/windows/win32/sysinfo/structure-of-the-registry)[3](http://www.ittribalwo.com/article/422.html) [例如，HKEY_CLASSES_ROOT实际上是指向HKEY_LOCAL_MACHINE\Software\Classes的别名，HKEY_CURRENT_USER实际上是指向HKEY_USERS<SID>的别名，其中<SID>是当前用户的安全标识符。](https://learn.microsoft.com/zh-cn/windows/win32/sysinfo/structure-of-the-registry)[4](https://blog.csdn.net/jyl_sh/article/details/118467887)

注册表的物理层由以下几个储巢文件组成，分别存放在不同的位置：

- SAM：存储安全账户管理器（SAM）的信息，如用户账户、密码、组等，位于%SystemRoot%\System32\Config目录下；
- SECURITY：存储本地安全策略的信息，如访问控制列表（ACL）、审计策略等，位于%SystemRoot%\System32\Config目录下；
- SOFTWARE：存储本地计算机的软件相关的信息，如已安装的软件、应用程序设置等，位于%SystemRoot%\System32\Config目录下；
- SYSTEM：存储本地计算机的系统相关的信息，如设备驱动、服务、环境变量等，位于%SystemRoot%\System32\Config目录下；
- DEFAULT：存储默认用户配置的信息，如桌面设置、壁纸等，位于%SystemRoot%\System32\Config目录下；
- NTUSER.DAT：存储每个用户配置的信息，如桌面设置、网络连接等，位于每个用户的个人文件夹下，如%UserProfile%\NTUSER.DAT；
- [USRCLASS.DAT：存储每个用户的类注册表的信息，如文件关联、COM对象等，位于每个用户的本地设置文件夹下，如%UserProfile%\Local Settings\Application Data\Microsoft\Windows\USRCLASS.DAT；](https://learn.microsoft.com/zh-cn/windows/win32/sysinfo/structure-of-the-registry)[5](https://www.zhihu.com/question/19831849)[6](https://www.zhihu.com/question/26898861)

[这些储巢文件的内部结构是由配置管理器维护的，一般不需要用户直接访问或修改。配置管理器会在系统启动时加载这些储巢文件到内存中，并在系统关闭时将内存中的修改同步到磁盘上的文件中。配置管理器还会在系统运行时定期将修改写入到一个事务日志文件中，以保证数据的一致性和完整性。](https://learn.microsoft.com/zh-cn/windows/win32/sysinfo/structure-of-the-registry)[7](https://bbs.csdn.net/topics/20065266)

注册表的出现是为了解决Windows 3.0时代的配置文件（如INI文件）的问题，如：

- 配置文件分散在不同的目录和驱动器中，不便于管理和备份；
- 配置文件的格式和内容没有统一的标准，不利于程序间的数据交换和兼容性；
- 配置文件的读写效率低，影响系统的性能和稳定性；

注册表的优点是：

- 提供一个统一的、结构化的、安全的、高效的方式来存储和检索系统和应用程序的配置数据；
- 提供一个可扩展的、动态的、分层的数据库，可以根据不同的Windows版本和用户需求进行调整和扩展；
- 提供一个可编程的接口，让开发者可以使用注册表API来访问和操作注册表数据；

注册表的缺点是：

- 容易受到恶意软件或不良软件的破坏或污染，导致系统或应用程序出现故障或异常；
- 容易出现冗余或无效的数据，导致注册表膨胀或混乱，影响系统或应用程序的运行效率或稳定性；
- 不易于人工阅读或编辑，需要借助专门的工具或知识，而且一旦操作不当，可能造成严重的后果；

综上所述，注册表的出现是为了解决一些实际的问题，也带来了一些新的问题。它的好坏是相对的，没有绝对的标准。不同的人可能有不同的看法和评价。

[](https://learn.microsoft.com/zh-cn/windows/win32/sysinfo/structure-of-the-registry)[1](https://learn.microsoft.com/zh-cn/windows/win32/sysinfo/structure-of-the-registry): [](https://learn.microsoft.com/zh-cn/windows/win32/sysinfo/structure-of-the-registry)[2](https://learn.microsoft.com/zh-cn/windows/win32/com/registry-hierarchy): [](https://learn.microsoft.com/zh-cn/windows/win32/sysinfo/structure-of-the-registry)[3](http://www.ittribalwo.com/article/422.html)[: 注册表的根键 - Win32 apps | Microsoft Learn](https://blog.csdn.net/jyl_sh/article/details/118467887) [4](https://blog.csdn.net/jyl_sh/article/details/118467887)[: 注册表的别名 - Win32 apps | Microsoft Learn](https://www.zhihu.com/question/19831849) [5](https://www.zhihu.com/question/19831849)[: 注册表的物理结构 - Win32 apps | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/win32/sysinfo/structure-of-the-registry) [6](https://www.zhihu.com/question/26898861)[: 注册表的文件 - Win32 apps | Microsoft Learn](https://bbs.csdn.net/topics/20065266) [7](https://bbs.csdn.net/topics/20065266): : : :