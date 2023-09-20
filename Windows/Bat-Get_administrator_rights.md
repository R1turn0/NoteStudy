# 使用Bat脚本申请管理员权限

使用场景：用户如果需要一些管理员权限的场景，防止用户在执行的时候不是右键管理员权限运行的，从而在bat脚本中申请管理员权限

命令：

```
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
```

### 遇到问题：

申请管理员权限后，工作目录`%CD%`就从当前目标变更到了`C:\system32`目录下了，导致以管理员权限启动脚本时找不到Bat脚本同级目录下的文件的情况

因此为了解决这个问题，先将Bat脚本的路径记录到`%SCRIPT_DIR%`中

```
set "SCRIPT_DIR=%~dp0"
```

### Bat脚本示例：

```
@echo off
set "SCRIPT_DIR=%~dp0"
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
start xxx.exe [/Options]
```

