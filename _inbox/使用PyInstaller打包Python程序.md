---
title: 使用PyInstaller打包Python程序
date: 2023-05-31 17:11:16
author: xeonds
toc: true
excerpt: PyInstaller确实挺好用
---

pyinstaller是一个用于将python代码转换为可执行文件的工具，它可以让你在没有安装python环境的电脑上运行你的程序。pyinstaller支持多种操作系统，包括Windows，Linux和Mac OS。在本文中，我将介绍如何使用pyinstaller打包一个简单的python项目，并解决一些常见的问题。

## 步骤一：安装pyinstaller

要使用pyinstaller，你首先需要安装它。你可以使用pip命令来安装pyinstaller，如下所示：

```bash
pip install pyinstaller
```

如果你使用的是Anaconda或者其他的python发行版，你可能需要在命令前加上`conda run`或者`python -m`，例如：

```bash
conda run pip install pyinstaller
```

或者

```bash
python -m pip install pyinstaller
```

安装完成后，你可以使用`pyinstaller --version`命令来检查是否安装成功。

## 步骤二：编写一个简单的python程序

为了演示如何使用pyinstaller打包python项目，我们先编写一个简单的python程序，它只是在控制台输出一句话。我们将这个程序命名为`hello.py`，并保存在一个名为`hello`的文件夹中。代码如下：

```python
print("Hello, world!")
```

## 步骤三：使用pyinstaller打包程序

接下来，我们使用pyinstaller来打包我们的程序。打开命令行窗口，并切换到我们的项目文件夹`hello`中。然后，输入以下命令：

```bash
pyinstaller hello.py
```

这个命令会在当前文件夹中生成两个新的文件夹：`build`和`dist`。`build`文件夹中存放了打包过程中生成的临时文件，我们不需要关心它。`dist`文件夹中存放了我们的可执行文件，以及一些依赖的库文件。我们可以进入`dist\hello`文件夹中，双击运行`hello.exe`文件，就可以看到控制台输出了“Hello, world!”。

## 步骤四：优化打包结果

我们已经成功地使用pyinstaller打包了我们的程序，但是我们会发现，我们的可执行文件有很多依赖的库文件，这使得我们的程序占用了很多空间，并且不方便分发和运行。为了优化我们的打包结果，我们可以使用一些参数来控制pyinstaller的行为。以下是一些常用的参数：

- `-F`或者`--onefile`：这个参数会让pyinstaller将所有的依赖文件打包成一个单独的可执行文件，这样就可以减少文件数量和空间占用，并且方便分发和运行。
- `-w`或者`--windowed`：这个参数会让pyinstaller将程序打包成一个没有控制台窗口的图形界面程序，这样就可以避免出现黑色的控制台窗口，并且提高用户体验。
- `-i <icon_file>`或者`--icon=<icon_file>`：这个参数会让pyinstaller将指定的图标文件作为可执行文件的图标，这样就可以自定义程序的外观，并且增加识别度。
- `--name=<name>`：这个参数会让pyinstaller将指定的名称作为可执行文件的名称，而不是默认使用源代码文件的名称。

例如，如果我们想要将我们的程序打包成一个单独的图形界面程序，并且使用自定义的图标和名称，我们可以输入以下命令：

```bash
pyinstaller -F -w -i hello.ico --name Hello hello.py
```

这个命令会在`dist`文件夹中生成一个名为`Hello.exe`的可执行文件，并且使用了我们指定的图标。我们可以双击运行它，就可以看到没有控制台窗口，并且输出了“Hello, world!”。

## 常见问题及解决方法

在使用pyinstaller打包python项目时，可能会遇到一些问题和错误。以下是一些常见问题及解决方法：

- 问题：打包后运行程序时出现错误提示“Failed to execute script xxx”。
- 解决方法：这个问题可能是由于缺少某些依赖库或者模块导致的。我们可以使用以下命令来查看错误日志：

```bash
hello.exe --debug all
```

然后根据日志中提示的缺少哪些库或者模块，我们可以使用以下参数来手动指定它们：

- `--hidden-import=<module_name>`：这个参数会让pyinstaller强制导入指定的模块，即使它们没有被源代码显式导入。
- `--add-data <src;dest>`：这个参数会让pyinstaller将指定的数据文件或者目录复制到可执行文件所在目录中，并且保持相对路径不变。
- `--add-binary <src;dest>`：这个参数会让pyinstaller将指定的二进制文件或者目录复制到可执行文件所在目录中，并且保持相对路径不变。

例如，如果我们发现缺少了numpy模块和data目录，我们可以输入以下命令：

```bash
pyinstaller --hidden-import numpy --add-data data;. hello.py
```

- 问题：打包后运行程序时出现错误提示“ImportError: DLL load failed while importing xxx”。
- 解决方法：这个问题可能是由于某些DLL文件没有被正确地复制或者加载导致的。我们可以尝试以下方法来解决：

  - 确保安装了最新版本的Microsoft Visual C++ Redistributable Package。
  - 确保源代码中没有使用相对路径来导入模块或者加载数据。
  - 确保源代码中没有使用os.environ['PATH']来修改环境变量。
  - 使用以下参数来手动指定DLL文件或者目录：

    - `--paths <path>`：这个参数会让pyinstaller在寻找模块和DLL时添加指定的路径。
    - `--add-binary <src;dest>`：这个参数会让pyinstaller将指定的二进制文件或者目录复制到可执行文件所在目录中，并且保持相对路径不变。

    例如，如果我们发现缺少了libzmq.dll文件，并且它位于C:\Python\Lib\site-packages\zmq目录下，我们可以输入以下命令：

    ```bash
    pyinstaller --paths C:\Python\Lib\site-packages\zmq --add-binary C:\Python\Lib\site-packages\zmq\libzmq.dll;. hello.py
    ```