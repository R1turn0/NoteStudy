# Qt下MySQL库的编译

Qt后面的版本都没有直接带Mysql插件驱动了，需要我们自己手动编译下。编译后的文件为qsqlmysql.dll，需要放在.\Qt\5.15.2\mingw81_64\plugins\sqldrivers文件夹内，并将对应版本的MySQL库libmysql.dll放入.\Qt\5.15.2\mingw81_64\bin目录中。

在Qt打印下QSqlDatabase::drivers()结果如下：
```
"QSQLITE", "QODBC", "QODBC3", "QPSQL", "QPSQL7"
```

默认是不包含Mysql的插件驱动。
如果使用QSqlDatabase::addDatabase("QMYSQL")去加载插件，就会报下面的错误：
```
QSqlDatabase: QMYSQL driver not loaded
QSqlDatabase: available drivers: QSQLITE QODBC QODBC3 QPSQL QPSQL7
```

### 解决办法
1. 若在安装Qt时勾选了源码，则在.\Qt\5.15.2\Src\qtbase\src\plugins\sqldrivers\mysql目录下，若无源码，则下载地址：https://download.qt.io/archive/qt/5.12/5.12.6/submodules/

2. 打开mysql.pro工程，会遇到以下错误：
```
Project ERROR: Library 'mysql' is not defined.
Cannot read D:/qtsqldrivers-config.pri: No such file or directory
```

3. 修改mysql.pro文件
```
# 1. 将其注释掉
#QMAKE_USE += mysql

# 2.1 添加mysql头文件及库路径
INCLUDEPATH += D:/ProgramFiles/MySQL/mysql-5.7.40-winx64/include
LIBS += D:/ProgramFiles/MySQL/mysql-5.7.40-winx64/lib/libmysql.lib

# 2.2 可尝试（本人当时无此代码
win32:CONFIG(release, debug | release): LIBS += -LD:/Program/mysql-5.7.9-winx64/lib/ -llibmysql
else:win32:CONFIG(debug, debug | release): LIBS += -LD:/Program/mysql-5.7.9-winx64/lib/ -llibmysql
INCLUDEPATH += D:/D:/Program/mysql-5.7.9-winx64/include

# 3. 指定编译的目标路径（可不加
DESTDIR = $$PWD/build
```

4. 解决报错：
```
Cannot read H:/qtsqldrivers-config.pri: No such file or directory。
```
打开.\Qt\5.15.2\Src\qtbase\src\plugins\sqldrivers\qsqldriverbase.pr文件
```
# 将qtsqldrivers-config.pri修改为configure.pri
include($$shadowed($$PWD)/qtsqldrivers-config.pri)
```

5. 编译运行
```
1. 可直接使用Qt Creator构建
2. 进去到.\Qt\5.15.2\Src\qtbase\src\plugins\sqldrivers\mysql目录下
$ qmake
$ mingw32-make.exe
```
编译的文件在.\plugins\sqldrivers目录下。

6. 总结：

使用了Qt sql模块来操作MySQL数据库，需要三个库文件来支持，分别为：libmysql.dll、qsqlmysql.dll文件和qsqlmysqld.dll文件，三个文件缺一不可。若在Qt安装路径的插件文件夹路径下（D:\ProgramFiles\Qt\5.13.0\mingw73_32\plugins\sqldrivers）找不到对应的驱动扩展，那么就需要编译相应的驱动扩展文件到相应路径。同时要将用于与MySQL连接的扩展包：mysql-connector-c-6.1.3-win32文件下的libmysql.dll库文件复制到Qt构建套件路径D:\ProgramFiles\Qt\5.13.0\mingw73_32\bin文件夹中，确保能与MySQL连接成功。

7. 官方说明

https://doc.qt.io/qt-5/sql-driver.html#qmysql-for-mysql-4-and-higher