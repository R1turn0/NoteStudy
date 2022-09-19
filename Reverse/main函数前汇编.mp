# ***汇编基础***



## 反汇编识别main函数

### main函数之前做了什么

- GetVersion 取得系统版本号
- _heap_init 堆空间初始化
- GetCommandLineA 取得命令行参数串首地址
- _crtGetEnVironmentStringsA 取得环境变量串首地址
- _setargv 参数分析，填充argc、argv
- _setenvp 环境变量分析，填充environ
- _cinit 初始化全局数据和浮点寄存器
- mainret = main(_argc, _argv, _enciron); 调用main函数
- exit(mainret); 退出程序



## Win32系统下的寄存器

### 通用寄存器

*RAX = ? + EAX = ? + AX = AH + AL*

EAX: 累加寄存器

```汇编
mov		eax, dword ptr[ebp-4]		// 方括号内存地址为取地址，地址大小由方括号前指定。例如dword为双字，所以取32位（单字16位）
add		 eax, 1
mov		dword ptr[ebp-4], eax
```

EBX: 基址寄存器

```汇编
mov		eax, dword ptr[ebx+8]
```

ECX: 计数寄存器

```汇编
mov		ecx, 0Ah		// 循环次数在ecx中指定
label:
add	 	eax, ed
loop		label		// loop为循环操作，此处语义为循坏跳回到label
```

EDX: 数据寄存器

```汇编
mov		ebx, 10h
div 		 ebx		// div为除法操作，隐含操作数eax保存被除数低32位，高32位保存在edx中
						// 除法操作结果：熵保存在eax中，余数保存在edx中）
```



### 变址寄存器

ESI: 源变址寄存器

EDI: 目的变址寄存器

```汇编
mov				 ecx, 10h
rep movs		dword ptr[edi], dword ptr[esi]		
		// rep movs重复移动，句意为将esi内的数据拷贝到edi中，一次拷贝dword ptr位，拷贝ecx次，每拷贝一次ecx减一，一般用作字符串拷贝
```



### 指针寄存器

EBP: 基址指针寄存器（常与ESP一起使用）

ESP: 堆栈指针寄存器（经常变化）

EIP: 指令指针寄存器（下一次要执行的指令的地址）

```汇编
push		esp
mov			ebp, esp		// esp经常变化，所以将esp存入ebp中
sub			esp, 0Ch
push 		esi
push 		edi
cmo			dword ptr[ebp+8], 0		// 对变量进行寻址时，通过对ebp的偏移实现
```



### 标志寄存器EFLAGS

| 15   | 14   | 13   | 12   | 11   | 10   | 9    | 8    | 7    | 6    | 5    | 4    | 3    | 2    | 1    | 0    |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
|      |      |      |      | OF   | DF   | IF   |      | SF   | ZF   |      | AF   |      | PF   |      | CF   |

*标志寄存器通常也为32位，常用位低16位中的8位*

OF: 溢出标志。溢出时置1，否则置0

DF: 方向标志。串处理指令的方向

IF: 中断标志。

AF: 辅助进位标志。进位时置1，否则置0

**ZF: 零标志。运算结果为0时置1，否则置0**

SF: 符号标志。结果为负时置1，否则置0

CF: 进位标志。进位时置1，否则置0

PF: 奇偶标志。结果操作数中1的个数为偶数时置1，否则置0





## 寻址方式

- 立即寻址
  - 常量赋值
  - mov        eax, 10h

- 直接寻址
  - 读写变量
  - mov        eax, [00304C18h]
- 寄存器寻址
  - 指针解引用
  - mov        eax, [esi]
- 寄存器相对寻址
  - 访问数组和结构
  - mov        eax, [esi+0Ch]
- 基址加变址寻址
  - 访问数组
  - mov        eax, [ebp+esi]
- 相对基址加变址寻址
  - 访问结构
  - mov        eax, [ebx+edi-18h]



## 指令格式

- Intel格式
  - 操作码	目的操作数，源操作数
  - mov        eax, [edx]               ;// 把地址edx处的值传入eax
- AT&T格式
  - 操作码	源操作数，目的操作数
  - mov        (%edx), %eax         ;// 把地址edx处的值传入eax



## 常用汇编指令

```汇编
MOV：	数据传送
XCHG：	数据交换
PUSH：	压栈
POP：	出栈
LEA：	取地址
CMP：	比较指令
TEST：	测试指令
JMP：	无条件跳转
JZ/JNZ/…：条件转移
CALL：	函数调用
NEG：	取反指令
INC：	加1指令
DEC：	减1指令
ADD：	加法指令
SUB：	减法指令
MUL：	无符号乘法
DIV：	无符号除法
AND：	逻辑与
OR：		逻辑或
NOT：	逻辑非
XOR：	异或指令
SHL：	逻辑左移
SHR：	逻辑右移
```



## C++内联汇编

***C/C++代码中嵌入汇编语言***

```C/C++
__asm {
	;汇编指令
}
```



### C++入口函数

- C/C++语法入口
  - 控制台程序：main
  - Windows程序：WinMain
- C/C++代码入口
  - 控制台程序
    - ASCII: mainCRTStartup
    - UINcode: wmainCRTStartup
  - Windows程序
    - ASCII: WinMainCRTStartup
    - UINCODE: wWinMainCRTStartup
