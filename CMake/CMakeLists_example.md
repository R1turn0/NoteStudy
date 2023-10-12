# CMakeLists编译项目例子

 ## main程序

```
cmake_minimum_required(VERSION 3.24)

# 设置以Clang(++)构建项目
#SET(CMAKE_C_COMPILER /usr/bin/clang)
#SET(CMAKE_CXX_COMPILER /usr/bin/clang++) 

project(Project_Name)

set(CMAKE_CXX_STANDARD 11)

# set output directory
# ${CMAKE_BINARY_DIR} -> 终端中运行cmake命令时创建的那个目录
# ${PROJECT_SOURCE_DIR} -> 当前CMake项目的根源代码目录
#set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
#set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/bin)

# set platform
if(CMAKE_SIZEOF_VOID_P EQUAL 8)
	message(STATUS "Building for 64-bit architecture")
    set(PLATFORM x64)
else()
	message(STATUS "Building for 32-bit architecture")
    set(PLATFORM x86)
endif()

set(ROOTDIR ${CMAKE_SOURCE_DIR})

link_directories(${CMAKE_SOURCE_DIR}/lib/${PLATFORM})
#link_directories(${CMAKE_SOURCE_DIR}/lib)

add_executable(${PROJECT_NAME} main.cpp inc/inc.h)

target_include_directories(${PROJECT_NAME} PRIVATE ${PROJECT_SOURCE_DIR}/inc)

target_link_libraries(${PROJECT_NAME}
    PRIVATE
        libcrypto
		libssl
)

# Custom Target Copy
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

