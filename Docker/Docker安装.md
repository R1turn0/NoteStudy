# Docker安装

### Docker下载安装

Docker下载：https://hub.docker.com/

进入下载安装包的目录，并在终端中输入：

> sudo apt install ./docker-desktop-4.10.1-amd64.deb
>
> dpkg -i docker-desktop-4.10.1-amd64.deb



### 下列软件包有未满足的依赖关系

提示：

下列软件包有未满足的依赖关系：

>  docker-desktop : 依赖: docker-ce-cli 但无法安装它

要安装Docker Desktop先得安装Docker引擎。



于是依照这里的指引开始操作。

https://docs.docker.com/engine/install/ubuntu/#set-up-the-repository



**正式开始**

如果之前安装过旧版本Docker，需要先卸载。

> sudo apt-get remove docker docker-engine docker.io containerd runc

卸载完成后，需要安装几个软件使得apt能够通过https安装软件。

> sudo apt-get update
>
> sudo apt-get install \
> ca-certificates \
> curl \
> gnupg \
> lsb-release

不过似乎都已经默认安装过了。



添加Docker的官方GPG密钥，好像是为了能够防止软件被篡改。

> sudo mkdir -p /etc/apt/keyrings
> curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg



添加Docker软件源：

> echo \
> "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
> $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

就会在 /etc/apt/sources.list.d 写入 docker.list



并添加以下内容

> deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu   jammy stable



但是添加的源是国外的网站，根据经验来看速度必然很慢，因此刚才的代码应该改为：

> echo \
> "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/ubuntu \
> $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

使用清华源。

清华源内也有操作步骤：https://hub.docker.comhttps//mirror.tuna.tsinghua.edu.cn/help/docker-ce/



安装Docker引擎：

> sudo apt-get update
>
> sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
>
> sudo apt-get install docker-ce docker-ce-cli containerd.io