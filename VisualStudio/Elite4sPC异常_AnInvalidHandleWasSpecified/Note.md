# 已引发的异常：0xC0000008: An invalid handle was specified 的原因与解决方案

## 1. 描述

![Elite4s异常_AnInvalidHandleWasSpecified](D:\WorkSpace\Error\Cpp\0xC0000008_AnInvalidHandleWasSpecified\Elite4s异常_AnInvalidHandleWasSpecified.png)

异常引发之后无论是点击“继续”或者“忽略”都能继续运行，不会崩溃，再次单击打开结点时候又会弹出相同的异常。。。
但是直接找到工程目录下的exe文件（无论是Debug还是Release）都能够正常运行，或者是Ctrl + F5，说明只有调试的时候才会显示这个错误。 

## 2. 解决方案

#### (1) Closehandle错误

程序中查找文件没有使用CFileFind类而是直接使用[API](https://so.csdn.net/so/search?q=API&spm=1001.2101.3001.7020)函数::FindFirstFile和::FindNextFile。这两个函数要用到HANDLE文件句柄，一定要注意必须使用::FindClose来关闭由::FindFirstFile返回的文件句柄，停止一个::FindFirstFile/::FindNextFile序列，而不能直接使用::CloseHandle。

   将代码中的::CloseHandle改为::FindClose后在VC8环境下程序也正常了。

```c++
BOOL FindClose( 
　　HANDLE hFindFile // file search handle 
　　); 
　　功能说明 
　　关闭FindFirstFile创建的搜索句柄 
　　参数说明 
　　HANDLE hFindFile FindFirstFile创建的句柄 
　　返回值 
　　调用成功 返回一个非0值 
　　失败 返回0 可利用GetLastError来得到错误信息
```



#### (2) Overlaycon.dll错误 ？

可能原因：Wuala / Wuala OverlayIcons 将软件整合到explorer中，而GetSaveFileName需要调用explorer，所以加载了Overlaycon.dll