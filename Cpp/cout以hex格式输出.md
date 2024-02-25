# C++ 中使用 std::cout 以 hex 格式输出

```cpp
#include <iomanip>
std::cout << "0x"<< std::hex << std::setiosflags(std::ios::uppercase) << std::setfill('0') << std::setw(2) << data_buffer << std::endl;
```

其中 `std::hex` 设置以16进制输出

`std::setiosflags(std::ios::uppercase)` 设置16进制大写输出

| setiosflags各参数定义        |                  |
| ---------------------------- | ---------------- |
| setiosflags(ios::fixed)      | 固定的浮点显示   |
| setiosflags(ios::scientific) | 指数表示         |
| setiosflags(ios::left)       | 左对齐           |
| setiosflags(ios::right)      | 右对齐           |
| setiosflags(ios::skipws      | 忽略前导空白     |
| setiosflags(ios::uppercase)  | 16进制数大写输出 |
| setiosflags(ios::lowercase)  | 16进制小写输出   |
| setiosflags(ios::showpoint)  | 强制显示小数点   |
| setiosflags(ios::showpos)    | 强制显示符号     |