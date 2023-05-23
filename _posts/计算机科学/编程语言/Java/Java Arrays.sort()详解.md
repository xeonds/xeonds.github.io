---
title: Java Arrays.sort()详解
date: '2022.11.22 19:04:01'
author: xeonds
toc: true
excerpt: Java practice note.
categories:
  - 计算机科学
  - 编程语言
  - Java
tags:
---
## 一、介绍

Arrays.sort()是经过调优排序算法，性能能达到n\*log(n)。Arrays.sort()重载了四类方法

- sort(T[] a)：对指定T型数组按数字升序排序。
- sort(T[] a,int formIndex, int toIndex)：对指定T型数组的指定范围按数字升序排序。
- sort(T[] a, Comparator<\? supre T> c): 根据指定比较器产生的顺序对指定对象数组进行排序。
- sort(T[] a, int formIndex, int toIndex, Comparator<\? supre T> c): 根据指定比较器产生的顺序对指定对象数组的指定对象数组进行排序。

### 1、sort(T[] a)

对指定T型数组按数字升序排序。

```java
import java.util.Arrays;
import java.util.Comparator;

public class ArraysSort {
    public static void main(String[] args) {
        int[] a={2,5,4,3,1,8};
        Arrays.sort(a);
        System.out.println(Arrays.toString(a));
    }
}  
  
// 结果  
// [1, 2, 3, 4, 5, 8]  
```

### 2、sort(T[] a,int formIndex, int toIndex)

对指定T型数组的指定范围按数字升序排序。

```java
import java.util.Arrays;
import java.util.Comparator;

public class ArraysSort {
    public static void main(String[] args) {
        int[] a={2,5,4,3,1,8};
        Arrays.sort(a,2,5);
        System.out.println(Arrays.toString(a));
    }
}

// 结果
// [2, 5, 1, 3, 4, 8]
```

### 3、sort(T[] a, Comparator<\? supre T> c)

根据指定比较器产生的顺序对指定对象数组进行排序。

#### （1）按第一维元素比较二维数组

```java
import java.util.Arrays;
import java.util.Comparator;

public class ArraysSort {
    public static void main(String[] args) {
        int[][] nums=new int[][]{{1,3},{1,2},{4,5},{3,7}};
        //方法一
        Arrays.sort(nums,new Comparator<int[]>(){
            @Override
            public int compare(int[] a,int[] b){
                if(a[0]==b[0]){
                    return a[1]-b[1];
                }else{
                    return a[0]-b[0];
                }
            }
        });


        // 方法二，使用匿名表达式
        // (a,b)->a[1]-b[1]会自动转变成上面的形式
        /*Arrays.sort(nums,(a,b)->a[1]-b[1]);*/
        for (int[] num : nums) {
            System.out.println(Arrays.toString(num));
        }

        int[] a={2,5,4,3,1,8};
        Arrays.sort(a,2,5);
        System.out.println(Arrays.toString(a));
    }
}

// 结果
/*
[1, 2]
[1, 3]
[3, 7]
[4, 5]
*/
```

#### （2）按第二维元素比较二维数组

```java
import java.util.Arrays;
import java.util.Comparator;

public class ArraysSort {
    public static void main(String[] args) {
        int[][] nums=new int[][]{{1,3},{1,2},{4,5},{3,7}};
        //方法一
        Arrays.sort(nums,new Comparator<int[]>(){
            @Override
            public int compare(int[] a,int[] b){
                if(a[1]==b[1]){
                    return a[0]-b[0];
                }else{
                    return a[1]-b[1];
                }
            }
        });

        //方法二
        /*Arrays.sort(nums,(a,b)->a[1]-b[1]);*/
        for (int[] num : nums) {
            System.out.println(Arrays.toString(num));
        }

    }
}
// 结果
/*
[1, 2]
[1, 3]
[4, 5]
[3, 7]
*/
```

其实这个方法最重要的还是**类对象的比较**。由于我们可以自定义比较器，所以我们可以使用策略模式，使得在运行时选择不同的算法。

```java
import java.util.Arrays;
import java.util.Comparator;

class Dog{
    int size;
    int weight;

    public Dog(int s, int w){
        size = s;
        weight = w;
    }
}

class DogSizeComparator implements Comparator<Dog>{

    @Override
    public int compare(Dog o1, Dog o2) {
        return o1.size - o2.size;
    }
}

class DogWeightComparator implements Comparator<Dog>{

    @Override
    public int compare(Dog o1, Dog o2) {
        return o1.weight - o2.weight;
    }
}

public class ArraysSort {
    public static void main(String[] args) {
        Dog d1 = new Dog(2, 50);
        Dog d2 = new Dog(1, 30);
        Dog d3 = new Dog(3, 40);

        Dog[] dogArray = {d1, d2, d3};
        printDogs(dogArray);

        Arrays.sort(dogArray, new DogSizeComparator());
        printDogs(dogArray);

        Arrays.sort(dogArray, new DogWeightComparator());
        printDogs(dogArray);
    }

    public static void printDogs(Dog[] dogs){
        for(Dog d: dogs)
            System.out.print("size="+d.size + " weight=" + d.weight + " ");

        System.out.println();
    }
}

// 结果
/*
size=2 weight=50 size=1 weight=30 size=3 weight=40 
size=1 weight=30 size=2 weight=50 size=3 weight=40 
size=1 weight=30 size=3 weight=40 size=2 weight=50 
*/
```

那么在参数中会出现super呢？这意味着这类型**可以是T或者它的父类型**。这就使得该方法可以允许所有子类使用相同的比较器。详细见代码：

```java
import java.util.Arrays;
import java.util.Comparator;

class Animal{
    int size;
}

class Dog extends Animal{
    public Dog(int s){
        size = s;
    }
}

class Cat extends Animal{
    public Cat(int s){
        size  = s;
    }
}

class AnimalSizeComparator implements Comparator<Animal>{
    @Override
    public int compare(Animal o1, Animal o2) {
        return o1.size - o2.size;
    }
}

public class ArraysSort {
    public static void main(String[] args) {
        Dog d1 = new Dog(2);
        Dog d2 = new Dog(1);
        Dog d3 = new Dog(3);

        Dog[] dogArray = {d1, d2, d3};
        printDogs(dogArray);

        Arrays.sort(dogArray, new AnimalSizeComparator());
        printDogs(dogArray);

        System.out.println();
        
        Cat c1 = new Cat(2);
        Cat c2 = new Cat(1);
        Cat c3 = new Cat(3);

        Cat[] catArray = {c1, c2, c3};
        printDogs(catArray);

        Arrays.sort(catArray, new AnimalSizeComparator());
        printDogs(catArray);
    }

    public static void printDogs(Animal[] animals){
        for(Animal a: animals)
            System.out.print("size="+a.size + " ");
        System.out.println();
    }
}

// 结果
/*
size=2 size=1 size=3 
size=1 size=2 size=3 

size=2 size=1 size=3 
size=1 size=2 size=3 
*/
```

### 4、sort(T[] a, int formIndex, int toIndex, Comparator<\? supre T> c)

根据指定比较器产生的顺序对指定对象数组的指定对象数组进行排序。

```java
import java.util.Arrays;
import java.util.Comparator;

public class ArraysSort {
    public static void main(String[] args) {
        int[][] nums=new int[][]{{1,3},{1,2},{4,5},{3,7}};
        
        Arrays.sort(nums,2,4,new Comparator<int[]>(){
            @Override
            public int compare(int[] a,int[] b){
                if(a[0]==b[0]){
                    return a[1]-b[1];
                }else{
                    return a[0]-b[0];
                }
            }
        });
    }
}

// 结果
/*
[1, 3]
[1, 2]
[3, 7]
[4, 5]
可以看到只对第三行和第四行排序了
*/
```
