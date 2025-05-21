# C++ 模板元编程--可变参数模板

[TOC]

## 可变模板的参数展开

可变参数模板和普通模板的语义是一样的，只是写法上稍有区别，声明可变参数模板时需要在 `typename` 或 `class` 后面带上省略号「...」。比如我们常常这样声明一个可变模板参数： `template<typename...>` 或者 `template<class...>`，一个典型的可变模板参数的定义是这样的：

```C++
template <typename... T>
void f(T... args);
```

上面的可变模板参数的定义当中，省略号的作用有两个：

声明一个参数包 `T... args`，这个参数包中可以包含 `0` 到任意个模板参数；
在模板定义的右边，可以将参数包展开成一个一个独立的参数。
上面的参数 `args` 「前面」有省略号，所以它就是一个可变模板参数，我们把带省略号的参数称为“参数包”，它里面包含了 `0` 到 `N` （N>=0）个模板参数。我们无法直接获取参数包 `args` 中的每个参数的，只能通过「展开参数包」的方式来获取参数包中的每个参数，这是使用可变模板参数的一个「主要特点」，也是「最大的难点」，即如何展开可变模板参数。

可变模板参数和普通的模板参数语义是一致的，所以可以应用于函数和类，即「可变参数模板函数」和「可变参数模板类」，然而，**模板函数不支持偏特化**，所以可变参数模板函数和可变参数模板类展开可变参数的方法还不尽相同，下面我们来分别看看他们展开可变参数的方法。

### 1. 可变参数函数模板
一个简单的可变参数函数模板：

```C++
#include <iostream>
using namespace std;

template<typename... Args>
void f(Args... args) {
    cout << sizeof...(args) << endl;
}

int main() {
    f();        // 0
    f(1, 2);    // 2
    f(1, 2, "");// 3
    return 0;
}
```

上面的例子中， `f()` 没有传入参数，所以参数包为空，输出的 size 为0，后面两次调用分别传入两个和三个参数，故输出的 size 分别为2和3。由于可变模板参数的类型和个数是不固定的，所以我们可以传任意类型和个数的参数给函数f。这个例子只是简单的将可变参数模板的个数打印出来，如果我们需要将参数包中的每个参数打印出来的话就需要通过一些方法了。展开可变模板参数函数的方法一般有两种：

一种是通过「递归函数」来展开参数包
另外一种是通过「逗号表达式」来展开参数包
下面来看看如何用这两种方法来展开参数包。

#### a) 递归函数方式展开参数包

通过递归函数展开参数包，需要提供一个「参数包展开的函数」和一个「递归终止函数」，递归终止函数正是用来终止递归的，来看看下面的例子。

```C++
#include <iostream>
using namespace std;

// @note 递归终止函数
void print() {
    cout << "empty" << endl;
}

// @note 展开函数
template<typename T, typename... Args>
void print(T head, Args... args) {
    cout << "parameter " << head << endl;
    print(args...);
}

int main() {
    print(1, 2, 3, 4);
    return 0;
}
```


上例会输出每一个参数，直到为空时输出 `empty`。展开参数包的函数有两个，一个是递归函数，另外一个是递归终止函数，参数包 `Args...` 在展开的过程中递归调用自己，每调用一次参数包中的参数就会少一个，直到所有的参数都展开为止，当没有参数时，则调用非模板函数 `print` 终止递归过程。

递归调用的过程是这样的：

```C++
print(1,2,3,4);
print(2,3,4);
print(3,4);
print(4);
print();
```

上面的递归终止函数还可以写成这样：

```C++template<typename T>
void print(T t) {
    cout << t << endl;
}
```

修改递归终止函数后，上例中的调用过程是这样的：

```C++print(1, 2, 3, 4);
print(2, 3, 4);
print(3, 4);
print(4);
```

当参数包展开到最后一个参数时递归终止。

再看一个通过可变模板参数求和的例子：

```C++
#include <iostream>
using namespace std;

template<typename T>
T sum(T t) {
    return t;
}

template<typename T, typename... Types>
T sum(T first, Types... rest) {
    return first + sum<T>(rest...);
}

int main() {
    cout << sum(1, 2, 3, 4) << endl;    // 10
    return 0;
}
```

`sum` 在展开参数包的过程中将各个参数相加求和，参数的展开方式和前面的打印参数包的方式是一样的。

#### b) 逗号表达式展开参数包

递归函数展开参数包是一种标准做法，也比较好理解，但也有一个缺点,就是「必须」要一个重载的递归终止函数，即「必须」要有一个同名的终止函数来终止递归，这样可能会感觉稍有不便。有没有一种更简单的方式呢？其实还有一种方法可以不通过递归方式来展开参数包，这种方式需要借助「逗号表达式」和「初始化列表」。比如前面print的例子可以改成这样：

```C++
#include <iostream>
using namespace std;

template<typename T>
void printArg(T t) {
    cout << t << endl;
}

template<typename... Args>
void expand(Args... args) {
    int arr[] = {(printArg(args), 0)...};
}

int main() {
    expand(1, 2, 3, 4);
    return 0;
}
```

这个例子将分别打印出1、2、3、4四个数字。这种展开参数包的方式，「不需要」通过递归终止函数，是直接在expand函数体中展开的,printArg不是一个递归终止函数，只是一个处理参数包中每一个参数的函数。这种就地展开参数包的方式实现的关键是逗号表达式。我们知道逗号表达式会按顺序执行逗号前面的表达式，比如：

```C++
d = (a = b, c);
```

这个表达式会按顺序执行：b会先赋值给a，接着括号中的逗号表达式返回c的值，因此d将等于c。

expand 函数中的逗号表达式：

```C++
(printArg(args), 0)
```

也是按照这个执行顺序，先执行 `printArg(args)`，再得到逗号表达式的结果0。同时还用到了C++11的另外一个特性：「初始化列表」，通过初始化列表来初始化一个「变长数组」：

```C++
{(printArg(args), 0)...}
```

将会展开成

```C++
{((printArg(arg1), 0), (printArg(arg2), 0), (printArg(arg3), 0),  etc...)}
```

最终会创建一个元素值都为0的数组 `int arr[sizeof...(Args)]`。由于是逗号表达式，在创建数组的过程中会先执行逗号表达式前面的部分 `printArg(args)` 打印出参数，也就是说在构造int数组的过程中就将参数包展开了，这个数组的目的纯粹是为了在数组构造的过程展开参数包。我们可以把上面的例子再进一步改进一下，将函数作为参数，就可以支持 `lambda` 表达式了，从而可以少写一个递归终止函数了，具体代码如下：

```C++
#include <iostream>
#include <functional>
using namespace std;

template<typename T, typename ...Args>
void expand(const T &func, Args&&... args) {
    // 这里用到了完美转发
    int arr[] = { (func(std::forward<Args>(args)), 0)... };
    // initializer_list<int>{ (func(std::forward<Args>(args)), 0)... };
}

int main() {
    expand([](int i)->void{cout << i << endl;}, 1, 2, 3);
    return 0;
}
```

其实上面这里的T类型就是 `function<void int>` 类型，参数可以写成 `const function<void(int)> &func`，也可写成 `function<void(int)> func`，这都无妨，我们只需要知道这是引用、或者是使用了 `function` 机制即可。

上面的例子将打印出每个参数，这里如果再使用「C++14的新特性」泛型 `lambda` 表达式的话，可以写更泛化的lambda表达式了（把参数改为auto）：

```C++
expand([](auto i)->void{cout << i << endl;}, 1, 2.2, "hello");
```

### 2. 可变参数类模板

可变参数模板类是一个带可变参数的模板类，比如 C++11 中的元组 `std::tuple` 就是一个可变模板类，它的定义如下：

```C++
template<typename... Types>
class tuple;
```

这个可变参数模板类可以携带任意类型任意个数的模板参数：

```C++
std::tuple<int> tp1 = std::make_tuple(1);
std::tuple<int, double> tp2 = std::make_tuple(1, 2.5);
std::tuple<int, double, string> tp3 = std::make_tuple(1, 2.5, "");
//std::tuple<int, double, string> tp3 = {1, 2.5, ""};
//std::tuple<int, double, string> tp3(1, 2.5, "");
```

可变参数模板类的参数个数可以为0个，所以下面的定义也是也是合法的：

```C++
std::tuple<> tp;
```

可变参数模板类的参数包展开的方式和可变参数模板函数的展开方式不同，可变参数模板类的参数包展开需要通过「模板特化」和「继承方式」去展开，展开方式比可变参数模板函数要复杂。下面我们来看一下展开可变参数模板类中的参数包的方法。

#### a) 模板偏特化和递归方式来展开参数包

可变参数模板类的展开一般需要定义两到三个类，包括「类声明」和「偏特化」的模板类。如下方式定义了一个基本的可变参数模板类：

```C++
#include <iostream>
using namespace std;

// 前向声明
template<typename... Args>
struct Sum;

// 基本定义
template<typename First, typename... Rest>
struct Sum<First, Rest...> {
    enum {
        value = Sum<First>::value + Sum<Rest...>::value
    };
};

// 递归终止
template<typename Last>
struct Sum<Last> {
    enum {
        value = sizeof(Last)
    };
};

int main() {
    cout << Sum<int, double, short>::value << endl; // 14
    // Sum<int, double, short> s;
    // cout << s.value << endl;                     // 4+8+2=14
    return 0;
}
```

这个 `Sum` 类的作用是在编译期计算出参数包中参数类型的 size 之和，通过 `Sum<int, double, short>::value` 就可以获取这3个类型的 size 之和为14。这是一个简单的通过可变参数模板类计算的例子，可以看到一个基本的可变参数模板应用类由三部分组成：

「第一部分」是：

```C++
template<typename... Args>
struct Sum;
```

它是前向声明，声明这个 `Sum` 类是一个可变参数模板类；

「第二部分」是类的定义：

```C++
template<typename First, typename... Rest>
struct Sum<First, Rest...> {
    enum {
        value = Sum<First>::value + Sum<Rest...>::value
    };
};
```

它定义了一个部分展开的可变参数模板类，告诉编译器如何递归展开参数包。

「第三部分」是特化的递归终止类：

```C++
template<typename Last>
struct Sum<Last> {
    enum {
        value = sizeof(Last)
    };
};
```

通过这个特化的类来终止递归。

```C++
template<typename First, typename... Args>
struct Sum<First, Rest...> {
    ...
};
```

这个前向声明要求 `Sum` 的模板参数至少有一个，因为可变参数模板中的模板参数可以有0个，有时候0个模板参数没有意义，就可以通过上面的声明方式来限定模板参数不能为0个。上面的这种三段式的定义也可以改为两段式的，可以将前向声明去掉，这样定义：

```C++
#include <iostream>
using namespace std;

// 基本模板类定义
template<typename First, typename... Rest>
struct Sum {
    enum {
        value = Sum<First>::value + Sum<Rest...>::value
    };
};

// 特化的终止函数
template<typename Last>
struct Sum<Last> {
    enum {
        value = sizeof(Last)
    };
};

int main() {
    cout << Sum<int, double, short>::value << endl; // 14
    // Sum<int, double, short> s;
    // cout << s.value << endl;                     // 4+8+2=14
    return 0;
}
```

上面的方式「只要」一个基本的「模板类定义」和一个「特化的终止函数」就行了，而且限定了模板参数至少有一个。

递归终止模板类可以有「多种写法」，比如上例的递归终止模板类还可以这样写：

```C++
#include <iostream>
using namespace std;

template<typename... Args>
struct Sum;

// 基本模板类定义
template<typename First, typename... Rest>
struct Sum<First, Rest...> {
    enum {
        value = sizeof(First) + Sum<Rest...>::value
    };
};

// 递归终止模板类
template<typename First, typename Last>
struct Sum<First, Last> {
    enum {
        value = sizeof(First) + sizeof(Last)
    };
};

int main() {
    // cout << Sum<>::value << endl;                   // error
    // cout << Sum<int>::value << endl;                // error
    cout << Sum<int, double>::value << endl;        // 12
    cout << Sum<int, double, short>::value << endl; // 14
    return 0;
}
```

在展开到最后两个参数时终止。

还可以在展开到0个参数时终止：

```C++
#include <iostream>
using namespace std;

template<typename... Args>
struct Sum;

// 基本模板类定义
template<typename First, typename... Rest>
struct Sum<First, Rest...> {
    enum {
        value = sizeof(First) + Sum<Rest...>::value
    };
};

// 递归终止模板类
template<>
struct Sum<> {
    enum {
        value = 0
    };
};

int main() {
    cout << Sum<>::value << endl;                   // 0
    cout << Sum<int>::value << endl;                // 4
    cout << Sum<int, double>::value << endl;        // 12
    cout << Sum<int, double, short>::value << endl; // 14
    return 0;
}
```

> ⚠️注：我一开始对递归终止条件那里的「展开到2个参数」和「展开到0个参数」的代码改来改去就是跑不通，发现是「基本模板类定义」那里出了问题，将一开始的Sum<First>::value改为sizeof(First)即可。对「展开到2个参数」的代码而言，若不进行「基本模板类定义」这里的修改，那只能保证传入的参数个数是>=2的偶数个，而当参数个数为奇数个时，就会报错，这里可以仔细想想为什么，那么对「展开到0个参数」的情况，同理，就不再赘述。

那么说到这里，想必大家都有个疑惑，可以看到不论是模板函数还是模板类的递归程序，都用到了enum做递归的数值计算。在模板元编程中，enum是一项重要手段。其主要解决的问题是：

1. `enum` 的「值由编译器在编译期间计算」
2. 利用递归算法和模板特化，可以让编译器在计算 `enum` 值时「递归产生一系列class」
   下面直接罗列一个求N的阶乘的代码，可以体会一下如何在模板中借助递归算法和模板特化来使用 `enum` 实现N的阶乘：

```C++
#include <iostream>
using namespace std;

template<int N>
class F {
public:
    enum {
        res = N * F<N-1>::res
    };
};

//递归终止条件
template<>
class F<1> {
public:
    enum {
        res = 1
    };
};

int main() {
    cout << F<4>::res << endl; // 24 = 1*2*3*4
    return 0;
}
```

C++模板元编程中有个重要的类叫做 `std::integral_constant`，用来定义类型的常量，其实可以使用 `std::integral_constant` 来消除枚举定义。利用 `std::integral_constant` 也可获得「编译期常量」的特性。源码之下了无秘密，`std::intergral_constant` 的源码如下：

```C++
template<typename _Tp, _Tp __v>
struct integral_constant {
    static constexpr _Tp value = __v;
    typedef _Tp value_type;
    typedef integral_constant<_Tp, __v> type;

    constexpr operator value_type() const noexcept { return value; }

#if __cplusplus > 201103L

#define __cpp_lib_integral_constant_callable 201304

    constexpr value_type operator()() const noexcept { return value; } //C++14起
#endif
};
```

本文对该模板类不做说明，我直接贴出相关文章：[ 🔗 C++11中type_traits中的基石 - integral_constant ](https://flushhip.blog.csdn.net/article/details/82993411)，等后面有机会我再单独搞一下这里。

因此，可以将前面的 `Sum` 例子改为这样：

```C++
#include <iostream>
using namespace std;

//前向声明
template <typename... Args>
struct Sum;

//基本定义
template <typename First, typename... Rest>
struct Sum<First, Rest...> : std::integral_constant<int, Sum<First>::value + Sum<Rest...>::value>
{};

//递归终止
template<typename Last>
struct Sum<Last> : std::integral_constant<int, sizeof(Last)>
{};

int main() {
    cout << Sum<int, double, short>::value << endl; // 14 = 4+8+2
    return 0;
}
```

#### b) 继承方式展开参数包
还可以通过继承方式来展开参数包，比如下面的例子就是通过继承的方式去展开参数包：

```C++
//整型序列的定义
template<int...>
struct IndexSeq {};

//继承方式，开始展开参数包
template<int N, int... Indexes>
struct MakeIndexes : MakeIndexes<N-1, N-1, Indexes...> {};

// 模板特化，终止展开参数包的条件
template<int... Indexes>
struct MakeIndexes<0, Indexes...> {
    using type = IndexSeq<Indexes...>;
};

int main() {
    using T = MakeIndexes<3>::type;
    cout << typeid(T).name() << endl; // IndexSeq<0, 1, 2>
    return 0;
}
```

其中 `MakeIndexes` 的作用是为了生成一个可变参数模板类的整数序列，「最终输出」的类型是：`struct IndexSeq<0, 1, 2>`。

`MakeIndexes` 继承于自身的一个「特化的」模板类，这个特化的模板类同时也在展开参数包，这个展开过程是通过继承发起的，直到遇到特化的终止条件展开过程才结束。`MakeIndexes<3>::type` 的展开过程是这样的：

```C++
MakeIndexes<3> : MakeIndexes<2, 2> {}
MakeIndexes<2, 2> : MakeIndexes<1, 1, 2> {}
MakeIndexes<1, 1, 2> : MakeIndexes<0, 0, 1, 2> {
    using type = IndexSeq<0, 1, 2>;
}
```

通过不断的继承递归调用，最终得到整型序列IndexSeq<0, 1, 2>。

如果不希望通过继承方式去生成整型序列，则可以通过下面的方式生成：

```C++
#include <iostream>
using namespace std;

//整型序列的定义
template <int...>
struct IndexSeq {};

// 非继承方式 开始展开参数包
template<int N, int... Indexes>
struct MakeIndexes {
    using type = typename MakeIndexes<N-1, N-1, Indexes...>::type;
};

// 模板特化 终止展开参数包的条件
template<int... Indexes>
struct MakeIndexes<0, Indexes...> {
    using type = IndexSeq<Indexes...>;
};

int main() {
    using T = MakeIndexes<3>::type;
    cout << typeid(T).name() << endl;
    return 0;
}
```

我们看到了如何利用「递归」以及「偏特化」等方法来展开「可变模板参数」，那么实际当中我们会怎么去使用它呢？我们可以用可变模板参数来消除一些重复的代码以及实现一些高级功能，下面我们来看看可变模板参数的一些应用。

## 可变参数模板消除重复代码

C++11 之前如果要写一个泛化的工厂函数，这个工厂函数能接受任意类型的入参，并且参数个数要能满足大部分的应用需求的话，我们不得不定义很多重复的模板定义，比如下面的代码：

```C++
template<typename T>
T *Instance() {
    return new T();
}

template<typename T, typename T0>
T *Instance(T0 arg0) {
    return new T(arg0);
}

template<typename T, typename T0, typename T1>
T *Instance(T0 arg0, T1 arg1) {
    return new T(arg0, arg1);
}

template<typename T, typename T0, typename T1, typename T2>
T *Instance(T0 arg0, T1 arg1, T2 arg2) {
    return new T(arg0, arg1, arg2);
}

template<typename T, typename T0, typename T1, typename T2, typename T3>
T *Instance(T0 arg0, T1 arg1, T2 arg2, T3 arg3) {
    return new T(arg0, arg1, arg2, arg3);
}

template<typename T, typename T0, typename T1, typename T2, typename T3, typename T4>
T *Instance(T0 arg0, T1 arg1, T2 arg2, T3 arg3, T4 arg4) {
    return new T(arg0, arg1, arg2, arg3, arg4);
}

struct A {
    A(int) {}
};
struct B {
    B(int, double) {}
};

A *pa = Instance<A>(1);
B *pb = Instance<B>(1, 2);
```

可以看到这个泛型工厂函数存在大量的重复的模板定义，并且限定了模板参数。用可变模板参数可以消除重复，同时去掉参数个数的限制，代码很简洁，通过可变参数模板优化后的工厂函数如下：

```C++
template<typename T, typename... Args>
T *Instance(Args... args) {
    return new T(args...);
}
```

在上面的实现代码 `T *Instance(Args... args)` 中，`Args` 是值拷贝的，存在性能损耗，可以通过完美转发来消除损耗，代码如下：

```C++
template<typename T, typename... Args>
T *Instance(Args&&... args) {
    return new T(std::forward<Args>(args)...);
}

struct A {
    A(int) {}
};
struct B {
    B(int, double) {}
};

A *pa = Instance<A>(1);
B *pb = Instance<B>(1, 2);
```

可变参数模板实现泛化的 `delegate`
C++ 中没有类似 C# 的委托，我们可以借助可变模板参数来实现一个。C# 中的委托的基本用法是这样的：

```C++
delegate int AggregateDelegate(int x, int y); // 声明委托类型

int Add(int x, int y) { return x + y; }
int Sub(int x, int y) { return x - y; }

AggregateDelegate add = Add;
add(1, 2); // 调用委托对象求和
AggregateDelegate sub = Sub;
sub(2, 1); // 调用委托对象相减
```

C# 中的委托的使用需要先定义一个委托类型，这个委托类型不能泛化，即委托类型一旦声明之后就不能再用来接受其它类型的函数了，比如这样用：

```C++
int Fun(int x, int y, int z) { return x + y + z; }
int Fun1(string s, string r) { return s.Length + r.Length; }
AggregateDelegate fun = Fun;   //编译报错，只能赋值相同类型的函数
AggregateDelegate fun1 = Fun1; //编译报错，参数类型不匹配
```

这里不能泛化的原因是声明委托类型的时候就限定了「参数类型」和「个数」，在 C++11 里不存在这个问题了，因为有了可变模板参数，它就代表了任意类型和个数的参数了，下面让我们来看一下如何实现一个功能更加泛化的 C++ 版本的委托（这里为了简单起见只处理成员函数的情况，并且忽略 `const、volatile` 和 `const volatile` 成员函数的处理）。

```C++
#include <iostream>
using namespace std;

template<typename T, typename R, typename... Args>
class MyDelegate {
public:
    MyDelegate(T *t, R (T::*f)(Args...)) : m_t(t), m_f(f) {}

    R operator()(Args&&... args) {
        return (m_t->*m_f)(std::forward<Args>(args)...);
    }

private:
    T *m_t;
    R (T::*m_f)(Args...);   // 函数指针
};

template<typename T, typename R, typename... Args>
MyDelegate<T, R, Args...> CreateDelegate(T *t, R (T::*f)(Args...)) {
    return MyDelegate<T, R, Args...>(t, f);
}

struct A {
    void Fun(int i ) { cout << i << endl; }
    void Fun1(int i, double j) { cout << i+j << endl; }
};

int main() {
    A a;
    auto d = CreateDelegate(&a, &A::Fun);   // 创建委托
    d(1);                                   // 调用委托 将输出1
    auto d1 = CreateDelegate(&a, &A::Fun1); // 创建委托
    d1(1, 2.5);                             // 调用委托 将输出3.5
    return 0;
}
```

`MyDelegate` 实现的「关键」是内部定义了一个能接受任意类型和参数个数的「万能函数」：`R  (T::*m_f)(Args...)`，正是由于「可变模板参数」的特性，所以我们才能够让这个 m_f 接受任意参数。

总结
使用可变模板参数的这些技巧相信读者看了会有耳目一新之感，使用可变模板参数的关键是如何展开参数包，展开参数包的过程是很精妙的，体现了泛化之美、递归之美，正是因为它具有神奇的「魔力」，所以我们可以更泛化的去处理问题，比如用它来消除重复的模板定义，用它来定义一个能接受任意参数的「万能函数」等。其实，可变模板参数的作用远不止文中列举的那些作用，它还可以和其它 C++11 特性结合起来，比如 `type_traits`、`std::tuple` 等特性，发挥更加强大的威力。

