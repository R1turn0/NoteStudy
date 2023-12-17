# C++ Lambda表达式

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
[](int x, int y){ return x + y; }
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
auto f1 = [a]() { a++; } //报错

//使用mutable修饰
auto f2 = [a]() mutable { a++; } //成功
```

## 六、Lambda表达式的异常说明符

Lambda表达式的异常说明符值为`noexcept`，其意义是指明表达式不会抛出异常；如果不需要此操作，则可以省略此项。

```
//未用noexcept修饰
auto f1 = [](int x){    
    if(x == 0) throw(0); //成功
    return x;
}

//使用noexcept修饰
auto f2 = [](int x) noexcept {
    if(x == 0) throw(0); //报错
    return x;
}
```