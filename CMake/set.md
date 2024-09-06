# CMake 之 SET 命令

[TOC]

## 一、概况

`set` 和 `unset` 是一对相反的指令，分别为设置变量以及取消设置变量

## 二、set 的种类

### 1. 设置一般变量（Set Normal Variable）

```CMake
set(<variable> <value> ... [PARENT_SCOPE])
```

**1.1 参数解析：**

1. 将一个或者多个值 \<value\>... 赋值给变量 \<variable\>， 多个值之间以分号（；）分隔。
2. PARENT_SCOPE: 配置该选项后，表示该变量在父级作用域上有效, 在当前作用域上是无效的

### 2. 设置缓存变量（Set Cache Entry）

```CMake
set(<variable> <value>... CACHE <type> <docstring> [FORCE])
```

**2.1 参数解析：**

1. 类型 `type` 必须为以下几种的一种
   - `BOOL` 布尔值
   - `FILEPATH` 文件路径
   - `PATH` 目录路径
   - `STRING` 字符串
   - `INTERNAL` 单行文字
2. 描述字符串 `<docstring>`: 单行文字，用于 CMAKE-GUI 的时提示用户
3. `FORCE` 用于是否强制更新缓存里面的值，配置后，每次都会强制更新 `CMakeCache.txt` 里面的值

### 3. 设置环境变量（Set Environment Variable）

```CMake
set(ENV{<variable>} [<value>])
```

**3.1 作用**

1. 设置环境变量 `<variable>`，值为 `<value>`
2. 如果 `<value>` 不存在或者为空字符串，表示清除该环境变量

## 三、变量的作用域

1. **Function Scope**: 在函数内部定义,仅仅在当前函数以及所调用的子函数内有效
2. **Directory Scope**: 在当前目录的定义的变量,当调用子目录时候,子目录会复制一份父级目录内的变量到子目录中
3. **Persistent Cache**: 持久化的缓存,一般由 `CACHE` 存储起来

## 四、变量的搜索路径

1. 在当前 **Function Scope** 调用内查找,找到后使用,未找到进行下一步
2. 在当前目录下面查找,找到使用,未找到下一步
3. 在 CACHE 中寻找,找到使用,未找到,则为空

## 五、环境变量与一般变量的区别

[【参考】](https://cmake.org/cmake/help/latest/manual/cmake-language.7.html#cmake-language-variables)

