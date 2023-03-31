# Docker 部署

## Doceker 使用

##### 一、Docker 进程相关命令

1. 启动docker服务：

   > systemctl start docker

2. 停止docker服务：

   > systemctl stop docker

3. 重启docker服务：

   > systemctl restart docker

4. 查看docker服务状态：

   > systemctl status docker

5. 设置开机启动docker服务：

   > systemctl enable docker



##### 二、Docker 镜像相关命令

1. 查看镜像：查看本地所有镜像

   > docker images
   > docker images -1 # 查看所用镜像的id

2. 搜索镜像：从网络中查找需要的镜像

   > docker search 镜像名称

3. 拉取镜像:从Docker仓库下载镜像到本地，镜像名称格式为 名称:版本号，如果版本号不指定则是最新的版本。 如果不知道镜像版本，可以去docker hub 搜索对应镜像查看。

   > docker pull 镜像名称

4. 删除镜像: 删除本地镜像

   > docker rmi 镜像 id # 删除指定本地镜像
   > docker rmi \`docker images -q\` # 删除所有本地镜像
   >
   > docker rmi \`docker images -q\` # 删除所有本地镜像



##### 三、Docker 容器相关命令

1. 查看容器

   > docker ps # 查看正在运行的容器
   > docker ps –a # 查看所有容器
   >
   > docker ps –a # 查看所有容器

2. 创建并启动容器

   > docker run 参数

3. 进入容器

   > docker exec 参数 # 退出容器，容器不会关闭

4. 停止容器

   > docker kill [容器ID]
   >
   > docker stop [容器ID]

5. 启动容器

   > docker start [容器ID]

6. 删除容器：如果容器是运行状态则删除失败，需要停止容器才能删除

   > docker rm [容器ID]

7. 查看容器信息

   > docker inspect [容器ID]



##### 四、Docker容器运行

1. Docker容器交互式运行

   使用docker的run参数可以运行一个容器，-i参数表示以交互式模式运行容器，-t参数表示为容器重新分配一个伪终端，这三个参数联合使用，就可以控制Docker容器以交互式来运行。
   执行命令：

	> docker run -it 【容器名】 【解释器】

	可以让Docker容器以交互式来运行，例如，执行命令：

	> \# 在执行命令后进入Docker容器的终端，从而对Docker镜像进行控制，在执行exit退出后，也会随之关闭该镜像
>
	> docker run -it docker.io/centos /bin/bash
	
2. Docker镜像后台运行

   此外，我们还可以控制Docker镜像在后台运行，此时，我们不能使用-i和-t参数了，而是使用-d参数指定后台运行Docker容器，使用-c参数指定运行容器的命令。例如，执行命令：

   > \# 可以使该镜像在后台执行-c参数后面指定的命令
   >
   > docker run -d docker.io/centos /bin/bash -c "while true; do echo 'Hello World '; sleep 1; done"

   该执行结果可以在Docker的日志文件中查看，Docker日志的查看可以执行命令：

   > \# 容器ID是该命令执行后返回的ID号，也可以通过docker ps命令查看
   >
   > docker logs 【容器ID】

   

## Docker 应用部署

##### 一、MySQL 部署

1. 搜索mysql镜像

   > docker search mysql

2. 拉取mysql镜像

   > docker pull mysql:5.7.25（根据自己用的或者本地版本进行拉取）

3. 创建容器，设置端口映射、目录映射

   > \# 在/root目录下创建mysql目录用于存储mysql数据信息
   >
   > mkdir  mysql
   >
   > cd  mysql

4. 参数配置

   > docker run -id \
   > -p 3307:3306 \
   > --name=c_mysql \
   > -v $PWD/conf:/etc/mysql/conf.d \
   > -v $PWD/logs:/logs \
   > -v $PWD/data:/var/lib/mysql \
   > -e MYSQL_ROOT_PASSWORD=123456 \
   > mysql：5.7.25

   参数说明：（在当前新建的mysql目录操作，pwd是默认路径，版本号要特别注意一定要与之前拉取的一样，否则就会从新拉取）

   > -p 3307:3306：将容器的 3306 端口映射到宿主机的 3307 端口。
   >
   > -v $PWD/conf:/etc/mysql/conf.d：将主机当前目录下的 conf/my.cnf 挂载到容器的 /etc/mysql/my.cnf。配置目录
   >
   > -v $PWD/logs:/logs：将主机当前目录下的 logs 目录挂载到容器的 /logs。日志目录
   >
   > -v $PWD/data:/var/lib/mysql ：将主机当前目录下的data目录挂载到容器的 /var/lib/mysql 。数据目录
   >
   > -e MYSQL_ROOT_PASSWORD=123456：初始化 root 用户的密码。

5. 启动镜像连接mysql（3307）

   查看所有镜像，并看一下name

   > docker ps -a

   启动镜像(此时就用到了刚才的name)

   > docker start c_mysql

   使用连接工具进行连接（端口填3307，映射了容器里的3306，密码是刚才自己设的）

##### 二、部署Tomcat

1. 搜索tomcat镜像

   > docker search tomcat

2. 拉取tomcat镜像

   > docker pull tomcat

3. 创建容器，设置端口映射，目录映射

   > \# 在/root目录下创建tomcat目录用于存储tomcat数据信息
   > mkdir tomcat
   >
   > cd tomcat

   > \# 根据本机配置设置
   > docker run -id --name=c_tomcat -p 8089:8080 -v $PWD:/usr/local/tomcat/webapps
   > tomcat
   >
   > - 参数说明
   >   - -p 8089:8080：将容器的8080端口映射到主机的8089端口
   >   - -v $PWD:/usr/local/tomcat/webapps：将主机中当前目录挂载到容器的webapps

4. 使用外部机器访问tomcat

   1. 准备工作

      此时挂载的是刚刚创建的当前目录，在这个文件下操作，是实时更新到tomcat容器的webapps目录下的

      > mkdir java
      >
      > cd java
      >
      > vim hello.html
      >
      > ```
      > <html>
      > <body>hello docker tomcar</body>
      > <html>
      > ```
      >
      > cat hello.html

   2. 访问（主机地址:8089/java/hello.html）

      若访问不到挂载，查看挂载，文件有没有实时更新，端口有没有开放

      Ctrl + P + Q （快捷键：退出容器但不关闭容器）

##### 三、部署Nginx

1. 搜索Nginx镜像

   > docker search nginx

2. 拉取

   > docker pull nginx

3. 创建容器，设置端口映射，目录映射

   > \#  在/root目录下创建nginx目录用于存储nginx数据信息
   > mkdir nginx
   > cd nginx
   > mkdir conf
   > cd conf
   >
   > mkdir nginx
   >
   > cd conf
   >
   > \# 在~/nginx/conf/下创建nginx.conf文件,粘贴下面内容
   > vim nginx.conf 

4. 将参数复制到nginx.conf

   ```
   user  nginx;
   worker_processes  1;
   
   error_log  /var/log/nginx/error.log warn;
   pid        /var/run/nginx.pid;
   
   
   events {
       worker_connections  1024;
   }
   
    
   http {
       include       /etc/nginx/mime.types;
       default_type  application/octet-stream;
    
       log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                         '$status $body_bytes_sent "$http_referer" '
                         '"$http_user_agent" "$http_x_forwarded_for"';
   
       access_log  /var/log/nginx/access.log  main;
   
       sendfile        on;
       #tcp_nopush     on;
   
       keepalive_timeout  65;
   
       #gzip  on;
   
       include /etc/nginx/conf.d/*.conf;
   }
   ```

   参数说明：

   - -p 86:80：将容器的80端口映射到 宿主机的 80 端口
   - -v $PWD/conf/nginx.conf:/etc/nginx/nginx.conf：将主机当前目录下的 /conf/nginx.conf 挂载到容器的 :/etc/nginx/nginx.conf。配置目录
   - -v $PWD/logs:/var/log/nginx：将主机当前目录下的 logs 目录挂载到容器的/var/log/nginx。日志目录

   > docker run -id --name=c_nginx \
   > -p 86:80 \
   > -v $PWD/conf/nginx.conf:/etc/nginx/nginx.conf \
   > -v $PWD/logs:/var/log/nginx \
   > -v $PWD/html:/usr/share/nginx/html \
   > nginx

5. 使用外部机器访问Nginx

   如果现在直接访问会报错403，因为nginx目录下缺少一个index.html文件，上面目录已经做了映射，不用跑到容器里面单独加一个了，如果上面挂载成功会出现conf、html、logs这三个文件夹，在html里面加一个会实时更新到容器里 

##### 四、部署Redis

1. 搜索redis镜像

   > docker search redis

2. 拉取redis镜像

   > docker pull redis:5.0

3. 创建容器，设置端口映射（只要不冲突就可以）

   > docker run -id --name=c_redis -p 6389:6379 redis:5.0

4. 使用windos，cmd命令窗口外部机器连接redis

   > redis-cli.exe -h 宿主ip -p 6389

