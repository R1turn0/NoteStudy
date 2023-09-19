# 使用Bat脚本申请管理员权限

使用场景：用户如果需要一些管理员权限的场景，防止用户在执行的时候不是右键管理员权限运行的，从而在bat脚本中申请管理员权限

命令：

```
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
```

### 遇到问题：

申请管理员权限后，工作目录`%CD%`

