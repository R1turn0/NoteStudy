# Qt QLineEdit限制输入类型

1. 只允许输入整型
```
ui->lineEdit->setValidator(new QIntValidator(ui->lineEdit));
```
2. 只允许输入数字
```
ui->lineEdit->setValidator(new QRegExpValidator(QRegExp("[0-9]+$")));   
```
3. 只能输入字母和数字
```
ui->lineEdit->setValidator(new QRegExpValidator(QRegExp("[a-zA-Z0-9]+$")));   
```
3.1 只能输入大写数据：
```
ui->lineEdit->setValidator(new QRegExpValidator(QRegExp("^[A-Z]+$")));   
```
3.2 只能输入小写数据：
```
ui->lineEdit->setValidator(new QRegExpValidator(QRegExp("^[a-z]+$")));   
```
3.3 只能输入字母：
```
ui->lineEdit->setValidator(new QRegExpValidator(QRegExp("^[A-Za-z]+$")));   
```
4. 输入浮点型数据
```
非负浮点数（正浮点数 + 0）："^\d+(\.\d+)?$"
正浮点数："^(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*))$"
非正浮点数（负浮点数 + 0）："^((-\d+(\.\d+)?)|(0+(\.0+)?))$"
负浮点数："^(-(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*)))$"　
浮点数："^(-?\d+)(\.\d+)?$"
```
5. 输入-255~255的整数：
```
ui->lineEdit->setValidator(new QRegExpValidator(QRegExp("^-?(255|[1,2]?[0-4]?\\d|[1,2]?5[0-4]?)$")));  
```
6. 限制浮点数输入范围为[-90,90]并限定为小数位后4位：
```
ui->lineEdit->setValidator(new QRegExpValidator(QRegExp rx("^-?(90|[1-8]?\\d(\\.\\d{1,4})?)$");  );  
```
7. 输入格式 （年-月-日）：
```
ui->lineEdit->setValidator(new QRegExpValidator(QRegExp("^(d{2}|d{4})-((0([1-9]{1}))|(1[1|2]))-(([0-2]([1-9]{1}))|(3[0|1]))$")));  
```
7.1 输入格式（月/日/年）：
```
ui->lineEdit->setValidator(new QRegExpValidator(QRegExp("^((0([1-9]{1}))|(1[1|2]))/(([0-2]([1-9]{1}))|(3[0|1]))/(d{2}|d{4})$" )));  
```
8. 只能中文 输入：
```
ui->lineEdit->setValidator(new QRegExpValidator(QRegExp("[\u4e00-\u9fa5]+$")));   
```