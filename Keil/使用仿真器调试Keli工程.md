# 使用仿真器调试Keil工程

### 一. 工程设置

​		鼠标右键单击 Project Workspace 下面的“Target”，弹出菜单栏中选择“Options for Target 'Target 1'”项。

**1.更改Target选项卡中的Memory Model为Large: variables in XDATA**

![Target](Photo\Target.png)



**2. 勾选Output选项卡中的Create HEX File选项，将HEX_Format更改为HEX-80**

![Output](Photo\Output.png)



**3. 勾选Debug选项卡“Use:”，并更选项为“Elite-E Simulator”**

​	**在Driver DLL中填入S8051.DLL**

​	**在Dialog DLL中填入TP51.DLL，Parameter中填入-p52**

![Debug](Photo\Debug.png)



### 二. 编译工程

​		程序修改完毕之后，需要编译工程，编译的方法是选择菜单“ Progect”→“ Rebuildall target files”

如果工程编译成功，在 Keil 编译器下面的 Build 窗口会出现图 4-11 所示的内容，否则将提示相应的错误信息。



### 三. 编译失败问题排查

​		调试过程中如果出现精锐 E 执行错误对话框，除了查看错误代码外，可能还需要检查左侧 Workspace 区域的 Regs 窗口，如图所示。

![Project_Workspace](Photo\Project_Workspace.png)

**Regs 窗口中显示的是当前 CPU 的寄存器列表**

​		R0~R7 是通用寄存器，

​		同时 R0~R1 也是内部内存(IRAM)间接寻址寄存器，

​		dptr 是外部内存（XRAM）间接寻址寄存器，

​		sp 是堆栈指针 ，

​		PC 是程序指针。

|    ---    |                       ---                       |
| :-------: | :---------------------------------------------: |
| dptr 越界 | （正常值在 0x0000~0x07ff 和0xf000~0xf0f7 之间） |
|  SP 溢出  |       (正常值在 0x07~0xff 之间，向上增长)       |
|  PC 越界  |              （超出有效代码范围）               |



​		从调试状态退出的方法和进入调试状态的方法相同，选择菜单“Debug”菜单下的“Start/Stop Debug Session”或者单击工具条上的![StartOrStopDebugSession](Photo\StartOrStopDebugSession.png)图标就可以退出调试状态。