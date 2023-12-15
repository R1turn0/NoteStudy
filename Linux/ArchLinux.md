文章摘要自https://zhuanlan.zhihu.com/p/596227524

# Arch Linux 详细安装教程，萌新再也不怕了！「2023.10」

目录

Arch Linux 是一个轻量、灵活、滚动更新的 Linux 发行版，适合有时间、有兴趣、热爱自由的读者。由于 Arch Linux 仅提供了一个很简洁的安装环境，用户有极大的空间根据自己的喜好进行安装和配置，因此初学者往往感到难以适应。本文将详细地介绍一个通用的安装过程，尽可能遵循 [ArchWiki 安装指南](https://link.zhihu.com/?target=https%3A//wiki.archlinux.org/title/Installation_guide)。本文介绍了虚拟机安装、Windows 与 Arch Linux 双系统安装和全新安装 Arch Linux 三种方式。希望能帮助初学者顺利进入 Arch Linux 的世界。

本教程要求您

- 拥有一台以 UEFI 模式启动的 x86_64 架构电脑，目前运行 Windows 8 及以上操作系统（只要您的电脑预装了 Windows 8 及以上系统，就符合上述要求[[1\]](https://zhuanlan.zhihu.com/p/596227524#ref_1)）
- 准备一个 U 盘，将 U 盘文件全部备份到电脑中
- 备份好电脑中全部资料，防止安装过程中误删分区（您可以在不经常使用的电脑上安装，**更推荐第一次安装的读者在虚拟机中尝试**）
- 对 Linux 有一定了解，最好使用过 Ubuntu、Linux Mint 或 Deepin 等新手友好的发行版
- 有一定英语水平，可以大致读懂 ArchWiki，以便遇到问题时查看

如果在安装过程中遇到问题，可以从如下途径获得帮助

- [ArchWiki 安装指南](https://link.zhihu.com/?target=https%3A//wiki.archlinux.org/title/Installation_guide)
- 搜索引擎
- [Arch Linux 论坛](https://link.zhihu.com/?target=https%3A//bbs.archlinux.org/)
- [Arch Linux 中文论坛](https://link.zhihu.com/?target=https%3A//bbs.archlinuxcn.org/) 及 [Arch Linux 中文社区交流群](https://link.zhihu.com/?target=https%3A//www.archlinuxcn.org/archlinuxcn-group-mailling-list/)
- 本文评论区

[TOC]



## 1. 获取安装镜像

安装镜像是我们安装 Arch Linux 的工具，其中包含了一个 Arch Linux live 系统。该系统功能十分强大，不仅可以用于安装系统，也可用于抢救系统。要查看安装镜像中包含的软件包，请前往 [pkglist.x86_64.txt](https://link.zhihu.com/?target=https%3A//geo.mirror.pkgbuild.com/iso/latest/arch/pkglist.x86_64.txt)。

请在 [Arch Linux 下载页](https://link.zhihu.com/?target=https%3A//archlinux.org/download/) 中选择一种下载方式，下载如下文件

```text
archlinux-2023.10.14-x86_64.iso
```

该文件每月更新一次，一般是每月 1 日更新。请确保您下载的是最新的文件。

您可以选择通过 BT 种子下载，也可以在镜像站下载。在所有镜像站中，笔者推荐前往 [北京外国语大学开源软件镜像站](https://link.zhihu.com/?target=https%3A//mirrors.bfsu.edu.cn/archlinux/iso/latest/)下载上述文件。如果您身在国外，笔者推荐前往 [pkgbuild.com](https://link.zhihu.com/?target=https%3A//geo.mirror.pkgbuild.com/iso/latest/) 进行下载。

您可以使用笔者推荐的 aria2 下载工具，使用教程在这里。

[会心：速度比肩迅雷，支持百度云盘！开源免费下载神器 aria2 使用教程18 赞同 · 11 评论文章](https://zhuanlan.zhihu.com/p/621315479)

截至本文最后一次更新，最新的北外镜像站 Arch Linux live ISO 下载链接是

[https://mirrors.bfsu.edu.cn/archlinux/iso/latest/archlinux-2023.10.14-x86_64.iso](https://link.zhihu.com/?target=https%3A//mirrors.bfsu.edu.cn/archlinux/iso/latest/archlinux-2023.10.14-x86_64.iso)

## 2. 验证镜像

为确保下载的文件没有损坏，需要计算文件的 SHA256 值。

在 Windows 系统中，打开镜像所在文件夹。按住 `SHIFT` 键的同时右键空白处，点击“在此处打开 PowerShell 窗口”。在打开的 PowerShell 窗口中，输入

```text
certutil -hashfile .\archlinux-2023.xx.xx-x86_64.iso SHA256  #请将 2023.xx.xx 替换为镜像名中的日期
```

请在 [Arch Linux 下载页](https://link.zhihu.com/?target=https%3A//archlinux.org/download/) 中找到 Checksums 部分，对照其中的 SHA256 值（或者参考下面列出的文件信息）。如果和上述命令输出的值相同，说明文件没有损坏；如果不同，请重新下载。

截至本文最后一次更新，最新的文件信息是

```text
archlinux-2023.10.14-x86_64.iso
SHA256: 292269ba9bf8335b6a885921a00d311cdc1dcbe9a1375f297f7f3ecfe31c36a7
```

## 3. 准备安装介质

笔者推荐使用 U 盘作为安装介质，制作工具是 [Ventoy](https://link.zhihu.com/?target=https%3A//www.ventoy.net/)。Ventoy 是一个制作可启动 U 盘的开源工具。有了它就可以无需反复格式化 U 盘，只需将镜像文件复制到 U 盘中就可以启动它。

请按如下步骤制作安装盘。在 Windows 系统中，在 [Ventoy 下载页](https://link.zhihu.com/?target=https%3A//www.ventoy.net/cn/download.html) 下载如下文件，并校验 SHA256 值。

```text
ventoy-1.0.xx-windows.zip
```

在下载页面中直接点击文件名将会跳转到 GitHub，而 GitHub 在国内访问不够稳定。如果无法下载，请遵循以下说明，选择镜像站或网盘下载

> **说明：**本网站服务器的带宽配置很低，请到以下任一位置下载 Ventoy。（**下载后注意检查 SHA-256 校验值**）
> \1. [https://github.com/ventoy/Ventoy/releases](https://link.zhihu.com/?target=https%3A//github.com/ventoy/Ventoy/releases)
> \2. [https://gitee.com/longpanda/Ventoy/releases/](https://link.zhihu.com/?target=https%3A//gitee.com/longpanda/Ventoy/releases/)
> \3. [https://mirrors.nju.edu.cn/github-release/ventoy/Ventoy](https://link.zhihu.com/?target=https%3A//mirrors.nju.edu.cn/github-release/ventoy/Ventoy)（南京大学镜像站）
> \4. [https://mirrors.sdu.edu.cn/github-release/ventoy_Ventoy](https://link.zhihu.com/?target=https%3A//mirrors.sdu.edu.cn/github-release/ventoy_Ventoy)（山东大学镜像站）
> \5. [https://www.lanzoui.com/b01bd54gb](https://link.zhihu.com/?target=https%3A//www.lanzoui.com/b01bd54gb)（蓝奏云）
> \6. [https://www.123pan.com/s/rjSKVv-8YtN](https://link.zhihu.com/?target=https%3A//www.123pan.com/s/rjSKVv-8YtN) 提取码: vtoy（123云盘）
> \7. [https://pan.baidu.com/s/1UzHMzn6SToxHRYw7HR16_w](https://link.zhihu.com/?target=https%3A//pan.baidu.com/s/1UzHMzn6SToxHRYw7HR16_w) 提取码: vtoy（百度网盘）

请解压缩上述文件，插入您的 U 盘（**安装过程将清空 U 盘全部内容，请务必提前备份**），然后运行

```text
Ventoy2Disk.exe
```

选择您的 U 盘，点击安装。安装完毕后，**将 Arch Linux 安装镜像复制到 U 盘中**即可。

制作完成后，U 盘可正常使用，可以把备份的文件复制回原来的位置。

## 4. 虚拟机安装前的准备

虚拟机可以通过软件模拟一个具有完整硬件功能的隔离的计算机系统。在虚拟机内安装系统不会影响到实体机。即使出现失误，也只需销毁虚拟机重新安装，非常适合初学者学习。笔者推荐使用开源的 VirtualBox 虚拟机。

### 4.1 开启硬件虚拟化功能

使用虚拟机需要 CPU 的支持，需要开启硬件虚拟化功能。

首先，我们进入 BIOS。您可以在启动电脑的过程中通过按 BIOS 启动快捷键进入。具体的快捷键与电脑品牌和型号有关，可以在搜索引擎中查找。如果您不知道快捷键，请使用如下方法[[2\]](https://zhuanlan.zhihu.com/p/596227524#ref_2)。

在 Windows 系统中，点击“开始”菜单，点击“设置”按钮，进入设置页面。点击“更新和安全”，在左侧点击“恢复”选项卡，在右侧点击“高级启动”栏目下的“立即重新启动”按钮。重新启动后，点击“疑难解答”，再点击“高级选项”，最后点击“UEFI 固件设置”，点击“重启”即可。

然后，我们开启虚拟化功能。不同品牌的电脑的 BIOS 页面相差较大，进入之后，您可以找到“虚拟化”项目，将其设置为开启。

最后，在 BIOS 中选择保存并重启，即可。

### 4.2 安装和配置 VirtualBox

请参考下面的教程，安装 VirtualBox，并做好配置。

[虚拟机安装前的准备 | archlinux 简明指南arch.icekylin.online/rookie/pre-virt.html](https://link.zhihu.com/?target=https%3A//arch.icekylin.online/rookie/pre-virt.html)

注：

1. VirtualBox 官方网站 [https://www.virtualbox.org/](https://link.zhihu.com/?target=https%3A//www.virtualbox.org/)
2. 笔者将写作一篇文章，介绍在虚拟机中安装 Arch Linux 之前的准备，敬请期待。

## 5. 双系统安装前的必要配置

如果您希望即将安装的 Arch Linux 与已有的 Windows 共存，请继续阅读；如果您希望只保留新安装的 Arch Linux，删除现有的 Windows 系统，请跳过此步。

### 5.1 磁盘分区

请按照下列教程，压缩磁盘空间用于 Arch Linux 安装（保持空闲状态，不用分区）。推荐保留 100GiB 的空间，至少 50GiB。如果您有两块硬盘，请在固态硬盘中压缩出至少 30GiB 空间，机械硬盘中尽可能多的压缩空间。

[【磁盘分区教程】如何给电脑进行分区？59 赞同 · 8 评论文章![img](https://picx.zhimg.com/v2-c6fd93b7c974b07f8a63ab98d5a6771e_r.jpg?source=172ae18b)](https://zhuanlan.zhihu.com/p/145420256)

### 5.2 关闭安全启动

由于预装 Windows 的电脑默认开启安全启动，但是 Arch Linux 默认不支持安全启动，因此我们需要提前关闭该功能。关闭后，Bitlocker 功能将无法使用，请提前关闭该功能[[3\]](https://zhuanlan.zhihu.com/p/596227524#ref_3)。

首先，我们进入 BIOS。您可以在启动电脑的过程中通过按相应快捷键进入 BIOS，具体的快捷键可以在搜索引擎中查找。如果您不知道快捷键，请使用如下方法[[4\]](https://zhuanlan.zhihu.com/p/596227524#ref_4)。

在 Windows 系统中，点击“开始”菜单，点击“设置”按钮，进入设置页面。点击“更新和安全”，在左侧点击“恢复”选项卡，在右侧点击“高级启动”栏目下的“立即重新启动”按钮。重新启动后，点击“疑难解答”，再点击“高级选项”，最后点击“UEFI 固件设置”，点击“重启”即可。

然后，我们关闭安全启动。不同品牌的电脑的 BIOS 页面相差较大，进入之后，您可以在“设置”或“安全”选项卡下找到“安全启动（Secure Boot）”项目，将其设置为关闭（Disabled）。

最后，在 BIOS 中选择保存并重启，即可。

### 5.3 关闭休眠

Windows 默认启动“快速启动”功能，该功能影响 Arch Linux 的使用，可能导致磁盘文件丢失，我们需要将其关闭。为了彻底关闭该功能，本教程将休眠功能也一起关闭。

右键“开始”菜单，点击“Windows Powershell（管理员）”，打开管理员权限的 Powershell 窗口。输入下列命令，按下 `Enter` 键即可[[5\]](https://zhuanlan.zhihu.com/p/596227524#ref_5)。

```text
powercfg -h off
```

### 5.4 时间设置

Windows 使用本地时间作为硬件时间，我们将其改为 UTC 时间，与 Arch Linux 统一[[6\]](https://zhuanlan.zhihu.com/p/596227524#ref_6)。

右键“开始”菜单，点击“Windows Powershell（管理员）”，打开管理员权限的 Powershell 窗口。输入下列命令，按下 `Enter` 键。

```text
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /d 1 /t REG_DWORD /f
```

随后等待 Windows 自动校准时间。

如果您需要更多功能，包括在两个系统中使用蓝牙连接同一个设备[[7\]](https://zhuanlan.zhihu.com/p/596227524#ref_7)等，[请查看 ArchWiki](https://link.zhihu.com/?target=https%3A//wiki.archlinux.org/title/Dual_boot_with_Windows)，进行进一步设置。

## 6. 启动安装环境

安装工具制作完成，现在可以启动安装环境，开始安装了。

请参考下列文章找到您电脑的启动快捷键。插好 U 盘，重启电脑，连续按该按键，直到出现启动列表，选择您的 U 盘。

[各品牌主板、笔记本、台式机启动快捷键blog.csdn.net/qq_38711818/article/details/116161146](https://link.zhihu.com/?target=https%3A//blog.csdn.net/qq_38711818/article/details/116161146)

在弹出的 Ventoy 界面中，选择您刚刚下载的镜像名称项，再选择“Boot in normal mode”。

在随后弹出的 GRUB 引导界面中，选择第一项

```text
Arch Linux install medium (x86_64, UEFI)
```

耐心等待启动过程，如果屏幕出现如下字符，说明安装环境启动成功。

```text
Arch Linux 6.x.x-arch1-1 (tty1)

archiso login: root (automatic login)

To install Arch Linux follow the installation guide:
https://wiki.archlinux.org/title/Installation_guide

...
```

从现在开始，安装过程将在终端中进行。请做好准备，耐心而谨慎地键入命令。只要您按照指导一步步完成，就能走到最后的终点。

## 7. 设置终端键盘布局和字体

### 7.1 Linux 命令简介

在安装之前需要先介绍一下 Linux 命令的语法。**最简单的 Linux 命令由命令、选项和参数组成。**一个命令就像一个祈使句，由谓语、状语和宾语组成，只不过语序有所变化，而且选项要前面用“-”标注。我们以祈使句“快速地吃米饭”举一个例子。在这个句子中，谓语是“吃”，状语是“快速地”，宾语是“米饭”。把这个句子写成命令的形式就是这样的

```text
吃 -快速地 米饭
```

我们列个表格以便展示二者的对应关系：

| 命令 | -选项   | 参数 |
| ---- | ------- | ---- |
| 谓语 | -状语   | 宾语 |
| 吃   | -快速地 | 米饭 |

请记住下列语法，更多的知识[请参阅鸟哥私房菜](https://link.zhihu.com/?target=https%3A//linux.vbird.org/linux_basic/centos7/0160startlinux.php%23cmd_cmd)。

```text
命令 -选项 参数
```

### 7.2 设置终端键盘布局

默认键盘布局是美式键盘，您可以使用如下命令列出可用的键盘布局。

```text
# ls /usr/share/kbd/keymaps/**/*.map.gz
```

`ls` 可能是 Linux 中最常用的命令。关于 Linux 常用命令的学习，[请参阅鸟哥私房菜](https://link.zhihu.com/?target=https%3A//linux.vbird.org/linux_basic/centos7/)。

您可以使用 loadkeys 命令[[8\]](https://zhuanlan.zhihu.com/p/596227524#ref_8)设置键盘布局。例如，如下命令将键盘布局设置为 Dvorak 布局。

```text
root@archiso ~ # loadkeys dvorak
```

### 7.3 设置终端字体

如果您的屏幕分辨率较高，您会发现终端显示字体较小。这时需要设置终端字体，把字号调大。我们使用 setfont 命令[[9\]](https://zhuanlan.zhihu.com/p/596227524#ref_9)设置。这个命令没有选项，只需要输入命令和参数，如

```text
setfont 字体名
```

分辨率为 1080p 的屏幕，建议选择字体 ter-122b，分辨率更高的屏幕，可以在 ter-124b，ter-128b，ter-132b 中选择一个，例如

```text
root@archiso ~ # setfont ter-132b
```

**建议您记住刚刚选择的字体，配置系统时会用到。**

## 8. 验证启动模式

本文开始时提到，您的电脑必须在 UEFI 模式下启动，现在验证您的启动模式。

请输入如下命令（**注意：使用`Tab`键可以自动补全**）

```text
root@archiso ~ # cat /sys/firmware/efi/fw_platform_size
```

如果返回 64，那么系统以 UEFI 模式启动，并且有 64 位 UEFI。如果返回 32，那么系统以 UEFI 模式启动，但是只能使用 GRUB 作为引导加载程序。如果这个文件不存在，系统可能以 BIOS 模式启动。

处于 BIOS 启动模式的读者，可以自行进入 BIOS 页面更改启动模式。如果无法更改，说明您的电脑过于老旧，本文无法指导您继续安装。请您参考其他教程，例如

[以官方Wiki的方式安装ArchLinuxwww.viseator.com/2017/05/17/arch_install/![img](https://pic3.zhimg.com/v2-b6ecf8ca25f7a237fe262a4f66a4fcbe_ipico.jpg)](https://link.zhihu.com/?target=https%3A//www.viseator.com/2017/05/17/arch_install/)

## 9. 连接互联网

Arch Linux 镜像只提供一个基本的安装环境，软件包仍需要连接互联网后下载。连接互联网有多种方式，包括

- 有线连接
- WiFi 连接
- 手机 USB 网络共享（仅限 Android 手机）

笔者建议读者**优先使用有线连接和手机 USB 网络共享**的方式连接互联网。

连接互联网的步骤如下：

- 检查确保网络接口已经启用。

```text
root@archiso ~ # ip link
```

您应该在输出中看到 enp0s3 或 wlan0 之类的字样，这就是您的网络接口名称，例如

```text
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master br0 state DOWN mode DEFAULT qlen 1000 ...
```

尖括号内的“UP”，表示接口已经启用。如果没有出现“UP”，使用如下命令启用该接口[[10\]](https://zhuanlan.zhihu.com/p/596227524#ref_10)。

```text
root@archiso ~ # ip link set 网络接口 up  # 请将“网络接口”替换成您的网络接口名称，如“enp0s3”或“wlan0”
```

- 使用无线连接的读者，使用 rfkill 命令确认无线网卡没有被屏蔽。

```text
root@archiso ~ # rfkill
---------------------------------------
ID TYPE      DEVICE      SOFT      HARD
 0 bluetooth hci0   unblocked unblocked
 1 wlan      phy0   unblocked unblocked
```

如果无线网卡被硬件屏蔽，请使用硬件开关启用它；如果被软件屏蔽，请输入如下命令启用它。

```text
root@archiso ~ # rfkill unblock wlan
```

- 选择有线连接的读者，只需要将网线插到电脑相应接口即可连接。选择手机 USB 网络共享的读者，将手机和电脑用数据线连接，然后在手机通知栏中选择“USB网络共享”即可连接。以下详细介绍连接 WiFi 的方法。
- 请使用 iwctl 命令[[11\]](https://zhuanlan.zhihu.com/p/596227524#ref_11)连接互联网，如下

```text
root@archiso ~ # iwctl
NetworkConfigurationEnabled: disabled
StateDirectory: /var/lib/iwd
Version: 2.x
[iwd]#
```

如果您看到上述输出，说明您已经进入了 iwd 程序环境。这时读者可能会觉得陌生，因为通常的命令下达后会直接输出结果，并返回命令提示符，等待下一个命令的输入。而这个命令不同，下达之后**进入了程序环境，用户只能与该程序交互**，这一点请初学者牢记。关于程序工作环境的更多例子，[请参阅鸟哥私房菜](https://link.zhihu.com/?target=https%3A//linux.vbird.org/linux_basic/centos7/0160startlinux.php%23bc)。**若想退出 iwd 程序环境，只需要输入 quit 即可。**

请继续输入命令

```text
[iwd]# device list
                       Devices
------------------------------------------------------
Name   Address            Powered  Adapter  Mode
------------------------------------------------------
wlan0  xx:xx:xx:xx:xx:xx  on       phy0     station
```

请记住上述输出的设备名称（在 Name 下面），这里以 wlan0 为例，**请将 wlan0 替换成您的设备名称**。

继续输入命令

```text
[iwd]# station wlan0 scan  # 扫描网络，请将 wlan0 换成您的设备名称
[iwd]# station wlan0 get-networks  # 输出扫描结果，请将 wlan0 换成您的设备名称
         Available Networks
------------------------------------
Network name    Security    Signal
------------------------------------
mySSID          psk         ****
```

请记住您的网络名称（在 Network name 下面），这里以 mySSID 为例，**请将 mySSID 换成您的网络名称**。

继续输入命令

```text
[iwd]# station wlan0 connect "mySSID"  # 连接网络，请将 wlan0 换成您的设备名称，mySSID 换成您的网络名称
Type the network passphrase for mySSID psk.
Passphrase: ********  # 输入密码
[iwd]# quit  # 退出 iwd 程序环境
```

- 这时您应该已经连接上互联网了，请使用 `ping` 命令测试网络（使用 `Ctrl+C` 中止命令）。

```text
root@archiso ~ # ping archlinux.org
PING archlinux.org (95.217.163.246) 56(84) bytes of data.
64 bytes from archlinux.org (95.217.163.246): icmp_seq=1 ttl=47 time=201 ms
64 bytes from archlinux.org (95.217.163.246): icmp_seq=2 ttl=47 time=218 ms
64 bytes from archlinux.org (95.217.163.246): icmp_seq=3 ttl=47 time=194 ms
^C  # 使用 Ctrl+C 中止命令
--- archlinux.org ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2001 ms
rtt min/avg/max/mdev = 194.013/204.384/217.666/9.873 ms
```

如果出现上述结果，说明网络连接成功。如果无法连接 WiFi，请按照 [ArchWiki](https://link.zhihu.com/?target=https%3A//wiki.archlinux.org/title/Network_configuration%23Check_the_connection) 检查互联网连接。由于驱动不匹配，有些电脑可能无法连接 WiFi，**只能使用有线连接或手机 USB 网络共享**。

> 若要排查网络连接问题，请先确保你满足了以下要求。
> \1. 你的网络接口可见并已启用。否则请检查设备驱动－请查阅 [网络配置/以太网 - Arch Linux 中文维基](https://link.zhihu.com/?target=https%3A//wiki.archlinuxcn.org/wiki/%E7%BD%91%E7%BB%9C%E9%85%8D%E7%BD%AE/%E4%BB%A5%E5%A4%AA%E7%BD%91%23Device_driver) 或 [网络配置/无线网络配置 - Arch Linux 中文维基](https://link.zhihu.com/?target=https%3A//wiki.archlinuxcn.org/wiki/%E7%BD%91%E7%BB%9C%E9%85%8D%E7%BD%AE/%E6%97%A0%E7%BA%BF%E7%BD%91%E7%BB%9C%E9%85%8D%E7%BD%AE%23%E8%AE%BE%E5%A4%87%E9%A9%B1%E5%8A%A8) 页面。
> \2. 你已连接到网络。网线已接好或者已经连接到无线局域网。
> \3. 你的网络接口拥有一个 IP 地址。
> \4. 你的路由表设置正确。
> \5. 你可以 ping 通一个本地 IP 地址（例如你的默认网关）。
> \6. 你可以 ping 通一个公网 IP 地址（例如 9.9.9.9，即 Quad9 的 DNS 服务器）。
> \7. 检查是否能解析域名（例如 [http://archlinux.org](https://link.zhihu.com/?target=http%3A//archlinux.org)）。[[12\]](https://zhuanlan.zhihu.com/p/596227524#ref_12)

## 10. 更新系统时钟

在互联网连接之后，systemd-timesyncd 服务将自动校准系统时间。请输入如下命令确定时间的准确性。设置时间的目的之一是便于安装软件包时验证签名。

```text
root@archiso ~ # timedatectl
```

时间可能以 UTC 时区显示，比北京时间慢 8 小时。这是正常现象，无需调整。

如果时间不准确，请使用 date 命令手动设置时间。

```text
root@archiso ~ # date MMDDhhmmYY  # 如 date 1231080023 可以将时间设定为 2023 年 12 月 31 日 08:00
```

## 11. 磁盘分区

**注意：**

- **从未进行过磁盘分区操作的读者请先在虚拟机内练习**
- **请您务必提前备份好重要资料**
- **请您确保知晓命令的含义，并正确输入命令，否则有可能造成数据丢失**

### 11.1 全新安装 Arch Linux 的磁盘分区

**注意：继续操作将清除硬盘内全部数据。如果您想保留数据和已有的 Windows 系统，请看第 11.2 节。**

磁盘分区表

| 挂载点    | 分区                       | 分区类型          | 建议大小               | 备注                    |
| --------- | -------------------------- | ----------------- | ---------------------- | ----------------------- |
| /mnt/boot | /dev/sda1 或/dev/nvme0n1p1 | EFI System        | 512 MiB                | ESP 分区                |
| /mnt      | /dev/sda2 或/dev/nvme0n1p2 | Linux x86-64 root | 100 GiB（至少 50 GiB） | Arch Linux 的根分区     |
| /mnt/home | /dev/sda3 或/dev/nvme0n1p3 | Linux home        | 剩余磁盘空间           | Arch Linux 的 home 分区 |

首先使用 `lsblk` 或 `fdisk -l` 查看分区信息。您将看到许多设备，请注意根据容量大小和分区数量进行区分，例如

```text
root@archiso ~ # lsblk
NAME           MAJ:MIN  RM    SIZE  RO  TYPE  MOUNTPOINT
loop0            7:0     0  688.2M   1  loop  /run/archiso/airootfs  # loop0 可以忽略
sda              8:0     0  931.5G   0  disk  # sda 是要安装 Arch Linux 的硬盘，请记住设备名
├─sda1           8:1     0    512M   0  part
└─sda2           8:2     0    931G   0  part
sdb              8:16    1   59.8G   0  disk  # sdb 是 U 盘，请忽略
├─sdb1           8:17    1   59.7G   0  part
│   └ventoy    254:0     0  861.3M   1  dm    /run/archiso/bootmnt
└─sdb2           8:18    1     32M   0  part
```

在上面的例子中，以 rom，loop，airoot 结尾的设备可以忽略；sda 是要安装 Arch Linux 的硬盘，**请记住这个设备名**；根据容量可以判断出 sdb 是 U 盘，请忽略。找到要进行分区的设备之后，请记住设备名（**本文以 /dev/sda 为例，您的硬盘也可能是 /dev/nvme0n1**）。

我们使用的分区工具是 fdisk[[13\]](https://zhuanlan.zhihu.com/p/596227524#ref_13)，首先让我们通过查看帮助，学习一下 fdisk 的用法。

```text
root@archiso ~ # fdisk /dev/sda  # 输入 fdisk 设备名，进入 fdisk 操作环境

Welcome to fdisk (util-linux 2.x).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.  # 执行写入命令（w）之前，硬盘不会被改动

Command (m for help): m  # 输入 m 获取帮助

Help:
  …
  Generic
   d   delete a partition  # 输入 d 删除分区
   n   add a new partition  # 输入 n 创建分区
   p   print the partition table  # 输入 p 打印分区表
   t   change a partition type  # 输入 t 改变分区类型
  …
  Save & Exit
   w   write table to disk and exit  # 输入 w 写入并退出（写入后不可撤销，请谨慎使用）
   q   quit without saving changes  # 输入 q 不保存退出
  …
  Create a new label
   g   create a new empty GPT partition table  # 输入 g 创建 GPT 分区表
  …
```

现在请输入 `Ctrl+C` ，退出 fdisk 操作环境。

我们现在正式进行磁盘分区。首先需要创建 GPT 分区表；随后依次创建分区，并修改分区类型；最后保存并退出。请参考以下分区过程，按照您的分区方案进行分区。

```text
root@archiso ~ # fdisk /dev/sda  # 请将 sda 更换为您的设备名，如 nvme0n1

Welcome to fdisk (util-linux 2.x).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Command (m for help): g  # 输入 g 创建新的 GPT 分区表（请勿遗忘此步，否则您的硬盘将是 MBR 格式）
Created a new GPT disklabel (GUID: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx).

Command (m for help): n  # 输入 n 创建新的分区，这个分区将是 EFI 分区
Partition number (1-128, default 1):  # 分区编号保持默认，直接按 Enter
First sector (2048-125829086, default 2048):  # 第一个扇区，保持默认
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-125829086, default 125827071): +512M  # 创建 512MiB 大小的分区

Created a new partition 1 of type 'Linux filesystem' and of size 512 MiB.
Partition #1 contains a vfat signature.

Do you want to remove the signature? [Y]es/[N]o: Y  # 清除已有的签名，如果是全新的硬盘，则没有此步

The signature will be removed by a write command.

Command (m for help): t  # 输入 t 改变分区类型，请勿遗忘此步
Selected partition 1
Partition type or alias (type L to list all): 1  # 输入 1 代表 EFI 类型
Changed type of partition 'Linux filesystem' to 'EFI System'.

Command (m for help): n  # 创建第二个分区，用作根分区
Partition number (2-128, default 2):   # 保持默认
First sector (1050624-125829086, default 1050624):   # 保持默认
Last sector, +/-sectors or +/-size{K,M,G,T,P} (1050624-125829086, default 125827071): +100G  # 创建 100 GiB 大小的根分区，您可以根据自己的硬盘空间决定根分区的大小

Created a new partition 2 of type 'Linux filesystem' and of size 100 GiB.
Partition #2 contains a ntfs signature.

Do you want to remove the signature? [Y]es/[N]o: Y

The signature will be removed by a write command.

Command (m for help): t  # 输入 t 改变分区类型，请勿遗忘此步
Partition number (1-2, default 2):   # 保持默认
Partition type or alias (type L to list all): 23  # 输入 23 代表 Linux root (x86-64) 类型
Changed type of partition 'Linux filesystem' to 'Linux root (x86-64)'.

Command (m for help): n  # 创建第三个分区，用作 home 分区
Partition number (3-128, default 3):   # 保持默认
First sector (42993664-125829086, default 42993664):   # 保持默认
Last sector, +/-sectors or +/-size{K,M,G,T,P} (42993664-125829086, default 125827071):   #保持默认，将剩余空间全部分给 home 分区

Created a new partition 3 of type 'Linux filesystem' and of size 39.5 GiB.

Command (m for help): t  # 输入 t 改变分区类型
Partition number (1-3, default 3):
Partition type or alias (type L to list all): 42  # 输入 42 代表 Linux home 类型
Changed type of partition 'Linux filesystem' to 'Linux home'.

Command (m for help): p  # 输入 p 打印分区表，请检查分区是否有误，如果有误，请输入 q 直接退出
Disk /dev/sda: 60 GiB, 64424509440 bytes, 125829120 sectors
Disk model: xxx
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: gpt
Disk identifier: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

Device        Start        End   Sectors   Size  Type
/dev/sda1      2048    1050623   1048576   512M  EFI System
/dev/sda2   1050624   42993663  41943040   100G  Linux root (x86-64)
/dev/sda3  42993664  125827071  82833408  39.5G  Linux home

Filesystem/RAID signature on partition 1 will be wiped.
Filesystem/RAID signature on partition 2 will be wiped.

Command (m for help): w  # 输入 w 写入分区表，该操作不可恢复
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```

### 11.2 Windows 与 Arch Linux 双系统的磁盘分区

**注意：请务必仔细阅读并理解本文后再操作，错误的操作将导致 Windows 系统损坏。**

磁盘分区表（此分区表参考微软的 UEFI/GPT 硬盘推荐分区[[14\]](https://zhuanlan.zhihu.com/p/596227524#ref_14)）

| 挂载点    | 分区                       | 分区类型             | 建议大小                                    | 备注                    |
| --------- | -------------------------- | -------------------- | ------------------------------------------- | ----------------------- |
| /mnt/efi  | /dev/sda1 或/dev/nvme0n1p1 | EFI System           | 260 MiB                                     | ESP 分区                |
| ---       | /dev/sda2 或/dev/nvme0n1p2 | Microsoft reserved   | 16 MiB                                      | Windows 的 MSR 分区     |
| ---       | /dev/sda3 或/dev/nvme0n1p3 | Microsoft basic data | ---                                         | Windows 的 C 盘         |
| ---       | /dev/sda4 或/dev/nvme0n1p4 | Microsoft basic data | ---                                         | Windows 的 D 盘         |
| /mnt/     | /dev/sda5 或/dev/nvme0n1p5 | Linux x86-64 root    | 50 GiB（可根据硬盘空间调整，但至少 30 GiB） | Arch Linux 的根分区     |
| /mnt/home | /dev/sda6 或/dev/nvme0n1p6 | Linux home           | 剩余空间                                    | Arch Linux 的 home 分区 |

首先使用 `lsblk` 或 `fdisk -l` 查看分区信息。您将看到许多设备，请注意根据容量大小和分区数量进行区分，例如

```text
root@archiso ~ # lsblk
NAME           MAJ:MIN  RM    SIZE  RO  TYPE  MOUNTPOINT
loop0            7:0     0  688.2M   1  loop  /run/archiso/airootfs  # loop0 可以忽略
sda              8:0     0  931.5G   0  disk  # sda 是要安装 Arch Linux 的硬盘，请记住设备名
├─sda1           8:1     0    260M   0  part
├─sda2           8:2     0     16M   0  part
├─sda3           8:3     0     50G   0  part
└─sda4           8:4     0     50G   0  part
sdb              8:16    1   59.8G   0  disk  # sdb 是 U 盘，请忽略
├─sdb1           8:17    1   59.7G   0  part
│   └ventoy    254:0     0  861.3M   1  dm    /run/archiso/bootmnt
└─sdb2           8:18    1     32M   0  part
```

在上面的例子中，以 rom， loop， airoot 结尾的设备可以忽略；sda 是要安装 Arch Linux 的硬盘，**请记住这个设备名**；根据容量可以判断出 sdb 是 U 盘，请忽略。找到要进行分区的设备之后，请记住设备名（**本文以 /dev/sda 为例，您的硬盘也可能是 /dev/nvme0n1**）。

根据微软的 UEFI/GPT 硬盘推荐分区[[14\]](https://zhuanlan.zhihu.com/p/596227524#ref_14)，我们有 Windows 为您分好的 260 MiB 大小的 EFI 分区和 16 MiB 大小的 MSR 分区，以及 50 GiB 大小的 C 盘和 D 盘。

我们使用的分区工具是 fdisk[[13\]](https://zhuanlan.zhihu.com/p/596227524#ref_13)，请参见 11.1 节，学习 fdisk 的用法。

现在我们开始分区。**不需要创建 GPT 分区表，也不需要创建 EFI 分区，只需创建根分区和 home 分区。**

```text
root@archiso ~ # fdisk /dev/sda  # 请将 sda 更换为您的设备名，如 nvme0n1

Welcome to fdisk (util-linux 2.x).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Command (m for help): p  # 输入 p 打印分区表，检查已有的分区。我们有 260 MiB 大小的 EFI 分区和 16 MiB 大小的 MSR 分区，以及 50 GiB 大小的 C 盘和 D 盘

Disk /dev/sda: 150.6 GiB, 161705518592 bytes, 315831091 sectors
Disk model: xxx
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: gpt
Disk identifier: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

Device        Start        End   Sectors   Size  Type
/dev/sda1      2048     534527    532480   260M  EFI System
/dev/sda2    534528     567295     32768    16M  Microsoft reserved
/dev/sda3    567296  105424895 104857600    50G  Microsoft basic data
/dev/sda4 105424896  210282495 104857600    50G  Microsoft basic data

Command (m for help): n  # 输入 n 创建新的分区，这个分区将是根分区
Partition number (5-128, default 5):  # 分区编号保持默认，直接按 Enter
First sector (210282496-315831057, default 210282496):  # 第一个扇区，保持默认
Last sector, +/-sectors or +/-size{K,M,G,T,P} (210282496-315831057, default 315831057): +50G  # 创建 50 GiB 大小的根分区，您可以根据自己的硬盘空间决定根分区的大小

Created a new partition 5 of type 'Linux filesystem' and of size 50 GiB.

Command (m for help): t  # 输入 t 改变分区类型，请勿遗忘此步
Partition number (1-5, default 5):   # 保持默认
Partition type or alias (type L to list all): 23  # 输入 23 代表 Linux root (x86-64) 类型
Changed type of partition 'Linux filesystem' to 'Linux root (x86-64)'.

Command (m for help): n  # 输入 n 创建新的分区，这个分区将是 home 分区
Partition number (6-128, default 6):   # 保持默认
First sector (252225536-315831057, default 252225536):   # 保持默认
Last sector, +/-sectors or +/-size{K,M,G,T,P} (252225536-315831057, default 315831057):   # 保持默认，将剩余空间全部分给 home 分区

Created a new partition 6 of type 'Linux filesystem' and of size 30.3 GiB.

Command (m for help): t  # 输入 t 改变分区类型
Partition number (1-6, default 6):   # 保持默认
Partition type or alias (type L to list all): 42  # 输入 42 代表 Linux home 类型
Changed type of partition 'Linux filesystem' to 'Linux home'.

Command (m for help): p  # 输入 p 打印分区表，请检查分区是否有误，如果有误，请输入 q 直接退出

Disk /dev/sda: 150.6 GiB, 161705518592 bytes, 315831091 sectors
Disk model: xxx
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: gpt
Disk identifier: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

Device        Start        End   Sectors   Size  Type
/dev/sda1      2048     534527    532480   260M  EFI System
/dev/sda2    534528     567295     32768    16M  Microsoft reserved
/dev/sda3    567296  105424895 104857600    50G  Microsoft basic data
/dev/sda4 105424896  210282495 104857600    50G  Microsoft basic data
/dev/sda5 210282496  252225535  41943040    50G  Linux root (x86-64)
/dev/sda6 252225536  315830271  63604736  30.3G  Linux home

Command (m for help): w  # 输入 w 写入分区表，该操作不可恢复
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```

## 12. 分区格式化

创建好的分区必须格式化为一种文件系统，Linux 上常见的文件系统有 ext4，btrfs，xfs 等。建议第一次安装的读者使用 ext4 文件系统。btrfs 提供子卷、写时复制、压缩、快照等高级功能，适合更加熟练的用户。

### 12.1 全新安装 Arch Linux 的分区格式化

**注意：如果您希望 Arch Linux 与 Windows 系统共存，请直接跳到下一小节。**

使用 mkfs.fat[[15\]](https://zhuanlan.zhihu.com/p/596227524#ref_15)将您的 EFI 分区格式化为 FAT32 文件系统。**请将 /dev/sda1 更换为您的 EFI 分区名，可能是 /dev/nvme0n1p1。**

```text
root@archiso ~ # mkfs.fat -F 32 /dev/sda1
```

使用 mkfs.ext4 将您的根分区格式化为 ext4 文件系统。**请将 /dev/sda2 更换为您的 root 分区名，可能是 /dev/nvme0n1p2。**

```text
root@archiso ~ # mkfs.ext4 /dev/sda2
```

使用 mkfs.ext4 将您的 home 分区格式化为 ext4 文件系统。**请将 /dev/sda3 更换为您的 home 分区名，可能是 /dev/nvme0n1p3。**

```text
root@archiso ~ # mkfs.ext4 /dev/sda3
```

### 12.2 Windows 与 Arch Linux 双系统的分区格式化

**注意：请务必仔细检查命令，尤其是分区名。错误的操作将导致 Windows 系统损坏。**

使用 mkfs.ext4[[16\]](https://zhuanlan.zhihu.com/p/596227524#ref_16)将您的根分区格式化为 ext4 文件系统。**请将 /dev/sda5 更换为您的 root 分区名，可能是 /dev/nvme0n1p5。**

如果您忘记了 root 分区名，请输入 fdisk -l。在 Type 一栏里找到 Linux root(x86-64) 对应的 Device 名称。

```text
root@archiso ~ # mkfs.ext4 /dev/sda5
```

使用 mkfs.ext4 将您的 home 分区格式化为 ext4 文件系统。**请将 /dev/sda6 更换为您的 home 分区名，可能是 /dev/nvme0n1p6。**

如果您忘记了 home 分区名，请输入 fdisk -l。在 Type 一栏里找到 Linux home 对应的 Device 名称。

```text
root@archiso ~ # mkfs.ext4 /dev/sda6
```

## 13. 挂载分区

### 13.1 全新安装 Arch Linux 的挂载分区

**注意：挂载需要遵循一定的顺序，要先挂载根分区。**

使用 mount[[17\]](https://zhuanlan.zhihu.com/p/596227524#ref_17)将根分区挂载在 /mnt 目录下。请将 /dev/sda2 更换为您的 root 分区名，可能是 /dev/nvme0n1p2。

```text
root@archiso ~ # mount /dev/sda2 /mnt
```

随后，使用 mount --mkdir 创建 /mnt/boot 目录，并将 EFI 分区挂载在 /mnt/boot 目录下。请将 /dev/sda1 更换为您的 EFI 分区名，可能是 /dev/nvme0n1p1。

```text
root@archiso ~ # mount --mkdir /dev/sda1 /mnt/boot
```

此处，也可以使用 /mnt/efi 作为挂载点，这需要引导程序的配合，具体的区别见 [ArchWiki](https://link.zhihu.com/?target=https%3A//wiki.archlinux.org/title/EFI_system_partition%23Typical_mount_points)。

最后，挂载 home 分区。请将 /dev/sda5 更换为您的 home 分区名，可能是 /dev/nvme0n1p3。

```text
root@archiso ~ # mount --mkdir /dev/sda3 /mnt/home
```

### 13.2 Windows 与 Arch Linux 双系统的挂载分区

**注意：挂载需要遵循一定的顺序，要先挂载根分区。**

使用 mount[[17\]](https://zhuanlan.zhihu.com/p/596227524#ref_17)将根分区挂载在 /mnt 目录下。请将 /dev/sda5 更换为您的 root 分区名，可能是 /dev/nvme0n1p5。

```text
root@archiso ~ # mount /dev/sda5 /mnt
```

随后，使用 mount --mkdir 创建 /mnt/efi 目录，并将 EFI 分区挂载在 /mnt/efi 目录下。这里不选择挂载点为 /mnt/boot 的目的是减小磁盘空间占用，但是您将只能选择特定的引导程序，如 GRUB。请将 /dev/sda1 更换为您的 EFI 分区名，可能是 /dev/nvme0n1p1。

```text
root@archiso ~ # mount --mkdir /dev/sda1 /mnt/efi
```

此处，也可以使用 /mnt/boot 作为挂载点，具体的区别见 [ArchWiki](https://link.zhihu.com/?target=https%3A//wiki.archlinux.org/title/EFI_system_partition%23Typical_mount_points)。

最后，挂载 home 分区。请将 /dev/sda6 更换为您的 home 分区名，可能是 /dev/nvme0n1p6。

```text
root@archiso ~ # mount --mkdir /dev/sda6 /mnt/home
```

## 14. 建立交换文件

交换文件相当于 Windows 中的虚拟内存，也就是利用硬盘空间充当内存。当内存**相对**不足时，部分内存中的内容会交换到硬盘中，从而释放内存。关于 swap 的重要性，有两篇不错的文章，推荐读者阅读。

[https://farseerfc.me/zhs/in-defence-of-swap.htmlfarseerfc.me/zhs/in-defence-of-swap.html](https://link.zhihu.com/?target=https%3A//farseerfc.me/zhs/in-defence-of-swap.html)

[https://farseerfc.me/zhs/followup-about-swap.htmlfarseerfc.me/zhs/followup-about-swap.html](https://link.zhihu.com/?target=https%3A//farseerfc.me/zhs/followup-about-swap.html)

交换文件的大小是个众说纷纭的问题。笔者参考 RedHat 文档[[18\]](https://zhuanlan.zhihu.com/p/596227524#ref_18)，推荐的交换文件大小见下表。笔者使用的公式是

交换文件大小内存大小交换文件大小=22×内存大小

您可以根据您的实际情况选择交换文件的大小。如果需要休眠功能，建议交换文件接近内存大小[[19\]](https://zhuanlan.zhihu.com/p/596227524#ref_19)，可以使用笔者的推荐大小。如果您不需要休眠功能，请适当减少交换文件大小。

| 内存大小                             | 2 GiB    | 4 GiB    | 8 GiB    | 16 GiB    | 32 GiB    | 64 GiB    |
| ------------------------------------ | -------- | -------- | -------- | --------- | --------- | --------- |
| 推荐的交换文件大小（使用休眠功能）   | 4096 MiB | 5793 MiB | 8192 MiB | 11585 MiB | 16384 MiB | 23170 MiB |
| 推荐的交换文件大小（不使用休眠功能） | 4096 MiB | 5793 MiB | 8192 MiB | 8192 MiB  | 4096 MiB  | 0 MiB     |

建立交换文件的具体操作方法如下[[20\]](https://zhuanlan.zhihu.com/p/596227524#ref_20)。首先使用 dd 创建交换文件。例如，创建一块 8 GiB （=8192 MiB）大小的交换文件。

```text
root@archiso ~ # dd if=/dev/zero of=/mnt/swapfile bs=1M count=8192 status=progress
```

如果您需要创建其他大小的交换文件，请将 count= 后面的数值换成交换文件大小的 MiB 数（GiB 数 x 1024）。

然后，修改权限。

```text
root@archiso ~ # chmod 0600 /mnt/swapfile
```

最后，格式化并启用 swap。

```text
root@archiso ~ # mkswap -U clear /mnt/swapfile
root@archiso ~ # swapon /mnt/swapfile
```

## 15. 选择软件仓库镜像

在 Arch Linux 中，软件仓库就好比手机中的应用商店，软件包是通过软件仓库进行分发的。软件仓库镜像是软件仓库的复制品，同一个软件仓库可以在世界各地建立软件仓库镜像，以便于不同地区的用户下载。因此选择一个合适的软件仓库镜像对于您更新软件包数据库以及下载软件包的速度有很大影响。

### 15.1 使用 reflector

Arch Linux 提供了一个筛选软件仓库镜像的便利工具 reflector[[21\]](https://zhuanlan.zhihu.com/p/596227524#ref_21)。我们使用该工具选择软件仓库镜像。首先使用 reflector 自带的帮助学习一下该软件的用法。当您遇到陌生的命令时，使用 --help 选项查看用法是一个好主意。

```text
root@archiso ~ # reflector --help
```

请仔细阅读屏幕上打印出的内容，自学是使用 Arch Linux 的必要过程。如果您看不懂，可以参考以下总结。

```text
用法：
reflector -选项1 -选项2 …

选项：
--save <文件路径>  把镜像列表保存到给定的路径
--sort {age,rate,country,score,delay}
  以给定条件给镜像排序。
  age：服务器最后同步时间；
  rate：下载速度；
  country：国家名；
  score：“镜像状态”中的得分；
  delay：“镜像状态”中的延迟
--delay n  只返回同步延迟在 n 小时之内的镜像
-a n  只返回 n 小时内同步的镜像
-c <国家>
-p <协议>
```

笔者推荐使用如下命令选择镜像。此命令将为您选出位于平均同步延迟在 3 小时以内的，位于中国的 https 镜像，并根据速度排序。指定 --completion-percent 95（默认为100）的目的是防止忽略可用的镜像。

```text
root@archiso ~ # reflector -p https -c China --delay 3 --completion-percent 95 --sort rate --save /etc/pacman.d/mirrorlist
```

上述命令使用了并不稳定的测速功能，如果大量报错，也可以根据得分[[22\]](https://zhuanlan.zhihu.com/p/596227524#ref_22)排序。

```text
root@archiso ~ # reflector -p https -c China --delay 3 --completion-percent 95 --sort score --save /etc/pacman.d/mirrorlist
```

如果您在国外，请使用

```text
root@archiso ~ # reflector --list-countries
```

查看您所在的国家名，然后自行替换选项 -c 后面的内容。如果国家名包含空格，请使用两字母的国家代号，或者用引号将国家名包裹起来。

### 15.2 手动编辑

您也可以手动编辑 /etc/pacman.d/mirrorlist。国内知名的软件仓库镜像站有清华（TUNA）和中科大（USTC），但是笔者不推荐将它们放在第一位。因为使用者过多，服务器负载过大，影响下载速度。根据下列文章，笔者推荐北外（BFSU）镜像。该镜像由清华 TUNA 协会维护，质量速度俱佳。此外，上交（SJTUG）镜像也是不错的选择。

[请给 tuna/ustc 镜像站减压zhul.in/2021/05/27/relieve-the-pressure-of-tuna-mirror-site-please/![img](https://pic2.zhimg.com/v2-c3c378a0561c4c4f522d3a061a674865_180x120.jpg)](https://link.zhihu.com/?target=https%3A//zhul.in/2021/05/27/relieve-the-pressure-of-tuna-mirror-site-please/)

```text
root@archiso ~ # nano /etc/pacman.d/mirrorlist

/etc/pacman.d/mirrorlist
------------------------
Server = https://mirrors.bfsu.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.sjtug.sjtu.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch
```

如果您在国外，可以选择 pkgbuild 镜像。

```text
/etc/pacman.d/mirrorlist
------------------------
Server = https://geo.mirror.pkgbuild.com/$repo/os/$arch
```

随后输入 `Ctrl+O` 保存，`Ctrl+X` 退出。

## 16. 安装基础包

终于到了安装环节。我们使用 pacstrap 安装 base，linux，linux-firmware 三个软件包，它们分别是基础包组，linux 内核和驱动程序。此外，如果您使用 2019 年及以后生产的笔记本电脑，可能需要安装 sof-firmware，否则可能没有声音[[23\]](https://zhuanlan.zhihu.com/p/596227524#ref_23)。

Arch linux 官方提供了 linux，linux-lts，linux-zen，linux-hardened 内核[[24\]](https://zhuanlan.zhihu.com/p/596227524#ref_24)，但是对于初学者，只推荐使用 linux 内核。

```text
root@archiso ~ # pacstrap -K /mnt base linux linux-firmware
```

此命令需要一段时间执行。执行完毕后请检查输出，**不应出现任何 ERROR**。如果出现，请重新执行命令。如果反复报错，可以寻求他人的帮助。

如果报告“验证软件包错误”，可以尝试以下方法，然后重新安装。

```text
root@archiso ~ # pacman-key --init  # 初始化密钥环
root@archiso ~ # pacman-key --populate
root@archiso ~ # pacman -Sy archlinux-keyring  # 更新 archlinux-keyring
```

## 17. fstab

fstab[[25\]](https://zhuanlan.zhihu.com/p/596227524#ref_25) 是一个系统文件，决定了系统启动时如何自动挂载分区。没有 fstab，系统将找不到根分区，从而无法启动。fstab 有一定的格式，我们用一个例子说明 fstab 文件的格式。

```text
/etc/fstab
----------
# <device>                                <dir> <type> <options> <dump> <fsck>
UUID=0a3407de-014b-458b-b5c1-848e92a327a3 /     ext4   noatime   0      1
UUID=f9fe0b69-a280-415d-a03a-a32752370dee none  swap   defaults  0      0
UUID=b411dc99-f0a0-4c87-9e05-184977be8539 /home ext4   noatime   0      2
```

第一栏：设备，描述了要被挂载的块设备，推荐使用 UUID 方式，也可以使用分区标签（label）。

第二栏：文件夹，即挂载文件夹。

第三栏：类型，即文件系统类型。

第四栏：选项，即挂载选项。

第五栏：dump，用于 dump 功能决定文件系统是否需要备份，一般填 0。

第六栏：fsck，是否在启动过程中检查文件系统，对于 ext4 格式的根分区，应该填 1，其余填 0。

Arch Linux 提供了自动生成 fstab 的工具，我们利用它直接生成。

```text
root@archiso ~ # genfstab -U /mnt >> /mnt/etc/fstab
```

其中“genfstab -U /mnt”是以 UUID 的描述方式生成 fstab，“>>” 的意思是，将输出结果附加在后面的文件之后。

生成完成后，记得使用 cat 命令打印文件内容，仔细检查一遍。

```text
root@archiso ~ # cat /mnt/etc/fstab
```

## 18. chroot

我们使用 arch-chroot 工具切换到新安装的系统，以后的操作就可以在新安装的系统中完成了。

```text
root@archiso ~ # arch-chroot /mnt
```

## 19. 时区

我们设置时区的软链接。**在中国的读者请使用上海时间，在其他地区的读者可以在输入“/usr/share/zoneinfo/”之后按下`Tab`键查看可选的时区。**

```text
[root@archiso ~]# ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
```

然后，设置硬件时间。

```text
[root@archiso ~]# hwclock --systohc
```

## 20. 本地化

我们将设置 locale[[26\]](https://zhuanlan.zhihu.com/p/596227524#ref_26) 、终端键盘布局和字体[[27\]](https://zhuanlan.zhihu.com/p/596227524#ref_27)。locale 决定了系统的语言和格式，包括终端显示哪种语言，数字、时间和货币以哪国的格式显示等等。

### 20.1 设置 locale

首先使用 Arch Linux 强大的包管理器 pacman 安装两个软件包。包管理器 pacman 是 Arch Linux 的核心特征之一，可以自动解决依赖问题，十分方便。它具有强大的功能，不过现在只需要学习安装软件包的方法。使用 pacman 安装软件包需要利用 -S（--sync）选项，这个选项的意思是同步的数据库，请初学者牢记。

```text
[root@archiso ~]# pacman -S vim terminus-font
```

vim 是著名的文本编辑器，而 terminus-font 是终端字体。我们输入以下命令，利用 vim 编辑 /etc/locale.gen。

```text
[root@archiso ~]# vim /etc/locale.gen
```

vim 的功能也十分强大，在这里笔者只解释用到的功能，其他功能在下一篇文章中介绍。如果您想提前学习 vim 的使用方法，[请查看菜鸟教程](https://link.zhihu.com/?target=https%3A//www.runoob.com/linux/linux-vim.html)。

输入“`/`”，进入搜索功能，输入“en_US.UTF-8”，我们找到了以下一行。

```text
#en_US.UTF-8 UTF-8
```

按下 `Enter`，此时光标的位置在这一行的“e”的位置。按方向左键，再输入“`x`”，将这一行开头的“#”删除。

```text
en_US.UTF-8 UTF-8
```

再一次输入“`/`”，进入搜索功能，输入“zh_CN.UTF-8”，按下`Enter`。按方向左键，再输入“`x`”，将“#”删除。

```text
zh_CN.UTF-8 UTF-8
```

随后输入“`:`”，进入命令模式，输入“`wq`”，按下`Enter`，保存并退出 vim 软件环境。

接下来，输入如下命令，生成 locale。

```text
[root@archiso ~]# locale-gen
```

我们再使用 vim 创建并编辑 locale.conf，设置 locale。

```text
[root@archiso ~]# vim /etc/locale.conf
```

这是一个空文件。进入 vim 程序环境时，默认进入了命令模式，此时无法插入字符。我们首先按下“`i`”键，进入插入模式。请输入如下字符。

```text
LANG=en_US.UTF-8
```

然后按 `Esc`，退出插入模式。再输入“`:`”，进入命令模式，输入“`wq`”，按下`Enter`，保存并退出 vim 软件环境。

### 20.2 设置终端键盘布局和字体

我们创建并编辑 vconsole.conf，设置终端的默认字体。我们已经在安装开始时设置过终端字体，但是重启之后设置将失效。为了让设置永久生效，我们需要把设置写在文件中。请输入如下命令。

```text
[root@archiso ~]# vim /etc/vconsole.conf
```

请用相同的方法输入如下字符。请在“KEYMAP=”后面输入您在第 7 节设置终端键盘布局时选择的键盘布局（这一行可以不设置），在“FONT=”后面输入您在第 7 节设置终端字体时选择的字体，保存并退出。

```text
FONT=ter-132b
```

## 21. 网络配置

请编辑 hostname[[28\]](https://zhuanlan.zhihu.com/p/596227524#ref_28)文件，设置主机名。**这将成为您计算机的名字**。[这篇文章](https://link.zhihu.com/?target=https%3A//www.rfc-editor.org/rfc/rfc1178)为设置主机名提供了一些建议。

```text
[root@archiso ~]# vim /etc/hostname
----------------------------------
我的主机名
```

然后，请安装一个网络管理器，笔者推荐使用 NetworkManager。

```text
[root@archiso ~]# pacman -S networkmanager
```

NetworkManager 附带一个守护程序。在 Arch Linux 中，守护程序由 systemd 管理。systemd 是非常重要的系统程序，我们在下一篇文章中会详细介绍它的用法。现在我们使用 systemd 设置 NetworkManager 开机自动启动。

```text
[root@archiso ~]# systemctl enable NetworkManager.service
```

## 22. root 密码

root 用户是 Linux 系统中权限最高的用户，有些敏感的操作必须通过 root 用户进行，比如使用 pacman。我们之前进行所有的操作也都是以 root 用户进行的。也正是因为 root 的权限过高，如果使用不当会造成安全问题，所以我们在下一篇文章中会新建一个普通用户来进行日常的操作。在这里我们需要为 root 用户设置一个密码。[[29\]](https://zhuanlan.zhihu.com/p/596227524#ref_29)

请输入如下命令设置 root 密码。

```text
[root@archiso ~]# passwd
New password:  # 请输入密码，这里不会显示“*”，这是正常现象
Retype new password:
passwd: password updated successfully
```

## 23. 引导加载程序

为了启动 Arch Linux，必须使用一个引导加载程序，笔者推荐使用 GRUB[[30\]](https://zhuanlan.zhihu.com/p/596227524#ref_30)。再次声明，本教程只针对 UEFI 启动模式的计算机，如果您的计算机使用 BIOS 启动模式，[请参阅此教程](https://www.viseator.com/2017/05/17/arch_install/)。关于 Arch Linux 启动的过程，参见 [ArchWiki](https://link.zhihu.com/?target=https%3A//wiki.archlinux.org/title/Arch_boot_process)。这也是安装过程中比较复杂的一步。

### 23.1 微码

首先，根据您的 CPU 型号，安装相应的微码[[31\]](https://zhuanlan.zhihu.com/p/596227524#ref_31)。

请查看您的 CPU 型号。

```text
[root@archiso ~]# cat /proc/cpuinfo | grep "model name"
```

如果是 Intel CPU，安装 intel-ucode。

```text
[root@archiso ~]# pacman -S intel-ucode
```

如果是 AMD CPU，安装 amd-ucode。

```text
[root@archiso ~]# pacman -S amd-ucode
```

### 23.2 全新安装 Arch Linux 的引导加载程序安装

首先，安装必要的软件包。

```text
[root@archiso ~]# pacman -S grub efibootmgr
```

安装 GRUB 到计算机。

```text
[root@archiso ~]# grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
```

如果您在挂载分区时，将 esp 分区挂载到了 /efi 或者 /boot/efi，请在 --efi-directory 选项中作相应变动。如果您完全按照本教程操作，就不用作改变。

如果输出

```text
Installation finished. No error reported.
```

说明安装成功，可以执行以下步骤。否则请检查错误。

最后生成 GRUB 配置，即可。

```text
[root@archiso ~]# grub-mkconfig -o /boot/grub/grub.cfg
```

### 23.3 Arch Linux 和 Windows 双系统的引导加载程序安装

首先，安装必要的软件包。

```text
[root@archiso ~]# pacman -S grub efibootmgr os-prober
```

安装 GRUB 到计算机。

```text
[root@archiso ~]# grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
```

如果您在挂载分区时，将 esp 分区挂载到了 /boot，请在 --efi-directory 选项中作相应变动。如果您完全按照本教程操作，就不用作改变。

如果报告

```text
Installation finished. No error reported.
```

说明安装成功，可以执行以下步骤。否则请检查错误。

**然后配置 os-prober，以检测 Windows 系统，否则将不能进入 Windows 系统。**

```text
[root@archiso ~]# vim /etc/default/grub
```

搜索“GRUB_DISABLE_OS_PROBER=false”一行，并去掉这行开头的“#”。保存并退出。

最后生成 GRUB 配置，即可。

```text
[root@archiso ~]# grub-mkconfig -o /boot/grub/grub.cfg
```

## 24. 重启

首先，退出 chroot 环境。

```text
[root@archiso ~]# exit
```

然后，关闭交换文件。

```text
root@archiso ~ # swapoff /mnt/swapfile
```

随后，取消挂载 /mnt。

```text
root@archiso ~ # umount -R /mnt
```

最后，重新启动计算机。

```text
root@archiso ~ # reboot
```

至此，一个基本的 Arch Linux 系统已经安装完毕。现在您可以通过终端控制系统。我们将在下一篇文章中介绍安装后的配置，包括普通用户的创建、显卡驱动和图形界面的安装。敬请关注。

[会心：Arch Linux 安装后该做什么？Arch Linux 使用指南与推荐配置「2023.10」79 赞同 · 33 评论文章![img](https://pic2.zhimg.com/v2-43065dacac385326fcba94b4fddd8c61_180x120.jpg)](https://zhuanlan.zhihu.com/p/568981775)



## 参考

1. [^](https://zhuanlan.zhihu.com/p/596227524#ref_1_0)Dual boot with Windows - ArchWiki https://wiki.archlinux.org/title/Dual_boot_with_Windows#Windows_UEFI_vs_BIOS_limitations
2. [^](https://zhuanlan.zhihu.com/p/596227524#ref_2_0)各大品牌电脑如何进入BIOS？ - 知乎 https://zhuanlan.zhihu.com/p/126593694
3. [^](https://zhuanlan.zhihu.com/p/596227524#ref_3_0)Dual boot with Windows - ArchWiki https://wiki.archlinux.org/title/Dual_boot_with_Windows#UEFI_Secure_Boot
4. [^](https://zhuanlan.zhihu.com/p/596227524#ref_4_0)各大品牌电脑如何进入BIOS？ - 知乎 https://zhuanlan.zhihu.com/p/126593694
5. [^](https://zhuanlan.zhihu.com/p/596227524#ref_5_0)Enable or Disable Hibernate in Windows 10 | Tutorials https://www.tenforums.com/tutorials/2859-enable-disable-hibernate-windows-10-a.html
6. [^](https://zhuanlan.zhihu.com/p/596227524#ref_6_0)System time - ArchWiki https://wiki.archlinux.org/title/System_time#UTC_in_Microsoft_Windows
7. [^](https://zhuanlan.zhihu.com/p/596227524#ref_7_0)Bluetooth - ArchWiki https://wiki.archlinux.org/title/Bluetooth#Dual_boot_pairing
8. [^](https://zhuanlan.zhihu.com/p/596227524#ref_8_0)https://wiki.archlinux.org/title/Linux_console/Keyboard_configuration
9. [^](https://zhuanlan.zhihu.com/p/596227524#ref_9_0)Linux console - ArchWiki https://wiki.archlinux.org/title/Linux_console#Preview_and_temporary_changes
10. [^](https://zhuanlan.zhihu.com/p/596227524#ref_10_0)https://wiki.archlinux.org/title/Network_configuration#Network_interfaces
11. [^](https://zhuanlan.zhihu.com/p/596227524#ref_11_0)https://wiki.archlinux.org/title/Iwd#iwctl
12. [^](https://zhuanlan.zhihu.com/p/596227524#ref_12_0)[https://wiki.archlinuxcn.org/wiki/%E7%BD%91%E7%BB%9C%E9%85%8D%E7%BD%AE#%E6%A3%80%E6%9F%A5%E8%BF%9E%E6%8E%A5](https://wiki.archlinuxcn.org/wiki/网络配置#检查连接)
13. ^[a](https://zhuanlan.zhihu.com/p/596227524#ref_13_0)[b](https://zhuanlan.zhihu.com/p/596227524#ref_13_1)https://wiki.archlinux.org/title/Fdisk
14. ^[a](https://zhuanlan.zhihu.com/p/596227524#ref_14_0)[b](https://zhuanlan.zhihu.com/p/596227524#ref_14_1)UEFI/GPT-based hard drive partitions | Microsoft Learn https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/configure-uefigpt-based-hard-drive-partitions
15. [^](https://zhuanlan.zhihu.com/p/596227524#ref_15_0)https://wiki.archlinux.org/title/File_systems#Create_a_file_system
16. [^](https://zhuanlan.zhihu.com/p/596227524#ref_16_0)https://wiki.archlinux.org/title/File_systems#Create_a_file_system
17. ^[a](https://zhuanlan.zhihu.com/p/596227524#ref_17_0)[b](https://zhuanlan.zhihu.com/p/596227524#ref_17_1)https://wiki.archlinux.org/title/File_systems#Mount_a_file_system
18. [^](https://zhuanlan.zhihu.com/p/596227524#ref_18_0)https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/storage_administration_guide/ch-swapspace
19. [^](https://zhuanlan.zhihu.com/p/596227524#ref_19_0)https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#About_swap_partition/file_size
20. [^](https://zhuanlan.zhihu.com/p/596227524#ref_20_0)https://wiki.archlinux.org/title/Swap#Swap_file_creation
21. [^](https://zhuanlan.zhihu.com/p/596227524#ref_21_0)https://wiki.archlinux.org/title/Reflector
22. [^](https://zhuanlan.zhihu.com/p/596227524#ref_22_0)https://archlinux.org/mirrors/status/
23. [^](https://zhuanlan.zhihu.com/p/596227524#ref_23_0)https://wiki.archlinux.org/title/Advanced_Linux_Sound_Architecture#ALSA_firmware
24. [^](https://zhuanlan.zhihu.com/p/596227524#ref_24_0)https://wiki.archlinux.org/title/Kernel#Officially_supported_kernels
25. [^](https://zhuanlan.zhihu.com/p/596227524#ref_25_0)https://wiki.archlinux.org/title/Fstab
26. [^](https://zhuanlan.zhihu.com/p/596227524#ref_26_0)https://wiki.archlinux.org/title/Locale
27. [^](https://zhuanlan.zhihu.com/p/596227524#ref_27_0)https://wiki.archlinux.org/title/Linux_console#Persistent_configuration
28. [^](https://zhuanlan.zhihu.com/p/596227524#ref_28_0)https://wiki.archlinux.org/title/Network_configuration#Set_the_hostname
29. [^](https://zhuanlan.zhihu.com/p/596227524#ref_29_0)以官方Wiki的方式安装ArchLinux | viseator's blog [https://www.viseator.com/2017/05/17/arch_install/#%E8%AE%BE%E7%BD%AERoot%E5%AF%86%E7%A0%81](https://www.viseator.com/2017/05/17/arch_install/#设置Root密码)
30. [^](https://zhuanlan.zhihu.com/p/596227524#ref_30_0)GRUB - ArchWiki https://wiki.archlinux.org/title/GRUB
31. [^](https://zhuanlan.zhihu.com/p/596227524#ref_31_0)Microcode - ArchWiki https://wiki.archlinux.org/title/Microcode

编辑于 2023-10-14 21:45・IP 属地北京