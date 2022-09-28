# Visual Studio 2010：Error MSB 8008

### visual studio 2010 编译报MSB8008错误解决方法

Q：编译（build）时，报错：error msb8008：指定的平台工具集（v142）未安装或无效

A：指定项目点击右键properties ->Configuration Properties -> General -> Platform Toolset ,选v142或者你当前选项下已下载的（我编译时选的v100，最后编译通过了）
（打开项目属性->配置属性->常规 -> 平台工作集，选为v140）
报错原因：之前在不同版本的visual studio上编译过，所以才会报错，版本不兼容问题

![Error_MSB8008](D:\WorkSpace\Error\Cpp\Elite4sNet异常_Error_MSB8008\Error_MSB8008.png)

![解决方案](D:\WorkSpace\Error\Cpp\Elite4sNet异常_Error_MSB8008\解决方案.png)



***注意***：

*如果点击右键属性（properties）没有常规，平台工具集这一选项，那么就需要看一下你点击是否是项目以及你的项目是什么类型*

