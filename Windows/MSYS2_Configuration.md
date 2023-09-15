# MSYS2 Configuration

### 下载

**官网地址：https://www.msys2.org/**

官网安装步骤：

1. 下载安装程序`msys-x86_64-xxxx.exe`

2. 运行安装程序。MSYS2 需要 64 位 Windows 8.1 或更高版本

3.  输入所需的**安装文件夹**（NTFS 卷上的短 ASCII 路径、无重音符号、无空格、无符号链接、无子目录或网络驱动器、无 FAT） 

4.  完成后，单击**“完成”**

5.  [现在 MSYS2 已为您准备就绪，并且UCRT64 环境](https://www.msys2.org/docs/environments/)的终端将启动

6. 您可能需要安装一些工具（例如 mingw-w64 GCC）来开始编译项目。运行以下命令：

   ```
   pacman -S mingw-w64-ucrt-x86_64-gcc
   ```

7. 终端窗口将显示如下输出。按“Enter”继续：

   ```
   resolving dependencies...
   looking for conflicting packages...
   
   Packages (15) mingw-w64-ucrt-x86_64-binutils-2.39-2
               mingw-w64-ucrt-x86_64-crt-git-10.0.0.r68.g6eb571448-1
               mingw-w64-ucrt-x86_64-gcc-libs-12.2.0-1  mingw-w64-ucrt-x86_64-gmp-6.2.1-3
               mingw-w64-ucrt-x86_64-headers-git-10.0.0.r68.g6eb571448-1
               mingw-w64-ucrt-x86_64-isl-0.25-1  mingw-w64-ucrt-x86_64-libiconv-1.17-1
               mingw-w64-ucrt-x86_64-libwinpthread-git-10.0.0.r68.g6eb571448-1
               mingw-w64-ucrt-x86_64-mpc-1.2.1-1  mingw-w64-ucrt-x86_64-mpfr-4.1.0.p13-1
               mingw-w64-ucrt-x86_64-windows-default-manifest-6.4-4
               mingw-w64-ucrt-x86_64-winpthreads-git-10.0.0.r68.g6eb571448-1
               mingw-w64-ucrt-x86_64-zlib-1.2.12-1  mingw-w64-ucrt-x86_64-zstd-1.5.2-2
               mingw-w64-ucrt-x86_64-gcc-12.2.0-1
   
   Total Installed Size:  397.59 MiB
   
   :: Proceed with installation? [Y/n]
   [... downloading and installation continues ...]
   ```

8. 现在您可以调用`gcc`来构建 Windows 软件。

   ```
   $ gcc --version
   gcc.exe (Rev1, Built by MSYS2 project) 12.2.0
   ```

### 环境搭建

可以使用查看可以安装的包

```
pacman -S
```

1.  打开后执行命令更新系统核心 

```
pacman -Syu
```

2.  查看可以安装的gcc版本 

```
pacman -Sl | grep gcc
```

3.  安装gcc, 执行下面的命令安装与MinGW-w64-i686匹配的gcc 命令：


```
pacman -S mingw-w64-i686-arm-none-eabi-gcc mingw-w64-i686-gcc
```

4. 查看可以安装的make版本

```
pacman -Sl | grep make
```

5. 安装make, 执行下面的命令安装与MinGW-w64-i686匹配的make和cmake 命令:

```
pacman -S mingw-w64-i686-cmake mingw-w64-i686-make make cmake
```

6. 安装git vim cscosp

```
pacman -S git vim cscope
```


### 遇到问题

#### 1. 在启动了MSYS2 MINGW64时运行gcc --version提示找不到指令

还需要下载MinGW64-w64的编译器

```
输入一下指令：
pacman -S mingw-w64-x86_64-toolchain
或者
pacman -S mingw-w64-i686-toolchain
会看到一个列表让你选择，选择 gcc，gdb，make 这三个就可以了
命令直接写
pacman -S mingw-w64-x86_64-gcc mingw-w64-x86_64-gdb mingw-w64-x86_64-make
```

下载安装好之后会在安装目录下`C:\msys64\mingw64\bin`看到gcc等exe文件

一些解决方案中还推荐将MinGW64-w64的路径添加到msys2的运行环境汇中：

```
进入 msys2 用户目录编辑~/.bashrc文件加入
export PATH=$PATH:/mingw64/bin/
```

最后输入`gcc --version`能看到版本号就正常了

当然或许可以使用这条命令编译：

```
make all
```

