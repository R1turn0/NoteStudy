# ulimit

### 1. 简介

ulimit 是一种 Linux 系统的内建功能，它具有一套参数集，用于为由它生成的 shell进程及其所创进程的资源使用限制。

Provides control over the resources available to the shell and processes it creates, on systems that allow such control.

ulimit是临时限制，作用于通过使用其命令登录的 shell 会话，在会话终止时便结束限制，并不影响于其他 shell 会话。

若想实现长期的固定限制，ulimit 命令语句又可以被添加到由登录 shell 读取的配置文件中，作用于特定的 shell用户。



### 2. ulimit限制哪些资源

```
r1turn0@pop-os:~$ ulimit -a
real-time non-blocking time  (microseconds, -R) unlimited
core file size              (blocks, -c) 0
data seg size               (kbytes, -d) unlimited
scheduling priority                 (-e) 0
file size                   (blocks, -f) unlimited
pending signals                     (-i) 15066
max locked memory           (kbytes, -l) 497776
max memory size             (kbytes, -m) unlimited
open files                          (-n) 1024
pipe size                (512 bytes, -p) 8
POSIX message queues         (bytes, -q) 819200
real-time priority                  (-r) 0
stack size                  (kbytes, -s) 8192
cpu time                   (seconds, -t) unlimited
max user processes                  (-u) 15066
virtual memory              (kbytes, -v) unlimited
file locks                          (-x) unlimited
```

从上到下，依次为：

```
-a：显示目前资源限制的设定；
-c <core文件上限>：设定core文件的最大值，单位为区块；
-d <数据节区大小>：程序数据节区的最大值，单位为KB；
-f <文件大小>：shell所能建立的最大文件，单位为区块；
-H：设定资源的硬性限制，也就是管理员所设下的限制；
-m <内存大小>：指定可使用内存的上限，单位为KB；
-n <文件数目>：指定同一时间最多可开启的文件数；
-p <缓冲区大小>：指定管道缓冲区的大小，单位512字节；
-s <堆叠大小>：指定堆叠的上限，单位为KB；
-S：设定资源的弹性限制；
-t <CPU时间>：指定CPU使用时间的上限，单位为秒；
-u <程序数目>：用户最多可开启的程序数目；
-v <虚拟内存大小>：指定可使用的虚拟内存上限，单位为KB。
```



### 3. 常用操作

**查看系统用户所有限制值：**

```bash
ulimit -a
```

**设置用户open files（用户可以打开文件的最大数目）：**

```bash
ulimit -n 4096。
```

> 执行该命令非root用户只能设置到4096。想要设置到8192需要sudo权限或者root用户。

**查看当前系统打开的文件数量:**

```bash
lsof | wc -l
```

**查看当前进程的打开文件数量：**

```bash
lsof -p pid | wc -l      （lsof -p 1234 | wc -l  ）
```

**查看当前进程的最大可以打开的文件数：**

```bash
cat /proc/PID/limits  (如果通过ulimit -n 设置或者修改/etc/security/limits.conf，看看进程是否生效)  
```

**查看系统总限制打开文件的最大数量：**

```bash
cat /proc/sys/fs/file-max
```

lsof只能以root权限执行。在终端下输入lsof即可显示系统打开的文件,因为 lsof 需要访问核心内存和各种文件,所以必须以 root 用户的身份运行它才能够充分地发挥其功能。

