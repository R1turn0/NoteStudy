# C++ Lambda表达式

[TOC]

## 一、Lambda表达式的介绍

c++11引入了Lambda表达式，使得开发人员可以更方便的创建匿名函数。Lambda表达式是c++语言的一个重要特性，它可以作为函数对象使用，可以用来替代一些繁琐的函数声明和定义。

## 二、Lambda表达式的语法

Lambda表达式的基本语法结构如下：

```
[capture list](parameter list) specifiers exception -> type { function body }
```

- [capture list]是捕获列表，在应用中必填
- (parameter list)是参数列表，在应用中选填
- specifiers是限定符，在应用中选填
- exception是异常说明符，在应用中选填
- -> type是返回值类型，在应用中选填
- { function body }是表达式的函数体，在应用中必填

 下面是一个简单的Lambda表达式： 

```
[](int x, int y) -> int { return x + y; };
```

这个Lambda表达式可以看作是一个没有函数名的函数，接受两个整型参数，并返回它们的和。应用实例如下：

```
auto f = [](int x, int y){ return x + y; };
int result = f(10, 20);    //result == 30
```

## 三、Lambda表达式的捕获列表

Lambda表达式的捕获列表可以捕获当前函数作用域的零个或多个变量，变量之间用逗号分隔；这些变量可以在Lambda表达式中被访问和修改。捕获方式有三种，分别是值捕获、引用捕获和混合捕获。

### 值捕获

将外部变量以const引用的方式传递到Lambda表达式中，在表达式中可以访问变量，但是不能修改变量；使用=可以将函数作用域的所有变量以值捕获方式传入到表达式中。

```
int a = 10; b = 20, c = 30;

//将变量a和b以值捕获方式传入到表达式中
auto f1 = [a, b] { return a + b; };
int result1 = f1();    //result1 == 30

//将所有变量以值捕获方式传入到表达式中
auto f2 = [=] { return a + b + c; };int result2 = f2();    //result2 == 60
```

### 引用捕获

将外部变量以引用的方式传递到Lambda表达式中，在表达式中可以访问变量和修改变量；使用&可以将函数作用域的所有变量以引用捕获方式传入到表达式中。

```
int a = 10; b = 20, c = 30;

//将变量a和b以引用捕获方式传入到表达式中
auto f1 = [&a, &b] { a++; b++; };
f1();    
//a == 11    b == 21

//将所有变量以引用捕获方式传入到表达式中
auto f2 = [&] { a++; b++; c++; };
f2();    
//a == 12    b == 22    c == 31
```

### 混合捕获

捕获列表捕获多个变量，既有值捕获的变量也有引用捕获的变量。

```
int a = 10, b = 20, c = 30;

//将变量a和b以值捕获方式传入到表达式中，将变量c以引用捕获方式传递到表达式中
auto f = [=, &c] { c++; return a + b; };
int result = f();    //result == 30//c == 31
```

## 四、Lambda表达式的参数列表

Lambda表达式的参数列表与普通函数参数列表一致；如果不需要参数，则可以省略此项。

```
//没有参数
auto f1 = [] { return 1; };
int result1 = f1();    //result1 == 1

//两个参数
auto f2 = [](int x, int y) { return x + y; };
int result2 = f2(10, 20);    //result2 == 30
```

## 五、Lambda表达式的限定符

Lambda表达式的限定符值为`mutable`，其意义是可以在函数体内修改按值捕获的变量；如果不需要此操作，则可以省略此项。

```
int a = 10;

//未用mutable修饰
auto f1 = [a]() { a++; }; //报错

//使用mutable修饰
auto f2 = [a]() mutable { a++; }; //成功
```

## 六、Lambda表达式的异常说明符

Lambda表达式的异常说明符值为`noexcept`，其意义是指明表达式不会抛出异常；如果不需要此操作，则可以省略此项。

```
//未用noexcept修饰
auto f1 = [](int x){    
    if (x == 0) throw(0); //成功
    return x;
};

//使用noexcept修饰
auto f2 = [](int x) noexcept {
    if (x == 0) throw(0); //报错
    return x;
};
```

## 七、Lambda表达式的返回值类型

用`-> type`可以指定lambda表达式返回值类型；如果不指定返回类型，则编译器会根据代码实现为函数推导一个返回类型；如果没有返回值，则可忽略此部分。

```
//指定返回值类型
auto f1 = []() -> int { return 1; };
int result1 = f1();    //result == 1

//不指定返回值类型
auto f2 = []() { return 1; };
int result2 = f2();    //result == 1
```

## 八、Lambda表达式的函数体

Lambda表达式的函数体部分与普通函数体一致。

```
auto f1 = [] { std::cout << "hello world" << std::endl; };

auto f2 = [](int x, int y) { return x + y; };
```

## 九、Lambda表达式的优缺点

**Lambda表达式有以下优点：**

1. 简洁：Lambda表达式可以在一个表达式中定义一个函数，不需要单独声明和定义。
2. 方便：Lambda表达式可以捕获外部变量，使得函数对象更加灵活和易于使用。
3. 通用：Lambda表达式可以作为任何需要函数对象的地方使用，例如STL算法、线程等。

**Lambda表达式也有一些缺点：**

1. 可读性：Lambda表达式可能过于简洁，难以阅读和理解。
2. 复杂性：Lambda表达式可以包含复杂的逻辑和控制流，使得代码难以维护和调试。
3. 性能：Lambda表达式可能会产生额外的开销，例如变量捕获和函数调用的开销。

## 十、Lambda表达式的递归

由于lambda表达式的匿名特性，无法直接在lambda内部递归调用lambda，需要另寻其道来解决该问题

### 1. 使用 `std::function`

`std::function` 可以把Lambda包装起来，相当于赋予了其一个函数名，在通过引用捕获并实现递归调用，实现如下： 

```c++
#include <functional>
const auto &sum1 = [](const int &n) {
    std::function<int(const int &)> s;
    s = [&](const int &n) {
        return n == 1 ? 1 : n + s(n - 1);
    };
    return s(n);
};
```

### 2. 将Lambda作为参数

```c++
const auto &sum2 = [](const int &n) {
    const auto &s = [&](auto &&self, const int &x) -> int {
        return x == 1 ? 1 : x + self(self, x - 1);
    };
    return s(s, n);
};
```

注意到，调用s(s,n)时，我们把Lambda表达式本身作为了参数传入来实现递归调用

### 3. 使用Y组合子

构造一个Y组合子如下：

```c++
const auto &y = [](const auto &f) {
    return [&](const auto &x) {
        return x(x);
    }([&](const auto &x) -> std::function<int(int)> {
        return f([&](const int &n) {
            return x(x)(n);
        });
    });
};
```

再实现一个求和函数的高阶函数如下：

```c++
const auto &sum3 = [](const auto &f) {
    return [=](const int &n) {
        return n == 1 ? 1 : n + f(n - 1);
    };
};
```

然后连接即可