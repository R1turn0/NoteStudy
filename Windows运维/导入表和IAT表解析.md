# 导入表

### 前言

 PE文件中的导入表输入表含有三个重要结构**IID，INT，IAT**。PE文件为需要加载的DLL文件创建一个IID结构，一个DLL与一个IID对应。INT是输入名称表，IAT输入地址表，在没有绑定输入的情况下磁盘中的文件INT与IAT相同。如果有绑定输入的话因为绑定输入的函数其磁盘文件中的IAT项就已经是对应函数的地址了，所以INT与IAT就不同了。 

### 一、导入表

导入表的定义如下

````
typedef struct _IMAGE_IMPORT_DESCRIPTOR {
    union {
        DWORD   Characteristics;            // 0 for terminating null import descriptor
        DWORD   OriginalFirstThunk;         // RVA to original unbound IAT (PIMAGE_THUNK_DATA)
    };
    DWORD   TimeDateStamp;                  // 0 if not bound,
                                            // -1 if bound, and real date\time stamp
                                            //     in IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT (new BIND)
                                            // O.W. date/time stamp of DLL bound to (Old BIND)

    DWORD   ForwarderChain;                 // -1 if no forwarders
    DWORD   Name;
    DWORD   FirstThunk;                     // RVA to IAT (if bound this IAT has actual addresses)
} IMAGE_IMPORT_DESCRIPTOR;
````

更加注意：OriginalFirstThunk、Name、FirstThunk

1. OriginalFirstThunk是只想INT表的RVA
2. Name是DLL的文件名
3. FirstThunk是只想IAT表的RVA

OriginalFirstThunk和FirstThunk只想相同的结构体IMAGE_THUNK_DATA，这两个结构体又指向同一个结构体IMAGE_THUNK_DATA32，也就是双桥结构

```
struct _IMAGE_THUNK_DATA32{
    union {
        DWORD ForwarderString 
        DWORD Function ; //被输入的函数的内存地址
        DWORD Ordinal ; //被输入的API的序数值
       DWORD AddressOfData ; //高位为0则指向IMAGE_IMPORT_BY_NAME 结构体二
    }u1;
}IMAGE_THUNK_DATA32;
```

```
typedef struct _IMAGE_IMPORT_BY_NAME{
    WORD Hint;      //序号
    BYTE NAME[1];   //函数名
}IMAGE_IMPORT_BY_NAME,*PIMAGE_IMPORT_BY_NAME；
```



``` ```