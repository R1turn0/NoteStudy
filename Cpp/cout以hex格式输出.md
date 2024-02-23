# C++ 中使用 std::cout 以 hex 格式输出

```cpp
#include <iomanip>
std::cout << "0x"<< std::hex << std::setiosflags(std::ios::uppercase) << std::setfill('0') << std::setw(2) << data_buffer << std::endl;
```

其中 `std::hex` 设置以16进制输出