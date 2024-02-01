# CMakeLists编译项目例子

 ## Main程序

```
cmake_minimum_required(VERSION 3.24)

project(Project_Name)

set(CMAKE_CXX_STANDARD 11)

# ======== 设置以Clang(++)构建项目 ========
# SET(CMAKE_C_COMPILER /usr/bin/clang)
# SET(CMAKE_CXX_COMPILER /usr/bin/clang++) 

# ======== 设置输出目录（可选） ========
# ${CMAKE_BINARY_DIR} -> 终端中运行cmake命令时创建的那个目录
# ${PROJECT_SOURCE_DIR} -> 当前CMake项目的根源代码目录
# set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
# set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/bin)

# ======== 设置构建类型 ========
if(NOT CMAKE_BUILD_TYPE) # 如果用户未指定，则默认为Release
    set(CMAKE_BUILD_TYPE Release) # 等同于cmake的 -DCMAKE_BUILD_TYPE=Debug 参数
endif()

# ======== 设置平台 ========
if(CMAKE_SIZEOF_VOID_P EQUAL 8)
	message(STATUS "Building for 64-bit architecture")
    set(PLATFORM x64)
else()
	message(STATUS "Building for 32-bit architecture")
    set(PLATFORM x86)
endif()

# ======== Judgment to build project system ========
if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    message(STATUS "Building on Linux")
    # 添加你在 Linux 构建时需要执行的操作
elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows")
    message(STATUS "Building on Windows")
    # 添加你在 Windows 构建时需要执行的操作
else()
    message(STATUS "Building on an unsupported system: ${CMAKE_SYSTEM_NAME}")
    # 可以根据需要添加其他系统的处理
endif()

# ======== 控制是否在构建期间使用安装时的 RPATH 信息 ========
set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
# 设置安装后二进制文件的运行时搜索路径（RPATH）
set(CMAKE_INSTALL_RPATH "\${ORIGIN}/lib")

# ======== CMAKE_EXE_LINKER_FLAGS 用于设置可执行文件的链接器标志 ========
# 用于将C++运行时库（libstdc++）和C运行时库（libgcc）静态链接到可执行文件中
# set(CMAKE_EXE_LINKER_FLAGS "-static-libgcc -static-libstdc++")

# ======== 查找第三方库 ========
# find_pakage(ThirdPartyLib REQUIRED)

# ======== 添加库文件搜索路径 ========
link_directories(${CMAKE_SOURCE_DIR}/lib/${PLATFORM})

# ======== 添加头文件搜索路径 ========
include_directories(${CMAKE_SOURCE_DIR}/inc/)

# ======== 添加子目录（可选） ========
# add_subdirectory(subdirectory)

# ======== 安装规则（可选） ========
#install(TARGETS YourExecutableName DESTINATION bin)

# ======== 安装头文件（可选） ========
# install(DIRECTORY include/ DESTINATION include)

# ======== 自动生成源文件的依赖关系（可选） ========
# set_property(TARGET YourExecutableName PROPERTY CXX_STANDARD 11)
# set_property(TARGET YourExecutableName PROPERTY CXX_STANDARD_REQUIRED ON)
# set_property(TARGET YourExecutableName PROPERTY CXX_EXTENSIONS OFF)

# ======== 添加源文件 ========
# 1. 指令include_directories和link_directories需要在add_executable前调用
# 2. 指令target_link_libraries需要在add_executable或add_library后边调用
add_executable(${PROJECT_NAME} main.cpp)

target_include_directories(${PROJECT_NAME} PRIVATE ${PROJECT_SOURCE_DIR}/inc)

target_link_libraries(${PROJECT_NAME}
    PRIVATE
        libcrypto
		libssl
)

# ======== Custom Target Copy ========
# $<TARGET_RUNTIME_DLLS:${PROJECT_NAME}>
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_SOURCE_DIR}/lib/${PLATFORM}/libcrypto-3-x64.dll $<TARGET_FILE_DIR:${PROJECT_NAME}>
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_SOURCE_DIR}/lib/${PLATFORM}/libssl-3-x64.dll $<TARGET_FILE_DIR:${PROJECT_NAME}>
        COMMAND_EXPAND_LISTS
)
```



## 编译静态库与动态库

```
cmake_minimum_required(VERSION 3.20)
project(LIBDoubleArrayAverage C)

# ====设置变量=====
# LIBHELLO_SRC：lib库源文件
SET(LIBAVERAGE_SRC ./DoubleArrayAverage.c ./DoubleArrayAverage.h)
# CMAKE_LIBRARY_OUTPUT_DIRECTORY：编译动态库最终输出目录
SET(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/lib_out)
# CMAKE_ARCHIVE_OUTPUT_DIRECTORY：编译静态库最终输出目录
SET(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/lib_out)

# 第一个参数为你需要构建的dll的名字，第二个为类型
ADD_LIBRARY(libmyDll SHARED ${LIBAVERAGE_SRC})
ADD_LIBRARY(libmyLib STATIC ${LIBAVERAGE_SRC})
# SHARED，动态库(扩展名为.so)
# STATIC，静态库(扩展名为.a)
# MODULE，在使用dyld的系统有效，如果不支持dyld，则被当作SHARED对待。
# EXCLUDE_FROM_ALL 参数的意思是这个库不会被默认构建，除非有其他的组件依赖或者手工构建。

# 依赖有别的动态库时
#TARGET_LINK_LIBRARIES(myDll lib1 lib2)

# 然后使用INSTALL指定了目标my_dll
INSTALL(TARGETS libmyDll)
INSTALL(TARGETS libmyLib)

# 为dll设置linker
# 指定dll的生成目录，这里是：./lib_out
SET_TARGET_PROPERTIES(libmyDll PROPERTIES LINKER_LANGUAGE C
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}
        OUTPUT_NAME "libmyDll"
        PREFIX "")
SET_TARGET_PROPERTIES(libmyLib PROPERTIES LINKER_LANGUAGE C
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}
        OUTPUT_NAME "libmyLib"
        PREFIX "")
# PROPERTIES LINKER_LANGUAGE C：声明为C链接库，提高DLL库的兼容性；
# XXX_OUTPUT_DIRECTORY：指定输出命令；
# OUTPUT_NAME：DLL库输出名称；
# PREFIX：DLL库前缀，若不设置，可能会加默认前缀；如，cygmy_dll.dll
```

