# C/C++ DLL 导出接口保护（匿名导出）

## C/C++ 导出 DLL 函数的一般方法

通常项目中导出 DLL 接口有两种方式：

1. `__declspec(dllexport)` 导出；

2. `*.def` 文件导出。

### 1. `__declspec(dllexport)` 导出

在 DLL 导出的函数名称前使用 `__declspec(dllexport)` 关键字导出函数接口。

*test_dll.h*

```c++
// test_dll.h
#ifdef __cplusplus
extern "C" {
#endif
#ifdef DLL_EXPORT
#else
#define DLL_EXPORT _declspec(dllexport)
#endif
DLL_EXPORT int add(int a, int b);
DLL_EXPORT int sub(int a, int b);
#ifdef __cplusplus
}
#endif
```

*test_dll.cpp*

```c++
// test_dll.cpp
#include "test_dll.h"
int add(int a, int b)
{
return a + b;
}
int sub(int a, int b)
{
return a - b;
}
```

### 2. `*.def` 文件导出

由于 `__declspec(dllexport)` 导出接口需要定义一长串的内容，所以 MS 引入`*.def`来导出函数接口。
使用 `*.def` 相对简单，只需要在项目中增加一个后缀名为 .def 的文件，按照格式将 DLL 需要导出的接口定义在 def 文件即可

**1. 定义 .def 文件**

*test_dll.def*

```
LIBRARY test_dll
EXPORTS
	add @1
	sub @2
```

- DllName 表示DLL的文件名
- @1 [可选] 指定导出的函数序号。导出多个函数时，需要开发者自定义序号，不能重复

**2. 添加 .def 文件至工程**

**3. 设置工程属性**

在 “属性” -> “链接器” -> “输入” 中，输入 .def 文件名称（test_dll.def）