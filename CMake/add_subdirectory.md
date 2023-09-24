# add_subdirectory

在一个CMake项目中包含多个子项目时，通常使用`add_subdirectory`命令将每个子项目添加到主项目的CMakeLists.txt文件中。然后，你可以使用CMake来构建整个项目，一次性编译所有子项目和主项目。

以下是一个示例CMakeLists.txt文件的结构，演示了如何组织一个主项目和两个子项目的情况：

```
# 主项目的CMakeLists.txt

# 指定CMake的最低版本要求
cmake_minimum_required(VERSION 3.0)

# 项目名称
project(MainProject)

# 添加子项目1
add_subdirectory(subproject1)

# 添加子项目2
add_subdirectory(subproject2)

# 主项目的源代码
add_executable(main main.cpp)

# 链接子项目1和子项目2的库
target_link_libraries(main subproject1_library subproject2_library)
```

在这个示例中，主项目的CMakeLists.txt文件包括两个子项目（subproject1和subproject2）。每个子项目都有自己的CMakeLists.txt文件。

接下来，让我们看看子项目1的CMakeLists.txt文件：

```
# 子项目1的CMakeLists.txt

# 子项目1的源代码文件
add_library(subproject1_library STATIC subproject1.cpp)

# 指定头文件目录
target_include_directories(subproject1_library PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

# 如果有其他依赖项，可以在此处添加
```

子项目2的CMakeLists.txt文件结构类似于子项目1。

然后，你可以使用以下命令构建整个项目：

```
mkdir build
cd build
cmake ..
make
```

这将构建主项目以及其所有子项目。主项目的可执行文件（在本例中为main）将链接到子项目1和子项目2的库。

请注意，每个子项目可以有自己的构建设置和依赖项。如果子项目之间有依赖关系，确保在主项目的CMakeLists.txt文件中以正确的顺序添加子项目，以确保依赖关系正确解析和构建。