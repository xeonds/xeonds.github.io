---
title: PHP中三种鬼畜符号的用法
tags:
  - PHP
excerpt: 说实话，PHP的语法——尤其是符号，相当奇怪。除了PHP，你见过谁家变量是$开头的啊（笑
toc: true
author: xeonds
date: '2021.07.18 23:56:48'
categories:
  - 计算机科学
  - 编程语言
  - PHP
---

## =>的用法

在php中数组默认键名是整数，也可以自己定义任意字符键名（最好是有实际意义），如：

```
$css=array('style'=>'0'，‘color’=>‘green‘)；
　则$css['style']=='0'，$css['color']=='green'。

```

## ->的用法

用来引用对象的成员（属性与方法）。相当于其他语言中的“.”。

```
  $arr=['a'=>123,'b'=>456];//数组初始化
  echo $arr['a'];//数组引用
  print_r($arr);//查看数组
  class A{
    public $a=123;
    public $b=456;
  }
  $obj=new A();
  echo $obj->a;//对象引用
  print_r($obj);//查看对象
?>
```

输出结果：

```
123Array(
    [a] => 123
    [b] => 456)
123A Object(
    [a] => 123
    [b] => 456)
```

## ::的用法

双冒号操作符即作用域限定操作符Scope Resolution Operator可以访问静态、const和类中重写的属性与方法。

（1）Program List：用变量在类定义外部访问

```
class Fruit {
    const CONST_VALUE = 'Fruit Color';
}
  
$classname = 'Fruit';
echo $classname::CONST_VALUE; // As of PHP 5.3.0
echo Fruit::CONST_VALUE;
?>
```

（2）Program List：在类定义外部使用::

```
class Fruit {
    const CONST_VALUE = 'Fruit Color';
}

class Apple extends Fruit
{
    public static $color = 'Red';
    public static function doubleColon() {
        echo parent::CONST_VALUE . "\n";
        echo self::$color . "\n";
    }
}

Apple::doubleColon();
?>
```

（3）Program List：调用parent方法

```
class Fruit
{
    protected function showColor() {
        echo "Fruit::showColor()\n";
    }
}
  
class Apple extends Fruit
{
    // Override parent's definition
    public function showColor()
    {
        // But still call the parent function
        parent::showColor();
        echo "Apple::showColor()\n";
    }
}
 
$apple = new Apple();
$apple->showColor();
?>
```

（4）Program List：使用作用域限定符

```
    class Apple
    {
        public function showColor()
        {
            return $this->color;
        }
    }
 
    class Banana12     {
        public $color;
        public function __construct()
        {
            $this->color = "Banana is yellow";
        }
 
        public function GetColor()
        {
            return Apple::showColor();
        }
    }

    $banana = new Banana;
    echo $banana->GetColor();
?>
```

（5）Program List：调用基类的方法

```
class Fruit
{
    static function color()
    {
       return "color";
    }
 
    static function showColor()
    {
        echo "show " . self::color();
    }
}
 
class Apple extends Fruit
{
    static function color()
    {
        return "red";
    }
}
 
Apple::showColor();
// output is "show color"!
?>
```
