# nm

## 概述

nm命令是linux下自带的特定文件分析工具，一般用来检查分析二进制文件、库文件、可执行文件中的符号表，返回二进制文件中各段的信息

## 使用

```bash
$ man nm

SYNOPSIS
       nm [-A|-o|--print-file-name]
          [-a|--debug-syms]
          [-B|--format=bsd]
          [-C|--demangle[=style]]
          [-D|--dynamic]
          [-fformat|--format=format]
          [-g|--extern-only]
          [-h|--help]
          [--ifunc-chars=CHARS]
          [-j|--format=just-symbols]
          [-l|--line-numbers] [--inlines]
          [-n|-v|--numeric-sort]
          [-P|--portability]
          [-p|--no-sort]
          [-r|--reverse-sort]
          [-S|--print-size]
          [-s|--print-armap]
          [-t radix|--radix=radix]
          [-u|--undefined-only]
          [-U method] [--unicode=method]
          [-V|--version]
          [-X 32_64]
          [--defined-only]
          [--no-demangle]
          [--no-recurse-limit|--recurse-limit]]
          [--plugin name]
          [--size-sort]
          [--special-syms]
          [--synthetic]
          [--target=bfdname]
          [--with-symbol-versions]
          [--without-symbol-versions]
          [objfile...]
```

## 示例

上述就是常用的命令参数，下面将给出一个示例来进一步理解nm用法：

1. 编写代码

```c++
// 使用命令 g++ -c test.cpp 编译
#include <iostream>
#include <string>

using namespace std;    
const char *str="downey";
int g_uninit;
int g_val=10;

void func1()
{
    int *val=new int;
    static int val_static=1;
    cout<<"downey"<<endl;
} 

void func1(char* str)
{
    cout<<str<<endl;
}
```

2. 使用 `nm` 解析

```
$ nm -n -C test.o

U __cxa_atexit
U __dso_handle
U std::ostream::operator<<(std::ostream& (*)(std::ostream&))
U std::ios_base::Init::Init()
U std::ios_base::Init::~Init()
U operator new(unsigned long)
U std::cout
U std::basic_ostream<char, std::char_traits<char> >& std::endl<char, std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&)
U std::basic_ostream<char, std::char_traits<char> >& std::operator<< <std::char_traits<char> >(std::basic_ostream<char, std::char_traits<char> >&, char const*)
0000000000000000    B g_uninit
0000000000000000    D str
0000000000000000    T func1()
0000000000000004    b std::__ioinit
0000000000000008    D g_val
000000000000000c    d func1()::val_static
0000000000000035    T func1(char*)
0000000000000062    t __static_initialization_and_destruction_0(int, int)
00000000000000a0    t _GLOBAL__sub_I_str
```

**nm输出内容解析**

下面我们再来解析输出信息中各部分所代表的意思：

- 首先，前面那一串数字，指的就是地址，如果是二进制目标文件，指的就是逻辑地址，并非程序最后运行时的地址
- 然后，我们发现，每一个条目前面还有一个字母，类似'U','B','D等等，其实这些符号代表的就是当前条目所对应的内存所在部分
- 最右边的就是对应的符号内容了

首要的需要讲解的就是第二点中字符所对应的含义，同样在还是在linux命令行下man nm指令可以得到：

```
A     ：符号的值是绝对值，不会被更改
B或b  ：未被初始化的全局数据，放在.bss段
D或d  ：已经初始化的全局数据
G或g  ：指被初始化的数据，特指small objects
I     ：另一个符号的间接参考
N     ：debugging 符号
p     ：位于堆栈展开部分
R或r  ：属于只读存储区
S或s  ：指为初始化的全局数据，特指small objects
T或t  ：代码段的数据，.test段
U     ：符号未定义
W或w  ：符号为弱符号，当系统有定义符号时，使用定义符号，当系统未定义符号且定义了弱符号时，使用弱符号
？    ：unknown符号
```

根据以上的规则，我们就可以来分析上述的nm显示结果： 

首先，输出的上半部分对应的符号全是U，跟我们常有思路不一致的是，这里的符号未定义并不代表这个符号是无法解析的，而是用来告诉链接器，这个符号对应的内容在我这个文件只有声明，没有具体实现。

如 `std::cout`, `std::string` 类，在链接的过程中，链接器需要到其他的文件中去找到它的实现，如果找不到实现，链接器就会报常见的错误：undefined reference。

关于这一部分的详解可参考程序的静态链接

在接下来的三行中

```
 0000000000000000    B g_uninit 
 0000000000000000    D str 
 0000000000000000    T func1()
```

令人疑惑的是，为什么他们的地址都是0，难道说 mcu 的 0 地址同时可以存三种数据？

其实不是这样的，按照上面的符号表规则，g_uninit 属于.bss 段，str 属于全局数据区，而 func1() 属于代码段，这个地址其实是相对于不同数据区的起始地址，即 g_uninit 在 .bss 段中的地址是 0，以此类推，而 .bss 段具体被映射到哪一段地址，这属于平台相关，并不能完全确定。
在目标文件中指定的地址都是逻辑地址，符号真正的地址需要到链接阶段时进行相应的重定位以确定最终的地址。

在接下来的四行中

```
0000000000000004    b std::__ioinit 
0000000000000008    D g_val 
000000000000000c    d func1()::val_static 
0000000000000035    T func1(char*)
```

b在全局数据段中的 4 地址，因为上述 g_uninit 占用了四字节，所以 std::__ioinit 的地址为0+4=4.

而 g_val 存在于全局数据段(D)中，起始地址为8，在程序定义中，因为在 0 地址处存放的是str指针,而我的电脑系统为64位，所以指针长度为8，则 g_val 的地址为 0 + 8 = 8

而静态变量 val_static 则是放在全局数据段 8 + sizeof(g_val) = 12 处，函数 func1(char \*) 则放在代码段 func1() 后面

讲到这里，有些细心的朋友就会疑惑了，在全局数据区(D)中存放了str指针，那 str 指针指向的字符串放到哪里去了？其实这些字符串内容放在常量区，常量区属于代码区(text)(X86平台，不同平台可能有不同策略)，对应nm显示文件的这一部分：

```
00000000000000a0    t _GLOBAL__sub_I_str 
```

如果对此有一些疑惑，可以尝试将 str 字符串放大，甚至是改成上千个字节的字符串，就会看到代码段(t)的变化

