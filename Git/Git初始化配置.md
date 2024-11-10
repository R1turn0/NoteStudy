# Git 初始化配置

## 配置流程

### 添加 Git 账号信息

打开 `Git Bash`，输入

```shell
$ git config --global user.name "your_name"
$ git config --global user.email "your_email"
```

输入查看Git所有配置以及他们所在的文件

```shell
$ git config --list --show-origin
```

### 更改 Git 的文本编辑器

```shell
$ git config --global core.editor vim
```

或使用64位的 Notepad++

```shell
$ git config --global core.editor "'C:/Program Files/Notepad++/notepad++.exe' -multiInst -notabbar -nosession -noPlugin
```

### 生成 Git 密钥

进入到user文件夹下的 `\.ssh`

```shell
$ ssh-keygen -t rsa
```

用文本编辑器打开 .pub 文件，复制到 Github 设置中

### 启动 SSH 链接

```shell
$ ssh-agent.exe bash
```

手动添加私钥文件

```shell
$ ssh-add ~/.ssh/R1turn0
```

测试能否 ssh 到 GitHub

```shell
$ ssh -T git@github.com
```

### 代理配置

#### 1. HTTP协议代理配置

`--global` 表示全局，可以不加

```shell
$ git config --global https.proxy ***
```

例子：

```shell
# socks
$ git config --global http.proxy 'socks5://127.0.0.1:1080' 
$ git config --global https.proxy 'socks5://127.0.0.1:1080'
$ # http
$ git config --global http.proxy http://127.0.0.1:1080 
$ git config --global https.proxy https://127.0.0.1:1080
# 只对github.com使用代理，其他仓库不走代理
$ git config --global http.https://github.com.proxy socks5://127.0.0.1:1080
$ git config --global https.https://github.com.proxy socks5://127.0.0.1:1080
# 取消github代理
$ git config --global --unset http.https://github.com.proxy
$ git config --global --unset https.https://github.com.proxy
```

直接修改 `~/.gitconfig` 文件

```shell
[http]
$ proxy = socks5://127.0.0.1:1080
[https]
$ proxy = socks5://127.0.0.1:1080
```

#### 2. 取消代理

```shell
git config --global --unset http.proxy
git config --global --unset https.proxy
```

#### 3. SSH协议代理设置

修改ssh配置文件 `~/.ssh/config`

没有的话新建一个文件

Windows ssh配置文件路径：`:\Users\你的用户名\.ssh\config`

Linux ssh配置文件路径：`/home/你的用户名/.ssh/config`

```shell
$ ProxyCommand connect -S 代理地址:端口 %h %p
```

例子：

```shell
# 全局
# ProxyCommand connect -S 127.0.0.1:1080 %h %p
# 只为特定域名设定
$ Host github.com gitlab.com
$ ProxyCommand connect -S 127.0.0.1:1080 %h %p
-S 代表走socks代理。（ -H 实现http和https的仓库的克隆）
多个地址设置：Host后面使用空格隔开，而不是“，”
```

### 多账号设置

生成公私钥，并在对应账号配置公钥

*// 生成两个邮箱对应的ssh公私钥*

```shell
$ ssh-keygen -t ed25519 -C "1@email"
$ ssh-keygen -t ed25519 -C "2@email"
```

例子：

```shell
# Host：仓库网站的别名，随意取
# HostName：仓库网站的域名（PS：IP 地址应该也可以）
# User：仓库网站上的用户名
# IdentityFile：私钥的绝对路径
$ Host aa.github.com 
$ Hostname ssh.github.com
$ Port 22
$ User git
$ PreferredAuthentications publickey
$ IdentityFile ~/.ssh/id_aa
$ ProxyCommand connect -S 127.0.0.1:1080 %h %p

$ Host bb.github.com 
$ Hostname ssh.github.com
$ Port 22
$ User git
$ PreferredAuthentications publickey
$ IdentityFile ~/.ssh/id_bb
$ ProxyCommand connect -S 127.0.0.1:1080 %h %p
测试：
$ ssh -vT git@github.com 
$ ssh -vT git@aa.github.com 
$ ssh -vT git@bb.github.com 
```



## 常见问题：

### Permission denied (publickey).
在后台启动 SSH 代理。

```shell
$ ssh-agent -s
> Agent pid 59566
查找并记下您的公钥指纹。
```

```shell
$ ssh-add -l -E sha256
> 2048 SHA256:274ffWxgaxq/tSINAykStUL7XWyRNcRTlcST1Ei7gBQ /Users/USERNAME/.ss
```

对比GitHub设置中公钥指纹是否一致

> https://docs.github.com/en/authentication/troubleshooting-ssh/error-permission-denied-publickey



###  ssh: connect to host github.com port 22: Connection timed out

现象：命令行输入`ssh -T git@github.com`后提示`ssh: connect to host github.com port 22: Connection timed out`

原因：

1. 22端口被防火墙拒绝了，可以尝试连接GitHub的443端口
2. github.com不会自动的转换为ssh.github.com

解决方式：

在rsa公私钥生成的路径`~/.ssh`下边的`config`文件（如果没有则创建一个），输入以下内容：

```
Host github.com
HostName ssh.github.com		# 2.
User git
Port 443					# 1.
PreferredAuthentications publickey
IdentityFile ~/.ssh/id_rsa
```

### 可以使用`ssh -v`命令查看ssh链接过程中发生了什么

`-v`表示verbose，会打出详细日志