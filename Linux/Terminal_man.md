# Man Page

一般UNIX/Linux系统中的指令都会附带上相关的线上说明手册（man page）提供使用者查询和参考。



### 基本查询

man指令加上要查询的说明主题来阅读线上手册，主题的名称就是指令或者函数的名称。

```
man function
```



### 一. 指定章节

Linux的线上手册分为几个主要的章节（sections），每个章节对应不同的类别：

> 1  Executable programs or shell commands
>
> 2  System calls (functions provided by the kernel)
>
> 3  Library calls (functions within program libraries)
>
> 4  Special files (usually found in /dev)
>
> 5  File formats and conventions eg /etc/passwd
>
> 6  Games
>
> 7  Miscellaneous (including macro packages and conventions), e.g. man(7), groff(7)
>
> 8  System administration commands (usually only for root)
>
> 9  Kernel routines [Non standard]

译：

> 1. 可执行的程序或是shell指令
> 2. 系统呼叫（system calls, Linux核心提供的参数）
> 3. 一般函式库函数
> 4. 特殊档案（通常位于/dev）
> 5. 档案格式与协定，如/etc/passwd
> 6. 游戏
> 7. 杂项（巨集等，如man(7)、groff(7)）
> 8. 系统管理者指令（通常是管理者root专用的）
> 9. Kernel routines（非标准）

而在線上手冊中的文件都會以小括弧來標明該文件所屬的章節，例如 `LS(1)` 就代表這份文件隸屬於第 `1` 個章節。 

有些時候一個主題名稱在不同章節中有不同的說明文件，如果查詢一個主題的時候沒有指定章節，預設會依照 `1 n l 8 3 2 3posix 3pm 3perl 5 4 9 6 7` 這個順序來搜尋，然後顯示第一個搜尋到的章節。 

例如 `passwd` 這個主題有 `passwd(1)` 與 `passwd(5)` 兩個章節，如果不指定章節的話：

```
man passwd
```

就會顯示 `passwd(1)`，而若要查詢 `passwd(5)` 的話，就要明確指定章節數：

```
man 5 passwd
```



### 二. 列出所有章节

有時候我們對於某個主題有興趣，但是卻不知道該主題有哪些章節可以查詢，這時候就可以使用 `-aw` 參數查詢：

```
man -aw printf
```

輸出為

> /usr/share/man/man1/printf.1.gz
> /usr/share/man/man3/printf.3.gz

這樣我們就可以知道 `printf` 這個主題有兩份說明文件，一份在第 1 個章節，另一份在第 3 個章節，所以我們可以用下面兩個指令來查詢：

```
man printf
man 3 printf
```



### 三. 一次查阅所有章节

如果要一次查閱一個主題的所有章節，可以使用 `-a` 參數，這樣 `man` 會依序顯示所有的章節：

```
man -a printf
```

當您看完一個章節並按下 `q` 離開之後，它就會顯示

> --Man-- next: printf(3) [ view (return) | skip (Ctrl-D) | quit (Ctrl-C) ]

接著按下 `Enter` 鍵即可繼續閱讀下一個章節。



### 四. 搜索线上手册

若想要在所有的線上手冊中以關鍵字搜尋，可以使用 `-k` 參數，並指定要搜尋的字眼：

```
man -k printf
```

輸出會類似這樣

> asprintf (3) -- print to allocated string
> dprintf (3) -- print to a file descriptor
> fprintf (3) -- formatted output conversion
> fwprintf (3) -- formatted wide-character output conversion
> printf (1) -- format and print data
> [略]

man` 在搜尋時其實是以正規表達式（regular expression）來比對的，所以您可以使用任何正規表達式來做更複雜的搜尋，例如搜尋 `s` 開頭，並且包含 `printf` 字眼的文件：

```
man -k "^s.*printf"
```

輸出為

> snprintf (3) -- formatted output conversion
> sprintf (3) -- formatted output conversion
> swprintf (3) -- formatted wide-character output conversion

另外也可以使用 `apropos` 指令來搜尋：

```
apropos "^s.*printf"
```



### 五. 使用浏览器显示线上手册

如果您喜歡瀏覽器來查看說明文件，可以使用 `-H` 參數，並指定要使用的瀏覽器：

```
man -Hfirefox printf
```

畫面會像這樣

[Photo]

如果您在使用 `-H` 這個參數時，出現這樣的錯誤：

> man: command exited with status 3: /usr/lib/man-db/zsoelim | /usr/lib/man-db/manconv -f UTF-8:ISO-8859-1 -t UTF-8//IGNORE | preconv -e UTF-8 | tbl | groff -mandoc -Thtml

就表示系統可能沒裝 `groff`，請先用 apt 安裝：

```
sudo apt-get install groff
```



### 六. 指定分页程式（Pager）

顯示文件用的分頁程式，可以使用 `-P` 參數指定：

```
man -P more printf
```



### 七. 将线上手册存储为文字档、网页或PDF

有時候我們會想要將線上手冊儲存成一般的檔案，方便用其他的方式來查閱，若要儲存成一般的文字檔可以使用：

```
man printf | col -b > printf.txt
```

將線上手冊儲存為 HTML 網頁檔：

```
zcat `man -w printf` | groff -mandoc -T html > printf.html
```

將線上手冊儲存為 PDF 檔：

```
man -t printf | ps2pdf - > printf.pdf
```



### 八. 指定语言

 現在很多線上手冊都有中文翻譯，如果您的 Linux 系統設定為中文語系，可能就有機會看到中文的說明文件 

如果想要看原文的話（尤其是翻譯翻的不好的時候），可以用 `-L` 指定語系：

```
man -L en 5 passwd
```

**man中文手册安装方法**

中文man对英文不是很好的朋友来说,可以起到一点帮助作用。不过要学好linux,就不能太依赖这个东东,毕竟学好英语才是王道。

官方网站:http://cmpp.linuxforum.net

这个是源码的：http://manpages-zh.googlecode.com/files/manpages-zh-1.5.1.tar.gz

现在下载安装包:

wget http://manpages-zh.googlecode.com/files/manpages-zh-1.5.1.tar.gz

操作步骤如下:

> \#tar -zxvf manpages-zh-1.5.1.tar.gz   
>
> \#cd manpages-zh-1.5.1
>
> \#./configure --prefix=/usr/local/zhman --disable-zhtw       
>
> \#make
>
> \#make install

以上安装完成.请做如下操作:

> \#cd ~
>
> \#vi .bashrc

在.bashrc中增加:

alias cman='man -M /usr/local/zhman/share/man/zh_CN'     

> \#source .bashrc     //在命令行执行，为了使刚刚添加的alias生效



### 九. 彩色文件

 將文件的關鍵字加上色彩可以讓人閱讀起來更舒服，在 `~/.bashrc` 中加入以下的色彩設定 

